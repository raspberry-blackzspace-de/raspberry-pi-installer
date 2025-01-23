#!/bin/bash
# install_packages.sh


sudo apt update && sudo apt install -y build-essential gcc g++ make cmake automake autoconf libtool pkg-config gdb valgrind \
pigpio wiringpi python3-dev python3-pip python3-rpi.gpio libgpiod-dev libgpiod-tools i2c-tools libi2c-dev spi-tools \
git curl wget raspberrypi-kernel-headers libboost-all-dev libsdl2-dev libssl-dev zlib1g-dev
