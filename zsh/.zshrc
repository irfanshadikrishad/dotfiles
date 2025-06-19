# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="pixegami-agnoster"

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
export PATH="$PATH:$(npm config get prefix)/bin"

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
alias n="nvim"
alias nfetch="neofetch"
alias fetch="fastfetch"
alias apt-update="sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y"
alias snap-update="sudo snap refresh"
alias gits="git status"
alias gita="git add ."
alias gitl="git log --oneline"
alias xampp="sudo /opt/lampp/lampp"
alias stop-apache="sudo service apache2 stop"
alias zen="~/apps/zen/zen"
alias reload-zsh="source ~/.zshrc"
alias nig='npm install -g "$@" && ~/laboratory/dotfiles/scripts/update-npm-packages.sh'
alias nug='npm uninstall -g "$@" && ~/laboratory/dotfiles/scripts/update-npm-packages.sh'
alias nig-x='~/laboratory/dotfiles/scripts/install-npm-globals.sh'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

#-----------------------
#----- Shell functions -
#-----------------------

function npm-update() {
  npm list -g
  npm outdated -g
  npm update -g
}

update() {
  local start_time=$(date +%s)  # Track start time

  echo -e "\n\033[1;36m===== UPDATING SYSTEM =====\033[0m"

  # --------------------------
  # APT (Debian/Ubuntu Packages)
  # --------------------------
  echo -e "\n\033[1;33m[1/3] Updating APT packages...\033[0m"
  sudo apt update && \
  sudo apt upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt clean

  # --------------------------
  # Snap Packages
  # --------------------------
  echo -e "\n\033[1;33m[2/3] Updating Snap packages...\033[0m"
  sudo snap refresh

  # --------------------------
  # NPM (if installed)
  # --------------------------
  if command -v npm &> /dev/null; then
    echo -e "\n\033[1;33m[3/3] Updating NPM packages...\033[0m"
    npm update -g
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
