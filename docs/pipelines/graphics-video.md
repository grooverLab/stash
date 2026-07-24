# Pipeline: graphics -> video (marketing asset generation)

Method applied: objective -> sketch -> refined workflow -> skills per stage ->
gates/evals -> outcome. The generation backends are swappable (see TAXONOMY.md
provider rule); the pipeline names the stage, config picks the backend.

## Objective

Turn approved copy/concept into a composed, on-brand, gated video ready to post -
doing all PREVIEW locally and spending money on hero generation only after a human
approves the preview.

## Refined workflow (stage = {input artifact -> output artifact})

| # | Stage | In -> Out | Domain / skills | Gate (mechanical) |
|---|---|---|---|---|
| 1 | Brief | approved copy + brand -> asset brief, shot list | marketing (marketing-context), graphics (ComfyUI-Expert prompt-interview / banana brief-constructor) | brand kit resolved (palette/type/logo); shot list non-empty |
| 2 | Still assets | brief -> brand images, on-image text | graphics: canvas-design (code/type, deterministic), gpt-image-2 (templates), comfyui ideogram-ultra (text-on-image). backend abstracted | brand-QC: palette match + text legible (media-pipeline judge or manual) |
| 3 | Motion PREVIEW (local) | stills + brief -> low-res storyboard/preview clip | video: LTX-2B-distilled (MPS) + RIFE interp. LOCAL ONLY, preview-grade | HUMAN GATE: does the motion read? approve BEFORE any spend |
| 4 | Hero render | approved preview -> final hero clip | video backend = rented-gpu (vast.ai) OR api (Seedance/Kling/Runway/Veo) | provider returns valid clip at target res/fps |
| 5 | Compose | hero clip + copy + assets -> final video (audio, captions) | video: hyperframes suite (deterministic) + media-use (BGM/SFX/TTS/captions) | hyperframes check: WCAG AA, readability floor, snapshot QC |
| 6 | Adapt + publish | final video -> per-channel cuts | video (aspect fan-out), social (X/LinkedIn) | each cut reads standalone; 9:16 + 16:9 present |

## The seam (the whole point)

    stage 3 PREVIEW (local, free)
        |  human gate: "is this worth paying to render?"
        v
    stage 4 HERO (rented-gpu | api)   <- money spent ONLY past the gate
        |
        v
    stage 5 COMPOSE (hyperframes, deterministic, ours)

Money is spent at exactly one place - after a human approved a free local preview.
That gate is the pipeline's reason to exist.

## Backend config (per TAXONOMY.md provider rule)

    PREVIEW  = local-mps   (LTX-2B-distilled via ComfyUI + RIFE; storyboard-grade)
    HERO     = rented-gpu  (vast.ai hourly Wan/LTX/Hunyuan)   OR
             = api         (Seedance / Kling / Runway / Veo)
    COMPOSE  = hyperframes  (always local, deterministic, no spend)

Open item: whether a PURE-MLX preview backend exists at 16GB (user preference).
Current evidence: MLX-native video-gen needs 32GB+; the runnable local preview
is MPS (PyTorch/Metal), not MLX. Under verification.

## Gaps to fill (compose, do not hunt one mega-skill)

- No skill orchestrates this chain end to end -> build `graphics-video-pipeline`
  orchestrator (like /stash but stage-by-stage with the gates above).
- No skill wraps a rented-gpu/vast.ai or Seedance/Kling API backend -> thin
  `video-backend` skill exposing one "generate hero video" verb over 3 backends.
- Stage 2 brand-QC judge is currently manual -> borrow media-pipeline-mcp's
  CLIP-aesthetic judge into a small `brand-qc` gate skill.
