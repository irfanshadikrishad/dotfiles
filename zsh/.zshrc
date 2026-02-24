# Enable Powerlevel10k instant prompt. Must stay at the very top.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# -----------------------
# Aliases
# -----------------------
alias zshconfig="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

alias n="nvim"
alias nfetch="neofetch"
alias fetch="fastfetch"
alias snap-update="sudo snap refresh"

alias gits="git status"
alias gita="git add ."
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias npmf="npm run format"
alias npmd="npm run dev"
alias npms="npm run start"
alias npmb="npm run build"
alias npmbs="npm run build && npm run start"

alias xampp="sudo /opt/lampp/lampp"
alias stop-apache="sudo service apache2 stop"

alias zen="~/apps/zen/zen"

alias off="systemctl poweroff -i"
alias restart="systemctl reboot -i"

alias warp-c="warp-cli connect"
alias warp-d="warp-cli disconnect"
alias warp-s="warp-cli status"
alias warp-r="warp-cli registration new"

alias docs='SAL_USE_VCLPLUGIN=gtk libreoffice --writer'

alias arduc='arduino-cli compile --fqbn arduino:avr:uno'
alias arduu='arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno'

# -----------------------
# ENV PATHS
# -----------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export GOROOT=/usr/lib/go
export PATH=$GOROOT/bin:$PATH

export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export DOCKER_HOST=unix:///var/run/docker.sock

# -----------------------
# Shell Functions
# -----------------------
user_list() {
  awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd
}
npm-update() {
  npm list -g
  npm outdated -g
  npm update -g
}

apt-update() {
  sudo apt update && \
  sudo apt -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt modernize-sources -y && \
  sudo apt clean
}

update() {
  local start_time=$(date +%s)

  echo -e "\n\033[1;36m===== UPDATING SYSTEM =====\033[0m"

  echo -e "\n\033[1;33m[1/3] Updating APT packages...\033[0m"
  apt-update

  echo -e "\n\033[1;33m[2/3] Updating Snap packages...\033[0m"
  sudo snap refresh

  if command -v npm &> /dev/null; then
    echo -e "\n\033[1;33m[3/3] Updating NPM packages...\033[0m"
    npm-update 
  else
    echo -e "\n\033[1;31mNPM not installed. Skipping...\033[0m"
  fi

  local end_time=$(date +%s)
  local total_time=$((end_time - start_time))

  echo -e "\n\033[1;32m✔ All updates completed in ${total_time} seconds.\033[0m"
}

yayUpdate(){ 
  yay -Syu --noconfirm && yay -Sc --noconfirm && yay -Yc --noconfirm
}

# -----------------------
# Git commit with custom date
# -----------------------
gitc() {
  local message="$1"
  local input_date="$2"
  local final_date

  if [[ -z "$message" ]]; then
    echo "Usage: gitc \"commit message\" [YYYY-MM-DD | full date string]"
    return 1
  fi

  if [[ -z "$input_date" ]]; then
    final_date="$(date '+%Y-%m-%d %H:%M:%S')"
  elif [[ "$input_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    final_date="$input_date 00:00:00"
  else
    final_date="$input_date"
  fi

  GIT_AUTHOR_DATE="$final_date" \
  GIT_COMMITTER_DATE="$final_date" \
  git commit -m "$message" --date "$final_date"
}

GITSTATUS_LOG_LEVEL=DEBUG

# Load Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --------------------------------------------------
# SSH Agent Auto Start (Silent + Powerlevel10k Safe)
# --------------------------------------------------

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

ssh-add -l > /dev/null 2>&1
if [ $? -eq 2 ]; then
  ssh-add ~/.ssh/irfanshadikrishad > /dev/null 2>&1
fi

