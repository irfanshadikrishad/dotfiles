# -----------------------
# ZSH
# -----------------------
alias zshconfig="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

# -----------------------
# General
# -----------------------
alias n="nvim"
alias nfetch="neofetch"
alias fetch="fastfetch"
alias snap-update="sudo snap refresh"

alias off="systemctl poweroff -i"
alias restart="systemctl reboot -i"

alias docs='SAL_USE_VCLPLUGIN=gtk libreoffice --writer'

# -----------------------
# Git
# -----------------------
alias gits="git status"
alias gita="git add ."
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# -----------------------
# NPM
# -----------------------
alias npmf="npm run format"
alias npmd="npm run dev"
alias npms="npm run start"
alias npmb="npm run build"
alias npmbs="npm run build && npm run start"

# -----------------------
# XAMPP
# -----------------------
alias xampp="sudo /opt/lampp/lampp"
alias stop-apache="sudo service apache2 stop"

# -----------------------
# Warp
# -----------------------
alias warp-c="warp-cli connect"
alias warp-d="warp-cli disconnect"
alias warp-s="warp-cli status"
alias warp-r="warp-cli registration new"

# -----------------------
# Arduino
# -----------------------
alias a="arduino-cli"
alias al="arduino-cli board list"
alias as="arduino-cli sketch new"
alias ac="arduino-cli compile --fqbn arduino:avr:uno"
alias au="arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno"
alias am="arduino-cli monitor -p /dev/ttyACM0 -c baudrate=9600"
