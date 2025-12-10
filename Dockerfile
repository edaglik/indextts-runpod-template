# Use an official, smaller NVIDIA CUDA base image
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04 

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_HTTP_TIMEOUT=300
ENV UV_LINK_MODE=copy
ENV HF_HUB_ENABLE_HF_TRANSFER=1

# Install essential system packages needed for subsequent installs
# This RUN command is now necessary and must be performed here.
# It also includes installing pip, which is often missing in CUDA images.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip python3-dev \
    git git-lfs aria2 ffmpeg && \
    # Install uv immediately for efficiency
    pip3 install uv && \
    # Cleanup to save space (CRITICAL)
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /workspace

# CMD is just a placeholder, as the RunPod Start Command handles everything.
CMD ["sleep", "infinity"]
