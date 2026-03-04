#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/openclaw_ai"

echo "======================================"
echo " OPENCLAW INSTALL REPAIR"
echo "======================================"

echo "[1/6] Stop old service if exists..."

sudo systemctl stop openclaw_ai || true

echo "[2/6] Cleaning broken installation..."

rm -rf $INSTALL_DIR/openclaw || true
rm -rf $INSTALL_DIR/llama.cpp || true

echo "[3/6] Cleaning failed builds..."

rm -rf $INSTALL_DIR/llama.cpp/build || true

echo "[4/6] Fix llama.cpp build system..."

if [ -f final_oc.sh ]; then

sed -i 's/make -j$(nproc)/cmake -B build\ncmake --build build -j$(nproc)/g' final_oc.sh

sed -i 's|./llama.cpp/server|./llama.cpp/build/bin/llama-server|g' final_oc.sh

fi

echo "[5/6] Running installer again..."

chmod +x final_oc.sh

./final_oc.sh

echo "[6/6] Installation repair complete."

echo ""
echo "Open browser:"
echo "http://localhost:3000"
