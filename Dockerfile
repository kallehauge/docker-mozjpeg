# Build stage
FROM ubuntu:24.04 AS builder

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies and clean up in one layer
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    nasm \
    autoconf \
    automake \
    libtool \
    pkg-config \
    libpng-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone and build MozJPEG
WORKDIR /build
RUN LATEST_RELEASE=$(git ls-remote --tags --sort=-v:refname https://github.com/mozilla/mozjpeg.git 'v*' | grep -v '\^{}' | head -n1 | cut -d/ -f3) \
    && echo "Using MozJPEG version: $LATEST_RELEASE" \
    && git clone --branch $LATEST_RELEASE --depth 1 https://github.com/mozilla/mozjpeg.git . \
    && mkdir build \
    && cd build \
    && cmake -G"Unix Makefiles" .. \
    && make \
    && make install \
    && ldconfig

# Final stage
FROM ubuntu:24.04

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    libpng16-16 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Copy only the necessary files from builder
COPY --from=builder /opt/mozjpeg /opt/mozjpeg
COPY --from=builder /usr/local/lib /usr/local/lib

# Add MozJPEG bin directory to PATH
ENV PATH="/opt/mozjpeg/bin:${PATH}"

# Set up working directory
WORKDIR /data

# Set the entrypoint to cjpeg (MozJPEG's encoder)
ENTRYPOINT ["cjpeg"]