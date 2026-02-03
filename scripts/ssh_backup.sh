#!/usr/bin/env bash
set -euo pipefail

# =========================
# Config
# =========================
HOME_DIR="${HOME}"
SSH_DIR="${HOME_DIR}/.ssh"
BACKUP_DIR="${HOME_DIR}/workshop/dotfiles/ssh"
BACKUP_NAME="ssh-backup"
ARCHIVE_PATH="${HOME_DIR}/${BACKUP_NAME}.tar.gz"
ENCRYPTED_PATH="${BACKUP_DIR}/${BACKUP_NAME}.tar.gz.gpg"
GPG_RECIPIENT="77362427+irfanshadikrishad@users.noreply.github.com"

# =========================
# Checks
# =========================
if [[ ! -d "$SSH_DIR" ]]; then
  echo "❌ SSH directory not found at $SSH_DIR"
  exit 1
fi

if ! command -v gpg >/dev/null 2>&1; then
  echo "❌ gpg is not installed."
  exit 1
fi

mkdir -p "$BACKUP_DIR"

# =========================
# Cleanup Old Backups
# =========================
echo "🧹 Removing old SSH backups..."
find "$BACKUP_DIR" -type f -name "ssh-backup-*.tar.gz.gpg" -delete

# =========================
# Backup + Encrypt
# =========================
echo "📦 Creating archive..."
tar -czf "$ARCHIVE_PATH" -C "$HOME_DIR" .ssh

echo "🔐 Encrypting archive..."
gpg --output "$ENCRYPTED_PATH" \
    --encrypt --sign \
    --recipient "$GPG_RECIPIENT" \
    "$ARCHIVE_PATH"

echo "🗑 Removing temporary archive..."
rm -f "$ARCHIVE_PATH"

echo "✅ SSH backup updated:"
echo "   $ENCRYPTED_PATH"
