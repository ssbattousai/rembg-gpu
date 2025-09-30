#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

REPO_DIR="$HOME/rembg-gpu"
BRANCH="master"

cd "$REPO_DIR"

# Check we're in a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Not a git repository: $REPO_DIR"
  exit 1
fi

# Detect changes
changed=$(git status --porcelain | wc -l)
echo "📂 Repo: $REPO_DIR"
echo "📌 Branch: $BRANCH"
echo "🔎 Detected $changed change(s)"

if [[ $changed -eq 0 ]]; then
  echo "✅ Nothing to commit"
  exit 0
fi

# Stage *everything*
echo "📥 Staging changes..."
git add .

# Commit
echo "📝 Committing..."
if git commit -m "Auto-backup rembg-gpu: $(date '+%Y-%m-%d %H:%M:%S')" ; then
  echo "✅ Commit created"
else
  echo "⚠️ Nothing new to commit"
  exit 0
fi

# Push
echo "🚀 Pushing to GitHub..."
git push -u origin "$BRANCH"

echo "🎉 Upload finished"
