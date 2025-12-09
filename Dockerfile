# Step 1: Start from the perfect base image we identified earlier.
FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# Step 2: Set environment variables for non-interactive installs and UV fixes.
ENV DEBIAN_FRONTEND=noninteractive
ENV UV_HTTP_TIMEOUT=300
ENV UV_LINK_MODE=copy
ENV HF_HUB_ENABLE_HF_TRANSFER=1

# Step 3: Update, install essential system packages, and clean up to save space.
RUN apt-get update && \
    apt-get install -y --no-install-recommends git git-lfs ffmpeg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Step 4: Set the working directory and clone the repository.
WORKDIR /workspace
RUN git lfs install && \
    git clone https://github.com/index-tts/index-tts.git && \
    cd index-tts && \
    git lfs pull

# Step 5: Move into the repository directory for the next steps.
WORKDIR /workspace/index-tts

# Step 6: Install all Python dependencies using UV.
RUN pip install uv && \
    uv sync --all-extras

# Step 7: Pre-download all required models directly into the image.
# This ensures the pod starts instantly without needing to download on first run.
RUN uv run huggingface-cli download IndexTeam/IndexTTS-2 --local-dir ./checkpoints --local-dir-use-symlinks False && \
    uv run huggingface-cli download facebook/w2v-bert-2.0 --local-dir ./checkpoints/w2v-bert-2.0 --local-dir-use-symlinks False

# Step 8: Apply the WebUI fix to automatically enable the public Gradio share link.
RUN sed -i 's/demo.launch(/demo.launch(share=True, /' webui.py

# Step 9: Define the default command to run when the pod starts.
# This automatically launches the WebUI with the best performance settings.
CMD ["uv", "run", "webui.py", "--host", "0.0.0.0", "--fp16", "--deepspeed", "--cuda_kernel"]
