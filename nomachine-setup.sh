#!/bin/bash
set -e

echo "=== Downloading NoMachine ==="

cd /tmp
wget https://download.nomachine.com/download/latest/linux/nomachine_amd64.deb

echo "=== Installing NoMachine ==="
# sudo dpkg -i nomachine_amd64.deb || sudo apt -f install -y
sudo apt install links2
links2 nomachine.com

echo "=== Enabling service ==="
sudo systemctl enable nxserver
sudo systemctl restart nxserver

echo "=== NoMachine installed ==="
