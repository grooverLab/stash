# Company-OS: launch and run any business as composable skills

A universal **spine** (the command layer every business has on day 0) plus a
pluggable **vertical** (business-type specifics). Every responsibility is a skill
or a composed workflow; functions chain with mechanical **gates** in dependency
order. Launch = spine (always on) + one vertical (chosen).

Anchored on: APQC Process Classification Framework (13 categories), EOS
Accountability Chart, TOGAF/BIZBOK capability-map tiers (strategic/core/support),
and the agent-org patterns (orchestrator-worker + "Function = SOP(Team)").

## The three parts

1. **Spine** - 12 universal functions (F1-F12) + F13 meta. Truly every business.
2. **Vertical overlay** - added functions + launch-blocking gates per business type.
3. **Coordination** - a deterministic outer flow (the gates) wrapping autonomous
   role-crews (the skills). The org chart's structure IS the coordination graph;
   its SOPs are the role instructions; its deliverables are typed handoff artifacts.

## Role schema (every skill/role fills this)

The frameworks converge on one template - use it for every function's roles:

    role            specific title, not "manager"
    goal            what it optimizes
    backstory       domain expertise framing
    instructions    the SOP it follows  (Function = SOP(Team))
    tools           bounded - only what this role needs
    model / effort  scale to task complexity
    output-contract the typed artifact it emits (not chat)
    handoff-rights  who it can pass work to, and the gate that reviews it

SKILL.md frontmatter already carries most of this. Gates = input/output guardrails
(a reviewer role validating without full implementation context).

## The spine (F1-F13) mapped to the warehouse

Legend: [D0] day-0 minimum · [Scale] later · ⚑ overlay (business-type-specific) ·
GAP = no strong warehouse skill yet, compose one.

### F1 Strategy, Vision & Governance  (APQC 1.0/12.3 · EOS Visionary+Integrator)
vision, ICP, business model, unit economics [D0]; goals/OKRs, capital strategy [D0];
board, governance, EPM [Scale]; M&A ⚑.
-> warehouse: c-level-advisor (ceo-advisor, board-deck-builder, ma-playbook,
   scenario-war-room), c-level-agents (boardroom, office-hours), founder-coach.

### F2 Product / Offering  (APQC 2.0 · EOS Operations)
define the offer, customer discovery, MVP build+test [D0]; roadmap, PMF, R&D [Scale];
IP ⚑.
-> warehouse: cpo-advisor, product-team, engineering; GAP: hard-goods/clinical
   product realization lives in the vertical.

### F3 Marketing & Demand  (APQC 3.1-3.3 · EOS Sales&Marketing)
research/segmentation, brand, pricing, site/content [D0]; demand-gen, automation,
PR, analytics [Scale].
-> warehouse: marketing, content, copywriting, social, seo-aeo, cro, blog,
   graphics, video, marketing-ops, cmo-advisor. (deepest-covered function.)

### F4 Sales & Business Development  (APQC 3.4-3.5)
close first revenue, pipeline, quoting/contracts [D0]; AM, renewals, RevOps [Scale];
channel ⚑.
-> warehouse: sales-gtm, commercial (pricing-strategist, deal-desk,
   partnerships-architect), business-growth (sales-engineer, rfp-responder),
   cro-advisor.

### F5 Operations / Delivery / Fulfillment  (APQC 4.0 physical + 5.0 services)
deliver the promise, core workflow, quality/SLA [D0]; capacity, vendors [Scale];
**physical supply-chain/procure/produce/logistics ⚑ (the D2C + mfg overlay)**.
-> warehouse: business-operations (process-mapper, capacity-planner,
   vendor-management, procurement-optimizer), coo-advisor; GAP: physical
   fulfillment/production = vertical.

### F6 Customer Success & Support  (APQC 6.0)
answer customers, onboarding [D0]; support/ticketing, retention, CSAT [Scale];
warranty/returns ⚑; recalls ⚑.
-> warehouse: business-growth (customer-success-manager), cro (churn-prevention,
   onboarding-cro), cco-advisor.

