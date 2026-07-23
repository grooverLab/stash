#!/bin/bash
# uninstall.sh - remove skills-profile from ~/.claude/bin.
# Your skill profiles (~/.claude/skill-profiles) and per-project links are LEFT
# INTACT - they are your data. Remove them yourself if you want a full wipe:
#   rm -rf ~/.claude/skill-profiles       # the profile warehouse
#   (per-project: delete symlinks in <project>/.claude/skills)
set -euo pipefail
BIN="$HOME/.claude/bin"

rm -f "$HOME/.claude/skills/stash" && echo "removed: ~/.claude/skills/stash"
for f in skills-profile skills-profile-tui; do
  if [ -L "$BIN/$f" ] || [ -e "$BIN/$f" ]; then
    rm -f "$BIN/$f"
    echo "removed $BIN/$f"
  fi
done
echo "Uninstalled. Profiles and project links preserved."
