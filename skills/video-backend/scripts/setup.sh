#!/bin/bash
# Write a default ~/.claude/stash-video.conf (idempotent). Secrets go in stash.env.
set -euo pipefail
CONF="$HOME/.claude/stash-video.conf"
if [ -f "$CONF" ]; then echo "$CONF exists - leaving it"; exit 0; fi
cat > "$CONF" <<'EOF'
# stash video-backend config. Backend: mlx | comfyui | api
BACKEND=mlx
MLX_WAN_DIR=$HOME/wan21_mlx
COMFYUI_HOST=127.0.0.1:8188
COMFYUI_WORKFLOW=$HOME/.claude/video-workflows/ltx-preview.json
API_PROVIDER=fal-ai/ltx-video
EOF
echo "wrote $CONF"
echo "secrets (FAL_KEY for api) go in ~/.claude/stash.env (chmod 600)."
echo "see references/backends.md to stand up a backend."
