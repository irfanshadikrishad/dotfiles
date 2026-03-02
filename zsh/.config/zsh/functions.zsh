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
