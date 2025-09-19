#!/bin/bash
set -euo pipefail

# Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

# Install all packages
sudo apt install -y \
  gnome-shell-extension-manager \
  gnome-tweaks \
  stow \
  gh

echo "✅ Installation completed successfully!"