### F7 Finance & Accounting  (APQC 9.0 · EOS Finance&Admin)
get paid (AR), pay bills (AP), bookkeeping, cash/runway, reporting [D0]; payroll
[at first hire]; treasury, controls, rev-rec [Scale]; fundraising ⚑; cross-border ⚑.
-> warehouse: finance (financial-analyst, cfo-advisor, saas-metrics-coach),
   accounting (month-end-close, quarterly-taxes...), month-end-closer +
   gl-reconciler plugins.

### F8 Legal, Risk, Compliance  (APQC 11.0/12.4)
**form entity, EIN, licenses [D0 - GATE 1-2]**; contracts/ToS/privacy, insurance
[D0]; industry regulatory [D0 if regulated ⚑]; ERM, GDPR/CCPA, resiliency [Scale].
-> warehouse: compliance (soc-2, iso-27001/42001, hipaa, gdpr, pci-dss, sox-itgc,
   fedramp, nist-csf...), general-counsel-advisor, compliance-os;
   GAP: entity-formation + basic-contract generation (frameworks exist, formation
   workflow does not) -> compose.

### F9 People / HR  (APQC 7.0)
founder self-org [D0]; first-hire: classification, offers, agreements [Scale-gate];
recruiting, onboarding, comp, employment-law, performance, culture [Scale].
-> warehouse: hr (chro-advisor, interview-system-designer, culture-architect,
   change-management), hr-legal-compliance plugin (hr-pro, legal-advisor).

### F10 Technology, Data & Security  (APQC 8.0)
core tooling, business systems, data/backups/security hygiene [D0]; IT strategy,
build/deploy, data-governance, cybersecurity [Scale].
-> warehouse: engineering, frontend, coding, db, ciso-advisor, security
   (soc/threat/cloud-security), dataviz.

### F11 Admin, Facilities, Procurement, Assets  (APQC 10.0/13.7)
address/registered-agent, records, general procurement [D0]; facilities [Scale ⚑];
fixed-assets ⚑; EHS ⚑ (mfg).
-> warehouse: business-operations (procurement-optimizer, knowledge-ops);
   GAP: fixed-asset + EHS = mfg vertical.

### F12 External Relations & Communications  (APQC 12.0)
key relationships [D0 founder]; PR/comms [Scale]; gov/industry ⚑; IR/board ⚑; ESG ⚑.
-> warehouse: business-operations (internal-comms), marketing (PR-adjacent),
   c-level (board-meeting, general-counsel); GAP: investor-relations = overlay.

### F13 Business Capability / PMO / Quality  (APQC 13.0 · meta, ~all [Scale])
process mgmt, PMO, enterprise quality, change, knowledge, analytics.
-> warehouse: business-operations (process-mapper, knowledge-ops),
   engineering (tech-debt-tracker); formal QMS ⚑ (mfg).

## Day-0 minimal set (solo founder covers all, zero employees)

1 offer defined + demand validated (F2/F1) · 2 legal entity (F8) · 3 EIN + licenses
(F8) · 4 business bank account (F7) · 5 a way to get paid (F7/F4) · 6 bookkeeping
(F7) · 7 a way to acquire first customers (F3/F4) · 8 deliver the offer (F5) ·
9 answer customers (F6) · 10 contracts/ToS/privacy + insurance (F8) · 11 core
tooling + data/records (F10/F11). Everything F9/F13/[Scale] defers to first-hire.

## Launch gate order (the deterministic outer flow)

```
GATE 0  validate offer & demand (F1/F2)          informal, precedes entity
GATE 1  form legal entity (F8)                    blocks all financial/contractual
GATE 2  EIN + tax/licenses (F8)                   requires entity
GATE 3  business bank account (F7)                requires entity + EIN
GATE 4  payment processing (F7/F4)                requires bank + entity
GATE 5  bookkeeping setup (F7)                     requires bank to reconcile
GATE 6  contracts/ToS/privacy + insurance (F8)    must precede first paying customer
GATE 7  REVENUE: market->sell->deliver->support (F3->F4->F5->F6)
GATE 8  first-hire: payroll reg, workers-comp, agreements (F9+F7)  hire-triggered
GATE 9  scale: dedicated IT/sec, PMO/quality, risk program, IR/board
   + VERTICAL GATE: the business-type compliance gate (below) sits BEFORE GATE 7.
```

