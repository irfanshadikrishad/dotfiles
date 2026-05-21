npm-update() {
  npm list -g --depth=0
  npm outdated -g
  npm outdated -g --parseable 2>/dev/null | cut -d: -f2 | while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    npm install -g "$pkg" || echo "  skipped $pkg"
  done
}

apt-update() {
  sudo apt update && \
  sudo apt -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt modernize-sources -y && \
  sudo apt clean
}
