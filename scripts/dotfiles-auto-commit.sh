#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$HOME/workshop/dotfiles"
BRANCH="master"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
PRE_BACKUP_SCRIPT="$REPO_DIR/scripts/ssh_backup.sh"

cd "$REPO_DIR" || {
  echo "✘ Repo directory not found: $REPO_DIR"
  exit 1
}

# Run The SSH backup script first
if [[ -x "$PRE_BACKUP_SCRIPT" ]]; then
  echo "🔐 Running SSH backup script..."
  "$PRE_BACKUP_SCRIPT"
  echo "✔ SSH backup completed"
else
  echo "⚠ Pre-backup script not found or not executable: $PRE_BACKUP_SCRIPT"
fi

# Make sure it's actually a git repo
if [[ ! -d .git ]]; then
  echo "✘ Not a git repository: $REPO_DIR"
  exit 1
fi

# Fetch in case remote changed
git fetch origin "$BRANCH" >/dev/null 2>&1

# Check for changes (tracked or untracked)
if [[ -n $(git status --porcelain) ]]; then
  echo "📦 Changes detected — committing..."

  git add -A

  git commit -m "chore(dotfiles): auto backup on $TIMESTAMP" || {
    echo "✘ Commit failed"
    exit 1
  }

  git push origin "$BRANCH" || {
    echo "✘ Push failed"
    exit 1
  }

  echo "✔ Dotfiles backed up successfully"
else
  echo "✔ No changes — nothing to commit"
fi
