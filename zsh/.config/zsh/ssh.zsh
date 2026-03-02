# SSH Agent Auto Start
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null 2>&1
fi

ssh-add -l > /dev/null 2>&1
if [ $? -eq 2 ]; then
  ssh-add ~/.ssh/irfanshadikrishad > /dev/null 2>&1
fi
