npm-update() {
  npm list -g --depth=0
  npm outdated -g

  local outdated_json install_specs
  outdated_json="$(npm outdated -g --json 2>/dev/null)"
  [[ -z "$outdated_json" || "$outdated_json" == "{}" ]] && return 0

  if ! install_specs="$(
    node -e '
      const fs = require("fs");
      const data = JSON.parse(fs.readFileSync(0, "utf8") || "{}");
      const knownChannels = new Set([
        "alpha",
        "beta",
        "canary",
        "dev",
        "experimental",
        "next",
        "nightly",
        "preview",
        "rc"
      ]);

      for (const [name, info] of Object.entries(data)) {
        const current = String(info.current || "");
        const prerelease = current.match(/^\d+\.\d+\.\d+-([0-9A-Za-z]+)(?:[.-]|$)/);
        const channel = prerelease?.[1]?.toLowerCase();

        console.log(channel && knownChannels.has(channel) ? `${name}@${channel}` : name);
      }
    ' <<< "$outdated_json"
  )"; then
    echo "  failed to parse npm outdated output"
    return 1
  fi

  while IFS= read -r pkg; do
    [[ -z "$pkg" ]] && continue
    npm install -g "$pkg" || echo "  skipped $pkg"
  done <<< "$install_specs"
}

apt-update() {
  sudo apt update && \
  sudo apt -o APT::Get::Always-Include-Phased-Updates=true upgrade -y && \
  sudo apt full-upgrade -y && \
  sudo apt autoremove -y && \
  sudo apt modernize-sources -y && \
  sudo apt clean
}
