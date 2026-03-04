#!/usr/bin/env bash

set -e

SCRIPT="final_oc.sh"

echo "========================================"
echo " OpenClaw Auto Fix Script"
echo " Fix llama.cpp build error"
echo "========================================"

echo "[1/6] Checking installer script..."

if [ ! -f "$SCRIPT" ]; then
    echo "ERROR: $SCRIPT tidak ditemukan"
    exit 1
fi

echo "[2/6] Backup installer..."

cp $SCRIPT ${SCRIPT}.backup

echo "[3/6] Fix llama.cpp build command..."

sed -i 's/make -j$(nproc)/cmake -B build\ncmake --build build -j$(nproc)/g' $SCRIPT

echo "[4/6] Fix llama-server path..."

sed -i 's|./llama.cpp/server|./llama.cpp/build/bin/llama-server|g' $SCRIPT

echo "[5/6] Cleaning failed build..."

if [ -d "$HOME/openclaw_ai/llama.cpp/build" ]; then
    rm -rf $HOME/openclaw_ai/llama.cpp/build
fi

echo "[6/6] Re-running installer..."

chmod +x $SCRIPT

./$SCRIPT

echo ""
echo "========================================"
echo " FIX COMPLETED"
echo "========================================"
echo ""
echo "Jika instalasi berhasil:"
echo "Open browser:"
echo "http://localhost:3000"
