# Dockerfile (The only contents should be this for the lightweight image)

# Step 1: Start from the perfect base image.
FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# Step 2: Set environment variables.
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_HTTP_TIMEOUT=300
ENV UV_LINK_MODE=copy
ENV HF_HUB_ENABLE_HF_TRANSFER=1

# Step 3: Install only UV (the package manager) and its dependencies.
# This must be the only layer-creating RUN command apart from the base image.
RUN pip install uv

# Step 4: Set the working directory.
WORKDIR /workspace

# Step 5: CMD is optional, RunPod overrides it, but a placeholder is fine.
CMD ["sleep", "infinity"]
