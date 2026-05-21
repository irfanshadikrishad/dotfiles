# -----------------------
# NVM (lazy-loaded for fast shell startup)
# -----------------------
export NVM_DIR="$HOME/.nvm"

_load_nvm() {
  unset -f nvm node npm npx _load_nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

nvm()  { _load_nvm; nvm  "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm  "$@"; }
npx()  { _load_nvm; npx  "$@"; }

# -----------------------
# Go
# -----------------------
export GOROOT=/usr/lib/go
export PATH=$GOROOT/bin:$PATH

# -----------------------
# Android
# -----------------------
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# -----------------------
# Other Paths
# -----------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export DOCKER_HOST=unix:///var/run/docker.sock
