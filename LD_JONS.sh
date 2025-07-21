#!/usr/bin/env bash
set -euo pipefail
#set -x

# Print banner
cat <<'EOF'

┌──────────────────────────────────────────────────────────────────────────────────┐

  ░▒▓█▓▒░     ░▒▓██████▓▒░              ░▒▓█▓▒░░▒▓█████▓▒░░▒▓██████▓▒░░▒▓██████▓▒░ 
  ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░        
  ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░        
  ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░            ░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█████▓▒░  
  ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░    ░▒▓█▓▒░ 
  ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░    ░▒▓█▓▒░ 
  ░▒▓███████▓▒░▒▓███████▓▒░        ░▒▓█████▓▒░ ░▒▓█████▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓██████▓▒░  
                                                                                       
                                                                                       

                                LD Jetson Orin Nano Setup   
└──────────────────────────────────────────────────────────────────────────────────┘

EOF

# Usage: sudo ./setup_jetson_orin.sh [-b] [-v] [-l] [-o]
#   -b    Install Brave browser
#   -v    Install VS Code
#   -l    Install VLC
#   -o    Install OpenCV4.10.0 (with cuda)
#example: chmod +x setup_jetson_orin.sh
#sudo ./setup_jetson_orin.sh -b -v -l -o

INSTALL_BRAVE=false
INSTALL_VSCODE=false
INSTALL_VLC=false
INSTALL_OPENCV=false

while getopts "bvlo" opt; do
  case ${opt} in
    b) INSTALL_BRAVE=true ;;
    v) INSTALL_VSCODE=true ;;
    l) INSTALL_VLC=true ;;
    o) INSTALL_OPENCV=true ;;
    *) echo "Usage: $0 [-b] [-v] [-l] [-o]" >&2; exit 1 ;;
  esac
done

echo "---------------------------------------------------"
echo "LD Jetson Orin Nano Setup Script"
echo " Selected Options:"
echo "  Brave Browser:   $INSTALL_BRAVE"
echo "  VS Code:         $INSTALL_VSCODE"
echo "  VLC Media Player: $INSTALL_VLC"
echo "  OpenCV with CUDA:   $INSTALL_OPENCV"
echo "---------------------------------------------------"

if $INSTALL_OPENCV; then
  echo "[INFO] OpenCV 4.10.0 with CUDA support will take a while to install. Be patient!"
fi

echo "-------------------------------------------  ------"
echo "[1/9] Installing system & Python prerequisites..."
echo "---------------------------------------------------"
echo ""
sudo apt-get update
sudo apt-get install -y python3-pip libopenblas-dev apt-transport-https debconf-utils

echo "---------------------------------------------------"
echo "[2/9] Adding NVIDIA CUDA apt key & repo..."
echo "---------------------------------------------------"
echo ""
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/arm64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get install -y libcusparselt0 libcusparselt-dev

echo "---------------------------------------------------"
echo ""
echo "[3/9] Downloading and installing Torch & TorchVision..."
echo "---------------------------------------------------"
echo ""
wget https://github.com/ultralytics/assets/releases/download/v0.0.0/torchvision-0.20.0a0+afc54f7-cp310-cp310-linux_aarch64.whl
wget https://github.com/ultralytics/assets/releases/download/v0.0.0/torch-2.5.0a0+872d972e41.nv24.08-cp310-cp310-linux_aarch64.whl
pip3 install -U ./torch-2.5.0a0+872d972e41.nv24.08-cp310-cp310-linux_aarch64.whl \
                 ./torchvision-0.20.0a0+afc54f7-cp310-cp310-linux_aarch64.whl

echo "---------------------------------------------------"
echo ""                 
echo "[4/9] Installing Python packages via pip..."
echo "---------------------------------------------------"
echo ""
pip3 install --upgrade pip
pip3 install ultralytics opencv-contrib-python xmlschema loguru numpy==1.26.1

echo "---------------------------------------------------"
echo ""
echo "[5/9] Installing ONNX Runtime & ONNX tools..."
echo "---------------------------------------------------"
echo ""
pip3 install onnx onnxruntime "https://github.com/ultralytics/assets/releases/download/v0.0.0/onnxruntime_gpu-1.20.0-cp310-cp310-linux_aarch64.whl" || true

if $INSTALL_OPENCV; then

echo "---------------------------------------------------"
  echo "[6/9] Installing OpenCV4.10.0 with CUDA... Thanks to AastaNV!"
  echo "this will take a while, please be patient!"
  echo "---------------------------------------------------"
  echo ""
  # wget https://raw.githubusercontent.com/AastaNV/JEP/master/script/install_opencv4.10.0_Jetpack6.1.sh -O install_opencv4.sh
  # Thanks to AastaNV for the OpenCV install script
  bash ./install_opencv4.10.0_Jetpack6.1.sh -y
fi

echo "---------------------------------------------------"
echo ""
echo "[7/9] Installing Jetson stats & restarting jtop service..."
echo "---------------------------------------------------"
echo ""
sudo pip3 install -U jetson-stats
systemctl restart jtop.service || true

if $INSTALL_BRAVE; then
  echo "[8/9] Installing Brave browser..."
  curl -fsS https://dl.brave.com/install.sh | bash
fi

if $INSTALL_VLC; then
  echo "---------------------------------------------------"
  echo ""
  echo "[8/9] Installing VLC..."
  echo "---------------------------------------------------"
  echo ""
  sudo apt-get install -y vlc
fi

if $INSTALL_VSCODE; then
  echo "---------------------------------------------------"
  echo ""
  echo "[8/9] Installing VS Code..."
  echo "---------------------------------------------------"
  echo ""
  VERSION=latest
  wget -N -O vscode-linux-deb.arm64.deb https://update.code.visualstudio.com/$VERSION/linux-deb-arm64/stable
  sudo apt install ./vscode-linux-deb.arm64.deb
fi

echo "---------------------------------------------------"
echo ""
echo "[9/9] Verifying CUDA installation..."
echo "---------------------------------------------------"
echo ""
nvcc --version || echo "⚠️ nvcc not found; check your PATH."

echo "Updating ~/.bashrc with CUDA & local bin paths..."
BASHRC="$HOME/.bashrc"
grep -qxF 'export PATH="$PATH:/home/$(whoami)/.local/bin"'   $BASHRC || \
    echo 'export PATH="$PATH:/home/$(whoami)/.local/bin"' >> $BASHRC
grep -qxF 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}'   $BASHRC || \
    echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}'    >> $BASHRC
grep -qxF 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' $BASHRC || \
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> $BASHRC

echo "Cleaning up downloaded files..."
rm -f cuda-keyring_1.1-1_all.deb \
      torch-2.5.0a0+872d972e41.nv24.08-cp310-cp310-linux_aarch64.whl \
      torchvision-0.20.0a0+afc54f7-cp310-cp310-linux_aarch64.whl \
      install_opencv4.sh \
      vscode-linux-deb.arm64.deb \
      microsoft.gpg
echo "---------------------------------------------------"
echo ""
echo "Setup complete! Please reopen your terminal or run 'source ~/.bashrc'. Reboot if necessary."
echo "--------------------X--X--X------------------------"
echo ""
