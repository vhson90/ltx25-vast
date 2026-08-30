FROM vastai/pytorch:2.6.0-cuda-12.6.3-py312

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV HF_HOME=/workspace/hf-cache

RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    ffmpeg \
    nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ltx

RUN /venv/main/bin/pip install --upgrade pip

# ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git

RUN /venv/main/bin/pip install \
    -r /opt/ltx/ComfyUI/requirements.txt

# LTX 2.5 IA2V application
RUN git clone \
    https://github.com/djbroiti/ltx25-ia2v-comfyui.git

RUN /venv/main/bin/pip install \
    -r /opt/ltx/ltx25-ia2v-comfyui/requirements.txt

RUN /venv/main/bin/pip install \
    "huggingface_hub[cli]"

COPY start.sh /opt/ltx/start.sh
COPY download_models.sh /opt/ltx/download_models.sh

RUN chmod +x /opt/ltx/start.sh
RUN chmod +x /opt/ltx/download_models.sh

EXPOSE 8188
EXPOSE 7860

CMD ["/opt/ltx/start.sh"]
