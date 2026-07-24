# stash warehouse taxonomy

Domains are the warehouse's organizing unit (one profile dir per domain). The
rule: a domain is a **pipeline stage or a coherent job**, not a vendor or a repo.
Skills are raw material; pipelines chain them across domains with gates.

Expand freely - add a domain whenever a real pipeline stage has no home. Never
split by source repo; split by the job the skill does.

## Families and domains

### Content and GTM
| Domain | The job | Feeds pipeline stage |
|---|---|---|
| marketing | strategy, positioning, PMM, ideas, psychology, ops, context | 1 strategy |
| content | long-form production, humanizing, doc co-authoring | 2 draft |
| copywriting | headlines, landing copy, CTAs, ad + email copy, ecommerce | 3 copy |
| seo-aeo | on-page SEO, schema, programmatic, AI-answer optimization | 5 optimize |
| social | multi-platform, X, LinkedIn, community, viral | 6 adapt |
| cro | conversion optimization across every funnel surface | post-publish |
| blog | the claude-blog pipeline (30+ blog-* stages, self-contained) | 2-5 blog track |
| marketing-ops | analytics, attribution, tracking, campaign measurement | 8 measure |

### Creative
| Domain | The job | Feeds pipeline stage |
|---|---|---|
| graphics | generative + code image assets, brand-locked, text-on-image | 5.5 assets |
| video | deterministic compositing (hyperframes/brag) + hero-gen | 6 compose |

### Markets
trading · investing · finance · accounting

### Corp
hr · compliance · business-clevel · business-operations · sales-gtm

### Build
engineering · frontend · coding · db · research

## The generation-provider rule (graphics + video)

Asset generation is a STAGE with a swappable backend, never a hardcoded tool:

    local-previz   base M1: LTX-2B-distilled + RIFE interp - throwaway/storyboard only
    rented-gpu     vast.ai hourly: full Wan/LTX/Hunyuan for hero output
    api            Seedance / Kling / Runway / Veo - hero output, no infra

The pipeline names the stage ("generate hero video"); the backend is config.
See memory: base M1 16GB is a previz + frame-interp box, not a hero-gen box.
