# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set SSH agent socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"
# export PATH="$PATH:$(npm config get prefix)/bin"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

#-----------------------
#------------- Aliases -
#-----------------------
alias zshconfig="nvim ~/.zshrc"
alias reload-zsh="source ~/.zshrc"

alias n="nvim"
alias nfetch="neofetch"
alias fetch="fastfetch"
alias apt-update="sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y"
alias snap-update="sudo snap refresh"

alias gits="git status"
alias gita="git add ."
alias gitl="git log --oneline"

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export GOROOT=/usr/lib/go
export PATH=$GOROOT/bin:$PATH

# ----------------------
# -- Android Development
# ---------------------- 
export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export DOCKER_HOST=unix:///var/run/docker.sock

#-----------------------
#----- Shell functions -
#-----------------------

function npm-update() {
  npm list -g
  npm outdated -g
  npm update -g
}

function apt-update() {
  sudo apt update && \
  sudo apt -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt modernize-sources -y && \
  sudo apt clean
}

update() {
  local start_time=$(date +%s)  # Track start time

  echo -e "\n\033[1;36m===== UPDATING SYSTEM =====\033[0m"

  # --------------------------
  # APT (Debian/Ubuntu Packages)
  # --------------------------
  echo -e "\n\033[1;33m[1/4] Updating APT packages...\033[0m"
  apt-update

  # --------------------------
  # Snap Packages
  # --------------------------
  echo -e "\n\033[1;33m[2/4] Updating Snap packages...\033[0m"
  sudo snap refresh

  # --------------------------
  # NPM (if installed)
  # --------------------------
  if command -v npm &> /dev/null; then
    echo -e "\n\033[1;33m[4/4] Updating NPM packages...\033[0m"
    npm-update 
  else
    echo -e "\n\033[1;31mNPM not installed. Skipping...\033[0m"
  fi

  # --------------------------
  # Completion & Time Tracking
  # --------------------------
  local end_time=$(date +%s)
  local total_time=$((end_time - start_time))

  echo -e "\n\033[1;32m✔ All updates completed in ${total_time} seconds.\033[0m"
}

yayUpdate(){ 
  yay -Syu --noconfirm && yay -Sc --noconfirm && yay -Yc --noconfirm

}


GITSTATUS_LOG_LEVEL=DEBUG

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
