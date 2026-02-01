#!/usr/bin/env bash

REPO_DIR="$HOME/workshop/dotfiles"
BRANCH="master"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

cd "$REPO_DIR" || {
  echo "✘ Repo directory not found: $REPO_DIR"
  exit 1
}

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
