#!/bin/bash
# install_ppsspp.sh


sudo apt update
sudo apt install cmake build-essential git libsdl2-dev libvulkan-dev libegl1-mesa-dev -y

git clone https://github.com/hrydgard/ppsspp.git
cd ppsspp
mkdir build
cd build
cmake ..
make -j$(nproc)
./PPSSPPSDL
