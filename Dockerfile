FROM nvidia/cuda:12.2.0-runtime-ubuntu22.04

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

ENV NUMBA_CACHE_DIR=/tmp/numba_cache
RUN mkdir -p /tmp/numba_cache && chmod 777 /tmp/numba_cache

# Install Python and system deps
RUN apt-get update && apt-get install -y \
    python3 python3-pip git wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --upgrade pip

# Install PyTorch with CUDA 12.1 (compatible with 12.2 runtime)
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install cuDNN 9 (runtime + dev) manually
RUN wget https://developer.download.nvidia.com/compute/cudnn/redist/cudnn/linux-x86_64/cudnn-linux-x86_64-9.1.0.70_cuda12-archive.tar.xz -O /tmp/cudnn.tar.xz && \
    mkdir -p /usr/local/cudnn && \
    tar -xJf /tmp/cudnn.tar.xz -C /usr/local/cudnn --strip-components=1 && \
    rm /tmp/cudnn.tar.xz && \
    cp /usr/local/cudnn/include/* /usr/local/cuda/include/ && \
    cp /usr/local/cudnn/lib/* /usr/local/cuda/lib64/ && \
    ldconfig

# Install rembg with GPU extras + all CLI dependencies
RUN pip3 install \
    rembg[gpu] \
    click \
    filetype \
    watchdog \
    pillow \
    tqdm \
    scipy \
    aiohttp \
    numpy \
    onnxruntime-gpu \
    gradio \
    asyncer

# Copy patched rembg session files
COPY patch/base.py /usr/local/lib/python3.10/dist-packages/rembg/sessions/base.py
COPY patch/sam.py  /usr/local/lib/python3.10/dist-packages/rembg/sessions/sam.py
COPY patch/cli.py /usr/local/lib/python3.10/dist-packages/rembg/cli.py


# Default command: show rembg help
ENTRYPOINT ["rembg"]
