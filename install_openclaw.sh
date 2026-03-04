#!/usr/bin/env bash

set -e

echo "==========================================="
echo " OpenClaw AI - LOW RAM (4GB) Installer "
echo " Ubuntu 24.04 - CPU Only "
echo "==========================================="

# 1. Update system
echo "[1/7] Updating system..."
sudo apt update -y
sudo apt upgrade -y

# 2. Install minimal dependencies
echo "[2/7] Installing minimal packages..."
sudo apt install -y \
    git \
    curl \
    python3 \
    python3-venv \
    python3-pip \
    build-essential \
    libopenblas-dev

# 3. Increase swap (important for 4GB RAM)
echo "[3/7] Creating 4GB swap file..."
sudo swapoff -a || true
sudo rm -f /swapfile || true
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 4. Clone repository
echo "[4/7] Cloning OpenClaw..."
git clone https://github.com/openclawai/openclaw.git || true
cd openclaw

# 5. Create virtual environment
echo "[5/7] Creating Python virtual environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip setuptools wheel

# 6. Install dependencies WITHOUT heavy GPU packages
echo "[6/7] Installing lightweight dependencies..."
if [ -f "requirements.txt" ]; then
    pip install --no-cache-dir -r requirements.txt
fi

# 7. Reduce Python memory usage
echo "[7/7] Setting memory-friendly environment variables..."
echo "export PYTORCH_ENABLE_MPS_FALLBACK=1" >> ~/.bashrc
echo "export OMP_NUM_THREADS=2" >> ~/.bashrc
echo "export TOKENIZERS_PARALLELISM=false" >> ~/.bashrc

echo ""
echo "==========================================="
echo " INSTALLATION FINISHED (LOW RAM MODE)"
echo "==========================================="
echo ""
echo "IMPORTANT:"
echo "1. Reboot VM now."
echo "2. After reboot run:"
echo ""
echo "cd ~/openclaw"
echo "source venv/bin/activate"
echo "python main.py"
echo ""
echo "If memory error happens:"
echo "Use smaller model or run with:"
echo "OMP_NUM_THREADS=1 python main.py"
echo ""
