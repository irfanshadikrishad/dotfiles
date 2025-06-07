#!/bin/bash

EXT_FILE="$HOME/.vscode/extensions/extensions.json"

if [ ! -f "$EXT_FILE" ]; then
  echo "❌ File not found: $EXT_FILE"
  exit 1
fi

extension_count=0
inside_identifier=0

echo -e "\n🔧 Installing extensions...\n"

while IFS= read -r line; do
  # Detect start of identifier block
  if echo "$line" | grep -q '"identifier": {'; then
    inside_identifier=1
    continue
  fi

  # Detect end of identifier block
  if [ $inside_identifier -eq 1 ] && echo "$line" | grep -q '},'; then
    inside_identifier=0
    continue
  fi

  # When inside identifier, extract the id value
  if [ $inside_identifier -eq 1 ]; then
    id=$(echo "$line" | sed -n 's/.*"id": *"\([^"]*\)".*/\1/p')
    if [ -n "$id" ]; then
      ((extension_count++))
      echo -e "[$extension_count] $id"
      code --install-extension "$id"
    fi
  fi
done < "$EXT_FILE"

echo -e "\n✅ $extension_count extensions installed sucessfully."
