#!/bin/bash
set -e

echo "=== Installing Tailscale ==="

curl -fsSL https://tailscale.com/install.sh | sh

echo "=== Starting Tailscale ==="
sudo tailscale up

echo "Login URL will appear above."
