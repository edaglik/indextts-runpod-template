# Step 1: Start from the perfect base image.
FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# Step 2: Set environment variables and install UV (the package manager).
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_HTTP_TIMEOUT=300
ENV UV_LINK_MODE=copy
ENV HF_HUB_ENABLE_HF_TRANSFER=1

# Install only UV and its dependencies. This is the only RUN command needed.
RUN pip install uv

# Step 3: Set the working directory, where RunPod will execute the start command.
WORKDIR /workspace

# CMD is now optional or can be a simple placeholder, 
# as the RunPod Start Command will override it.
# CMD ["sleep", "infinity"]
