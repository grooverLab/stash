#!/bin/bash
# install.sh - install skills-profile into ~/.claude/bin as symlinks to this repo.
# Re-running is safe (idempotent). Uninstall with ./uninstall.sh.
set -euo pipefail
REPO="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.claude/bin"
PROFILES="$HOME/.claude/skill-profiles"

mkdir -p "$BIN" "$PROFILES"

for f in skills-profile skills-profile-tui; do
  chmod +x "$REPO/bin/$f"
  # replace copies or stale links with a link into the repo
  rm -f "$BIN/$f"
  ln -s "$REPO/bin/$f" "$BIN/$f"
  echo "linked $BIN/$f -> $REPO/bin/$f"
done

case ":$PATH:" in
  *":$BIN:"*) ;;
  *) echo ""
     echo "NOTE: $BIN is not on your PATH. Add to ~/.zshrc:"
     echo "  export PATH=\"\$HOME/.claude/bin:\$PATH\"" ;;
esac

echo ""
echo "Installed. Usage:"
echo "  skills-profile migrate --dry-run   # preview moving domain skills out of ~/.claude/skills"
echo "  skills-profile pick                # terminal picker (TUI)"
echo "  skills-profile pick-html           # browser picker"
echo "  skills-profile use trading db      # CLI"
