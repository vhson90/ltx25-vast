#!/bin/bash
set -e

COMFY=/opt/ltx/ComfyUI

if [ -z "$HF_TOKEN" ]; then
    echo "ERROR: HF_TOKEN is not configured."
    exit 1
fi

mkdir -p "$COMFY/models/diffusion_models"
mkdir -p "$COMFY/models/text_encoders"
mkdir -p "$COMFY/models/vae"
mkdir -p "$COMFY/models/upscale_models"

echo "HF_TOKEN detected."
echo "Model directories ready."

echo "Model download stage will run here."
