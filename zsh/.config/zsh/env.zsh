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

typeset -U path PATH

_path_prepend() {
  local dir
  for dir in "$@"; do
    path=("${path[@]:#$dir}")
    [[ -d "$dir" ]] && path=("$dir" "${path[@]}")
  done
}

_path_remove() {
  local dir
  for dir in "$@"; do
    path=("${path[@]:#$dir}")
  done
}

_path_append() {
  local dir
  for dir in "$@"; do
    path=("${path[@]:#$dir}")
    [[ -d "$dir" ]] && path+=("$dir")
  done
}
_nvm_expose_global_bin() {
  local version bin

  if [[ -r "$NVM_DIR/alias/default" ]]; then
    version="$(<"$NVM_DIR/alias/default")"
    bin="$NVM_DIR/versions/node/$version/bin"
    if [[ "$version" == v* && -d "$bin" ]]; then
      _path_prepend "$bin"
      return
    fi
  fi

  local bins=("$NVM_DIR"/versions/node/*/bin(N-/om[1]))
  (( ${#bins} )) && _path_prepend "$bins[1]"
}

_nvm_expose_global_bin

# -----------------------
# Go
# -----------------------
_path_remove /usr/local/go/bin /usr/lib/go/bin
if [[ -d /usr/local/go/bin ]]; then
  export GOROOT=/usr/local/go
  _path_prepend "$GOROOT/bin"
elif [[ -d /usr/lib/go/bin ]]; then
  export GOROOT=/usr/lib/go
  _path_prepend "$GOROOT/bin"
else
  unset GOROOT
fi
_path_append "$HOME/go/bin"

# -----------------------
# Android
# -----------------------
export ANDROID_HOME="$HOME/Android/Sdk"
_path_append \
  "$ANDROID_HOME/cmdline-tools/latest/bin" \
  "$ANDROID_HOME/platform-tools" \
  "$ANDROID_HOME/emulator"

# -----------------------
# Other Paths
# -----------------------
_path_prepend "$HOME/.local/bin"
_path_append "/opt/nvim-linux-x86_64/bin"
export DOCKER_HOST=unix:///var/run/docker.sock

unfunction _path_prepend _path_append _path_remove _nvm_expose_global_bin 2>/dev/null
