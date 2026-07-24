#!/bin/bash
# video-backend dispatcher: one "generate hero video" verb over three backends.
# preview/vast -> ComfyUI HTTP (same call, different host); api -> fal REST.
# Real calls only. An unconfigured backend fails loudly with setup steps; it
# never fabricates an output file.
set -euo pipefail

CONF="$HOME/.claude/stash-video.conf"
ENVF="$HOME/.claude/stash.env"
BACKEND=""; MLX_WAN_DIR=""; COMFYUI_HOST="127.0.0.1:8188"
COMFYUI_WORKFLOW="$HOME/.claude/video-workflows/ltx-preview.json"
API_PROVIDER="fal-ai/ltx-video"
[ -f "$CONF" ] && . "$CONF"
[ -f "$ENVF" ] && . "$ENVF"
FAL_KEY="${FAL_KEY:-}"

prompt=""; out=""; backend="${BACKEND:-mlx}"; res="512x512"; frames="65"; image=""
while [ $# -gt 0 ]; do case "$1" in
  --prompt) prompt="$2"; shift 2;;
  --out) out="$2"; shift 2;;
  --backend) backend="$2"; shift 2;;
  --res) res="$2"; shift 2;;
  --frames) frames="$2"; shift 2;;
  --image) image="$2"; shift 2;;
  *) echo "unknown arg: $1" >&2; exit 2;;
esac; done

