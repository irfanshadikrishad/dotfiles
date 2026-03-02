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
