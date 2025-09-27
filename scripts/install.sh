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

#Check Gnome-Shell Version
gnome-shell --version

# Install extensions
git clone https://github.com/neuromorph/openbar.git \
	~/.local/share/gnome-shell/extensions/openbar@neuromorph

# Enable extensions
gnome-extensions enable openbar@neuromorph

# Show extensions list
gnome-extensions list

echo e "\n✅ Installation completed successfully!"
