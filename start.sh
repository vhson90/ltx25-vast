#!/bin/bash
set -e

ROOT=/opt/ltx
COMFY=$ROOT/ComfyUI
APP=$ROOT/ltx25-ia2v-comfyui

mkdir -p /workspace/logs

echo "===================================="
echo "LTX-2.5 IA2V STARTING"
echo "===================================="

$ROOT/download_models.sh

echo "Starting ComfyUI..."

cd "$COMFY"

/venv/main/bin/python main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    > /workspace/logs/comfyui.log 2>&1 &

COMFY_PID=$!

echo "Waiting for ComfyUI..."

READY=0

for i in $(seq 1 180); do

    if curl -sf \
        http://127.0.0.1:8188/system_stats \
        >/dev/null; then

        READY=1
        echo "ComfyUI READY"
        break
    fi

    sleep 2

done

if [ "$READY" != "1" ]; then

    echo "ComfyUI failed"

    tail -100 \
        /workspace/logs/comfyui.log

    exit 1
fi

echo "Starting IA2V UI..."

cd "$APP"

/venv/main/bin/python ltx_ui.py \
    > /workspace/logs/ltx-ui.log 2>&1 &

echo "===================================="
echo "SYSTEM READY"
echo "ComfyUI :8188"
echo "IA2V UI :7860"
echo "===================================="

wait $COMFY_PID
