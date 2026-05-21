# -----------------------
# NVM (lazy-loaded for fast shell startup)
# -----------------------
export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}
node() { unset -f node; nvm; node "$@"; }
npm()  { unset -f npm;  nvm; npm  "$@"; }
npx()  { unset -f npx;  nvm; npx  "$@"; }

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
