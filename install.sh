#!/bin/bash
set -e

echo "=== Updating system ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing base packages ==="
sudo apt install -y \
    sudo curl wget gnupg ca-certificates \
    xserver-xorg-core xserver-xorg-video-dummy \
    kde-plasma-desktop sddm

echo "=== Enabling SDDM ==="
sudo systemctl enable sddm

echo "=== Installing NoMachine ==="
bash nomachine-setup.sh

echo "=== Installing KDE config ==="
bash kde-setup.sh

echo "=== Done ==="
echo "Reboot recommended: sudo reboot"
