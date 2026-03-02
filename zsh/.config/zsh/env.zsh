# -----------------------
# NVM
# -----------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# -----------------------
# Go
# -----------------------
export GOROOT=/usr/lib/go
export PATH=$GOROOT/bin:$PATH

# -----------------------
# Android
# -----------------------
export ANDROID_HOME=$HOME/Android
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# -----------------------
# Other Paths
# -----------------------
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export DOCKER_HOST=unix:///var/run/docker.sock