[ -n "$prompt" ] || { echo "need --prompt" >&2; exit 2; }
[ -n "$out" ] || { echo "need --out <path.mp4>" >&2; exit 2; }
command -v jq >/dev/null || { echo "jq required (brew install jq)" >&2; exit 2; }
w=${res%x*}; h=${res#*x}

die_setup() { echo ""; echo "backend '$backend' not ready:"; echo "$1" >&2
  echo "see references/backends.md for full setup." >&2; exit 3; }

mlx_render() {   # local MLX-native preview: Wan2.1-1.3B (4-bit) via mlx-video
  command -v python3 >/dev/null || die_setup "  python3 required."
  python3 -c "import mlx_video" 2>/dev/null || die_setup \
"  mlx-video not installed (Apple MLX-native, fits 16GB via Wan2.1-1.3B 4-bit):
    pip install git+https://github.com/Blaizzy/mlx-video.git
    python -m mlx_video.models.wan_2.convert --bits 4   # -> a wan21_mlx dir
    then set MLX_WAN_DIR=<that dir> in $CONF"
  { [ -n "$MLX_WAN_DIR" ] && [ -d "$MLX_WAN_DIR" ]; } || die_setup \
"  set MLX_WAN_DIR to your converted Wan2.1-1.3B mlx dir in $CONF"
  # documented entrypoint; flag names may vary by mlx-video version (beta) -
  # see references/backends.md if it rejects --num-frames/--width.
  python3 -m mlx_video.wan_2.generate --model-dir "$MLX_WAN_DIR" \
    --prompt "$prompt" --num-frames "$frames" --width "$w" --height "$h" \
    --output "$out" || die_setup \
"  mlx-video render failed - confirm flag names against your installed version."
  [ -f "$out" ] && echo "wrote $out (MLX preview, storyboard-grade)"
}

comfyui_render() {   # $1 = host:port  (local heavy-preview OR rented vast.ai)
  local host="$1"
  curl -sf "http://$host/system_stats" >/dev/null 2>&1 || die_setup \
"  ComfyUI not reachable at $host.
  local:  start ComfyUI with PYTORCH_ENABLE_MPS_FALLBACK=1 python main.py --force-fp16
  vast:   rent a GPU, run ComfyUI, set COMFYUI_VAST=<host:port> in $CONF"
  [ -f "$COMFYUI_WORKFLOW" ] || die_setup \
"  no workflow at $COMFYUI_WORKFLOW.
  build your LTX text-to-video graph in ComfyUI, Save (API Format), save it there,
  and title the nodes PROMPT (text), SIZE (latent/empty-latent), FRAMES (length)."
  # inject prompt/size/frames into the user's own API-format workflow by node title
  # inject by node title into whatever input names the workflow actually uses
  local wf; wf=$(jq \
    --arg p "$prompt" --argjson w "$w" --argjson h "$h" --argjson f "$frames" '
    def title: .value._meta.title // "";
    def setif($k;$v): if (.value.inputs|has($k)) then .value.inputs[$k]=$v else . end;
    to_entries | map(
      if title=="PROMPT" then setif("text";$p)
      elif title=="SIZE" then setif("width";$w)|setif("height";$h)
      elif title=="FRAMES" then setif("length";$f)|setif("num_frames";$f)|setif("frames";$f)
      else . end) | from_entries' "$COMFYUI_WORKFLOW") \
    || die_setup "  workflow JSON did not parse - re-export it as API Format."
  local id; id=$(curl -sf -X POST "http://$host/prompt" \
    -d "$(jq -n --argjson wf "$wf" '{prompt:$wf}')" | jq -r '.prompt_id') \
    || die_setup "  ComfyUI rejected the workflow (node/version mismatch)."
  echo "queued $id on $host - polling..." >&2
  local tries=0
  while [ $tries -lt 3600 ]; do
    local hist; hist=$(curl -sf "http://$host/history/$id" || echo '{}')
    if [ "$(echo "$hist" | jq -r --arg i "$id" '.[$i].status.completed // false')" = "true" ]; then
      local fn sub; read -r fn sub < <(echo "$hist" | jq -r --arg i "$id" \
        '.[$i].outputs | to_entries[] | .value.gifs[]?, .value.images[]? |
         "\(.filename) \(.subfolder // "")" ' | head -1)
      [ -n "${fn:-}" ] || die_setup "  render finished but produced no video output node."
      curl -sf "http://$host/view?filename=$fn&subfolder=${sub:-}&type=output" -o "$out" \
        || die_setup "  could not download $fn from $host."
      echo "wrote $out" ; return 0
    fi
    sleep 2; tries=$((tries+1))
  done
  die_setup "  render timed out after 2h."
}

fal_render() {
  [ -n "$FAL_KEY" ] || die_setup \
"  no FAL_KEY in $ENVF.
  get a key at fal.ai, then: echo 'FAL_KEY=...' >> $ENVF (chmod 600)."
  local body; body=$(jq -n --arg p "$prompt" ${image:+--arg img "$image"} \
    '{prompt:$p} + (if $ENV.img then {image_url:$img} else {} end)' 2>/dev/null \
    || jq -n --arg p "$prompt" '{prompt:$p}')
  local sub; sub=$(curl -sf -X POST "https://queue.fal.run/$API_PROVIDER" \
    -H "Authorization: Key $FAL_KEY" -H "Content-Type: application/json" \
    -d "$body") || die_setup "  fal request failed for $API_PROVIDER."
  local status_url resp_url; status_url=$(echo "$sub" | jq -r '.status_url // empty')
  resp_url=$(echo "$sub" | jq -r '.response_url // empty')
  [ -n "$status_url" ] || die_setup "  fal did not return a queue handle: $(echo "$sub" | head -c 200)"
  echo "fal queued $API_PROVIDER - polling..." >&2
  local tries=0
  while [ $tries -lt 900 ]; do
    local st; st=$(curl -sf -H "Authorization: Key $FAL_KEY" "$status_url" | jq -r '.status // "?"')
    [ "$st" = "COMPLETED" ] && break
    [ "$st" = "FAILED" ] && die_setup "  fal render FAILED."
    sleep 2; tries=$((tries+1))
  done
  local vurl; vurl=$(curl -sf -H "Authorization: Key $FAL_KEY" "$resp_url" \
    | jq -r '.video.url // .video_url // .output.video.url // empty')
  [ -n "$vurl" ] || die_setup "  fal completed but no video url in response."
  curl -sf "$vurl" -o "$out" || die_setup "  could not download fal result."
  echo "wrote $out"
}

case "$backend" in
  mlx)     mlx_render ;;                        # local preview, MLX-native (default)
  comfyui) comfyui_render "$COMFYUI_HOST" ;;    # local heavy OR vast: set COMFYUI_HOST
  api)     fal_render ;;                        # hosted hero: fal (Seedance/Kling/LTX)
  *) echo "unknown backend: $backend (mlx|comfyui|api)" >&2; exit 2;;
esac
