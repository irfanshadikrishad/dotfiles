#!/bin/bash
set -euo pipefail

# Update and upgrade system
sudo apt update -y && sudo apt upgrade -y
# Add repos
sudo add-apt-repository ppa:russell-s-stewart/ppa
# Install all packages
sudo apt install -y \
  gnome-shell-extension-manager \
  gnome-tweaks \
  stow \
  gh \
  sshrc

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


# Download the maintained fork version (sshrc)
wget https://raw.githubusercontent.com/cbert-admin/sshrc/master/sshrc
# Grant execute permission
chmod +x sshrc
# Move to system path
sudo mv sshrc /usr/local/bin/
touch ~/.sshrc
