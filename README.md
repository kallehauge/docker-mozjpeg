# Docker MozJPEG

A Docker container for MozJPEG, Mozilla's improved JPEG encoder that achieves higher visual quality and smaller file sizes. This container automatically uses the latest stable release of MozJPEG.

## Features

- Uses the latest stable release of MozJPEG (automatically detected during build)
- Multi-stage build for minimal image size
- Based on Ubuntu 24.04 LTS (Noble Numbat)
- Optimized for both build time and runtime performance

## Prerequisites

- Docker installed on your system
- Basic understanding of Docker commands

## Building the Image

Build the Docker image using:

```bash
docker build -t mozjpeg .
```

This will:
1. Download the Ubuntu 24.04 LTS base image
2. Install all necessary build dependencies
3. Automatically detect and clone the latest stable MozJPEG release
4. Build MozJPEG with optimizations
5. Create a minimal runtime image with only required dependencies

The build process uses a multi-stage build to keep the final image size small. You'll see the MozJPEG version being used during the build process.

## Usage

### Basic Usage

The container uses `cjpeg` (MozJPEG's encoder) as its entrypoint. To compress a JPEG image:

```bash
docker run -v .:/data mozjpeg -quality 85 input.jpg > output.jpg
```

### Command Options

MozJPEG's `cjpeg` supports various options. Here are some common ones:

- `-quality N`: Set quality to N (0-100, default 75)
- `-optimize`: Optimize Huffman tables
- `-progressive`: Create progressive JPEG
- `-arithmetic`: Use arithmetic coding
- `-targa`: Input file is Targa format

Example with multiple options:

```bash
docker run -v $(pwd):/data mozjpeg -quality 85 -optimize -progressive input.jpg > output.jpg
```

### Batch Processing

To process multiple images in a directory:

```bash
# For all jpg files in current directory
for file in *.jpg; do
    docker run -v $(pwd):/data mozjpeg -quality 85 "$file" > "compressed_$file"
done
```

## Image Details

The Docker image is optimized for both size and performance:

- Uses multi-stage build to minimize final image size
- Based on Ubuntu 24.04 LTS for long-term support and reliable package management
- Runtime dependencies are minimal:
  - `libpng16-16` for PNG support
  - `zlib1g` for compression support
- Build tools and dependencies are removed from the final image
- Package lists are cleaned up during build to reduce image size
- Automatically uses the latest stable MozJPEG release
- Installs MozJPEG to `/opt/mozjpeg` for clean separation from system files

## Notes

- Output is written to stdout, so use redirection (`>`) to save the output
- The container uses MozJPEG's default settings unless overridden by command-line options
- The MozJPEG version is automatically selected during build and logged

## Troubleshooting

If you encounter any issues:

1. Ensure the input file exists and is readable
2. Check that you have write permissions in the output directory
3. Verify the Docker image was built successfully
4. Make sure you're using the correct file paths relative to your current directory
5. Check the build logs to see which MozJPEG version was used

## License

MozJPEG is licensed under the BSD license. See the [MozJPEG repository](https://github.com/mozilla/mozjpeg) for details.