Rules: entity before money; EIN before banking and payroll; legal cover before
first customer; payroll/HR is hire-triggered not launch-triggered; build F5/F6
just-in-time after F4 closes a customer; the vertical's regulatory gate legally
precedes revenue.

## Vertical overlays (stack on the spine; each re-adds one omitted thing)

The spine assumes an atoms-light, unregulated service. Each vertical re-introduces
one thing + its launch-blocking gate that legally precedes revenue.

### D2C / e-commerce  (re-adds: physical inventory + logistics)
Added functions: merchandising/catalog, demand+inventory planning, sourcing/QC,
3PL/fulfillment/WMS, reverse-logistics/returns (~6-10% of rev), marketplace ops
(Amazon Brand Registry), retention/subscription, creative production.
Financial overlay: contribution margin (>35% target), COGS 25-45%, LTV:CAC 3-5:1,
first order usually unprofitable.
GATES before revenue: sales-tax nexus registration; category product-safety cert
(CPSC/CPC/FCC/UL); import compliance; trademark (for Brand Registry); FTC claims
substantiation.
Tooling: Shopify · 3PL/ShipBob · Amazon FBA · Klaviyo · Recharge · Avalara.
GAP status: mostly compose (D2C ops skills thin in warehouse).

### Digital health  (re-adds: licensed clinical care + PHI)
Added functions: clinical/medical affairs + protocols, provider network +
credentialing + multi-state licensure, HIPAA program, medical-claims review,
reimbursement/RCM/coding, patient-safety/adverse-events, clinical governance.
GATES before revenue: CPOM structure (friendly PC/MSO); clinician licensed in
patient's state (12-18mo/state); malpractice insurance; HIPAA (risk analysis +
signed BAAs); FDA class if device/SaMD (510k/De Novo/PMA); DEA if controlled
substances; payer credentialing if billing insurance; medical-director-signed
protocols + escalation pathway; FTC health-claims substantiation.
Tooling: Healthie/Canvas EHR · BAA-covered cloud · DoseSpot · Candid RCM · Medallion.
GAP status: compliance frameworks exist (hipaa skill); clinical-ops = compose.

### Manufacturing  (re-adds: regulated production + facility EHS)
Added functions: engineering/BOM/ECO/PLM, production planning (MRP/MPS) + MES,
procurement/supplier-qualification, QMS (ISO 9001), shop-floor/OEE/maintenance,
warehousing/distribution, EHS, product-safety certification.
GATES before revenue: facility EHS permits (OSHA floor; EPA Title V / NPDES /
RCRA); product-safety cert (UL/FCC/CPSC/CPC); QMS (ISO 9001 / 13485 QMSR for
devices, effective 2026-02-02); product-liability + workers-comp insurance;
frozen revision-controlled BOM.
Tooling: NetSuite/Epicor ERP · Tulip MES · Arena PLM · MasterControl QMS.
GAP status: mostly compose (production/quality/EHS thin in warehouse).

## Coordination architecture

- **Orchestrator-worker + deterministic flow**: the gate order above is the
  deterministic outer flow; each function is an autonomous crew under it. Default
  to a single strong agent per function; add sub-agents only for real parallelism
  or context-isolation (decompose by context boundary, not task type).
- **Function = SOP(Team)**: encode each function's real SOP into its role
  instructions; pass typed artifacts between functions, never chat.
- **Gates are guardrails**: every function boundary has an output guardrail (a
  reviewer/verifier) + the vertical's hard compliance gate. Underspecified
  handoffs are the top failure mode - every handoff names objective, output
  format, tools, boundaries.

## Gaps to compose (not hunt one mega-skill)

1. `company-launch` orchestrator - drives GATE 0-9 with the guardrails.
2. `entity-formation` (F8 D0) - the one spine gap that blocks everything.
3. Vertical overlay skill-packs: `d2c-ops`, `health-clinical-ops`, `mfg-production`
   - each a composed workflow of borrowed + new skills with its gate criteria.
4. `role-from-schema` - instantiate any function's roles from the fixed template.
