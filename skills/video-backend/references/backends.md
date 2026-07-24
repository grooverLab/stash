# Standing up each video backend

Run `scripts/setup.sh` first to write `~/.claude/stash-video.conf`.

## mlx (local preview, Apple MLX-native, fits base M1 16GB)

Verified 2026-07: the only local video-GEN path that fits 16GB is a small model.
LTX-2 and Wan-14B do NOT fit (they need 32-64GB). Use Wan2.1-1.3B at 4-bit.

```
pip install git+https://github.com/Blaizzy/mlx-video.git
python -m mlx_video.models.wan_2.convert --bits 4        # produces a wan21_mlx dir
```

Set `MLX_WAN_DIR=<that dir>` in the conf. Then:

```
scripts/generate.sh --backend mlx --prompt "a slow dolly over a desk" \
  --res 512x512 --frames 65 --out /tmp/preview.mp4
```

Notes:
- MLX (Apple's framework), not MPS/ComfyUI. ~800MB transformer after 4-bit.
- Storyboard-grade: 256-512p, ~9 real frames, minutes per clip on a base M1.
- mlx-video is beta - if `--num-frames/--width` are rejected, run
  `python -m mlx_video.wan_2.generate --help` and adjust the flags in
  `scripts/generate.sh:mlx_render` to match your installed version.
- Alternative small MLX model: `mlx-community/Lance-3B-Video-bf16` ships a
  `memory_mode="relay"` for 8-16GB if Wan2.1-1.3B underdelivers.

## comfyui (local heavy preview, OR rented vast.ai GPU for hero)

One HTTP path, any host. `COMFYUI_HOST=127.0.0.1:8188` for local; a vast.ai
`host:port` for hero.

1. Local: install ComfyUI for Apple Silicon, launch with
   `PYTORCH_ENABLE_MPS_FALLBACK=1 python main.py --force-fp16`.
   Rented: on vast.ai rent a CUDA GPU, run a ComfyUI image, expose `:8188`
   (or SSH-tunnel), set `COMFYUI_HOST` to it.
2. Build your text-to-video workflow in the ComfyUI UI, then **Save (API Format)**.
3. Save that JSON at `COMFYUI_WORKFLOW`, and TITLE three nodes exactly:
   `PROMPT` (the positive text node), `SIZE` (the empty-latent / size node),
   `FRAMES` (the length node). The dispatcher injects prompt/res/frames by title,
   so it survives node/version drift - it drives your graph, not a guessed one.

## api (hosted hero, zero infra) - fal

```
# get a key at fal.ai
echo 'FAL_KEY=...' >> ~/.claude/stash.env && chmod 600 ~/.claude/stash.env
```

Set `API_PROVIDER` to a fal model id, e.g. `fal-ai/ltx-video`,
`fal-ai/kling-video/v1/standard/text-to-video`, or a Seedance model when listed.
Image-to-video: pass `--image <still.png>` (sent as `image_url` where supported).

```
scripts/generate.sh --backend api --prompt "..." --out hero.mp4
```
