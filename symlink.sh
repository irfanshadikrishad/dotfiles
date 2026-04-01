#!/bin/bash

packages=(git fastfetch p10k nvim kitty bash cava neofetch icons fonts openbar hypr hyper themes tmux vscode waybar wofi zsh)

# Loop through and stow each package
for pkg in "${packages[@]}"; do
    stow -v --target="$HOME" "$pkg"
done
