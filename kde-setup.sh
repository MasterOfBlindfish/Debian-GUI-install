#!/bin/bash
set -e

echo "=== KDE / SDDM config ==="

sudo systemctl enable sddm

# Force X11 session default (important for stability)
sudo mkdir -p /etc/sddm.conf.d

cat <<EOF | sudo tee /etc/sddm.conf.d/x11.conf
[General]
DisplayServer=x11
EOF

echo "=== KDE setup complete ==="
