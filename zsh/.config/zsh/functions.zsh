npm-update() {
  npm list -g --depth=0
  npm outdated -g

  local outdated_json
  outdated_json="$(npm outdated -g --json 2>/dev/null)"
  [[ -z "$outdated_json" || "$outdated_json" == "{}" ]] && return 0

  local specs
  specs="$(
    node -e '
      const fs = require("fs");
      const data = JSON.parse(fs.readFileSync(0, "utf8") || "{}");
      for (const [name, info] of Object.entries(data)) {
        const current = String(info.current || "");
        // If current is a prerelease, pin the EXACT current version.
        // This avoids npm re-resolving the tag and silently downgrading.
        if (/\d+\.\d+\.\d+-/.test(current)) {
          console.log(`${name}@${current}`);
        } else {
          console.log(name);
        }
      }
    ' <<< "$outdated_json"
  )"

  while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    npm install -g "$pkg" || echo "  skipped $pkg"
  done <<< "$specs"
}

apt-update() {
  sudo apt update && \
  sudo apt -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt modernize-sources -y && \
  sudo apt clean
}
