# rembg-gpu

GPU-accelerated background removal server based on [rembg](https://github.com/danielgatis/rembg).

## Features
- Runs in Docker with NVIDIA GPU support
- Exposes a REST API on port 7000
- Includes restart script and systemd service file for production use

## Quick Start
```bash
docker build -t rembg-gpu .
docker run --gpus all -p 7000:7000 rembg-gpu
