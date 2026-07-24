---
name: video-backend
description: Generate a video clip through one swappable backend - local MLX preview on this Mac (Apple-native, fits 16GB), a rented GPU or local ComfyUI, or a hosted API (fal - Seedance / Kling / LTX). Use whenever a pipeline stage needs to turn a prompt into an actual video file and you do not want to hardcode which engine renders it. Invoke for "generate the hero video", "render this clip", "make a preview of this shot". One verb, three backends, chosen by config - so preview-locally-then-pay works without changing the pipeline.
---

# video-backend - one verb, three backends

The pipeline says "generate hero video." This skill decides WHERE that runs -
free local preview, a rented GPU, or a paid API - from config, never hardcoded.
That indirection is the point: you preview for free, a human approves, and only
then does the same call spend money on a hero render.

Run everything through the dispatcher; do not call a backend directly:

```
scripts/generate.sh --prompt "<shot>" --out <path.mp4> [--backend preview|vast|api]
                    [--res 512x768] [--frames 65] [--image <still.png>]
```

`--backend` overrides config for this one call (preview a shot, then hero it).
With no flag it reads `BACKEND` from `~/.claude/stash-video.conf`.

## The three backends (two real code paths)

| Backend | Runs on | Cost | Grade | Use for |
|---|---|---|---|---|
| `mlx` | local MLX-native Wan2.1-1.3B (fits 16GB, Apple framework) | free | storyboard | the gate before spend (default) |
| `comfyui` | ComfyUI at `COMFYUI_HOST` - local heavy OR rented vast.ai GPU | free / GPU-hour | preview / hero | heavier local, or hero on rented box |
| `api` | fal.run (Seedance / Kling / LTX hosted) | per-clip | hero | hero output, zero infra |

`mlx` is the light Apple-native local preview (MLX, not MPS) - it fits a base M1
16GB via a 4-bit Wan2.1-1.3B. `comfyui` is ONE HTTP code path pointed at any host,
so the same call previews on a local ComfyUI or renders hero on a vast.ai box just
by changing `COMFYUI_HOST`. `api` is the fal REST path. That is the whole surface.

## The money gate (why this exists)

Never let `api` or `vast` fire before a human approved a `preview`. The pipeline
(see docs/pipelines/graphics-video.md) enforces it; this skill makes it cheap:

```
generate --backend mlx  -> human looks -> approve -> generate --backend api
```

Same prompt, same `--out` shape, one word changed. Money is spent at exactly one
place, past one human gate.

## Config

`~/.claude/stash-video.conf` (created by `scripts/setup.sh`, or hand-write):

```
BACKEND=mlx                           # default: local MLX preview
MLX_WAN_DIR=~/wan21_mlx               # converted Wan2.1-1.3B 4-bit dir (mlx backend)
COMFYUI_HOST=127.0.0.1:8188           # local, or a vast.ai host:port for hero
COMFYUI_WORKFLOW=~/.claude/video-workflows/ltx-preview.json   # API-format export
API_PROVIDER=fal-ai/ltx-video         # fal model id for the api backend
```

Secrets live in `~/.claude/stash.env` (chmod 600), never in the conf or a prompt:

```
FAL_KEY=...            # for the api backend
VAST_SSH=...           # optional, if you tunnel instead of exposing the port
```

## How each backend actually runs (no mocks - real calls or a loud failure)

- **MLX (`mlx`)**: runs `mlx-video` (Apple MLX-native) on a 4-bit Wan2.1-1.3B you
  converted once. Fits a base M1 16GB (~800MB transformer); storyboard-grade at
  256-512p, slow (single-digit to ~20 min per short clip). Not installed ->
  prints the pip + convert steps and exits non-zero, never fabricating a file.
- **ComfyUI (`comfyui`)**: the dispatcher loads YOUR exported workflow
  (`COMFYUI_WORKFLOW`, saved from ComfyUI via "Save (API Format)"), injects the
  prompt / resolution / frame count into the nodes titled `PROMPT`, `SIZE`,
  `FRAMES`, POSTs to `/prompt`, polls `/history/<id>`, and downloads the output
  mp4 via `/view`. If the host is unreachable it prints the exact setup steps and
  exits non-zero - it never fabricates a file. Consuming your own workflow export
  (not a guessed node graph) is why this survives ComfyUI version drift.
- **fal (`api`)**: POSTs `{prompt, ...}` to `https://queue.fal.run/<API_PROVIDER>`
  with `Authorization: Key $FAL_KEY`, polls the queue, downloads the result url.
  No key -> prints how to get one and exits non-zero.

See `references/backends.md` for standing up each one (local ComfyUI + LTX nodes,
a vast.ai ComfyUI box, a fal key), and `references/setup-notes.md` for the Metal
gotchas (FP8 unsupported on MPS - use GGUF; `PYTORCH_ENABLE_MPS_FALLBACK=1`).

## Honest limits

- Base M1 16GB `mlx` preview is storyboard-grade only (2-3s, 256-512p, minutes) -
  it exists to answer "is this worth paying to render," nothing more. LTX-2 and
  Wan-14B do NOT fit 16GB (verified); only the small Wan2.1-1.3B does.
- This skill renders ONE clip. Composing clips into a finished video with audio
  and captions is the hyperframes suite's job (the next pipeline stage), not this.
- It does not choose prompts or judge quality - upstream stages own those.
