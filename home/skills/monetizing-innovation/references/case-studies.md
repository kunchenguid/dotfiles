# Case Studies: Monetizing Innovation in Practice

## Table of Contents

- [Case Study 1: From Flat Rate to Value Tiers](#case-study-1-from-flat-rate-to-value-tiers)
- [Case Study 2: Catching Feature Shock Before Launch](#case-study-2-catching-feature-shock-before-launch)
- [Case Study 3: Fixing Freemium with a Leader Paywall](#case-study-3-fixing-freemium-with-a-leader-paywall)
- [Key Takeaways](#key-takeaways)

## Case Study 1: From Flat Rate to Value Tiers

### Context

A 14-person B2B SaaS company sells project-profitability analytics to creative and consulting firms. One price: $99/month per workspace, unlimited everything. 640 paying customers, $760K ARR, growth slowing.

### The Problems

**Sales were suspiciously easy.** Win rate against the only real competitor was 84%. Prospects rarely questioned the price; several closed-won notes contained variations of "this is a no-brainer at this price." Nobody treated this as a symptom.

**Wildly different customers paid identical money.** A 3-person studio tracking five projects paid $99. A 70-person consultancy running 400 projects through the API, with finance exporting to their ERP weekly, paid $99. Support time for the consultancy was 20x the studio's.

**ARPU was frozen.** The only growth lever was new logos. Expansion revenue was structurally zero — there was nothing to expand into.

### The Intervention

**Step 1: WTP interviews (weeks 1-4).** The founders ran 22 interviews across the base — 8 small studios, 8 mid-size agencies, 6 large consultancies — using the three-point probe and feature point-allocation. Two excerpts from the script:

> "Setting our current price aside completely — for what this does for your firm today, what would feel like an acceptable price? What would feel expensive but still worth it? Where does it become out of the question?"

> "You have 100 points. Spread them across these twelve capabilities in proportion to their value to you."

**Step 2: Read the curve.** The answers clustered into three populations, not one:

| Cluster | Acceptable | Expensive | Prohibitive | Top-valued capabilities |
|---------|-----------|-----------|-------------|------------------------|
| Studios (1-10 staff) | $40-60 | $90-120 | $150+ | Core dashboards, time import |
| Agencies (11-50) | $120-180 | $250-300 | $400+ | Approval workflows, client reporting, integrations |
| Consultancies (50+) | $350-500 | $700-900 | $1,200+ | API, SSO, ERP export, permissions |

The flat $99 sat above the studios' comfort zone and at roughly one quarter of the consultancies' acceptable price — minivation at the top, mild overpricing at the bottom, in the same number.

**Step 3: Leader/filler/killer per segment.** Client-branded reporting was a leader for agencies, invisible to studios. The API was a consultancy leader and a studio killer when bundled into price expectations ("we'd never use it — feels like we're paying for plumbing"). Onboarding services (mandatory at the time, baked into pricing assumptions) tested as a killer for everyone when framed as paid-and-required.

**Step 4: Tier design.** Studio $59 (dashboards, time import, 3 seats), Agency $199 (workflows, client reporting, integrations, 15 seats), Firm $549 (API, SSO, ERP export, unlimited seats, priority support). Onboarding became optional and paid. The pricing page ordered tiers Firm-first as the anchor; Agency carried the "Most popular" badge, which the cohort data later justified.

**Step 5: Migration.** Existing customers were grandfathered at $99 for 12 months, with an opt-in offer: switch early and lock the new tier at 20% off for a year. New signups saw only the new tiers. The announcement led with two years of shipped features before mentioning numbers.

### Results After Two Quarters

| Metric | Before | After |
|--------|--------|-------|
| ARPU (new customers) | $99 | $214 |
| Win rate | 84% | 71% |
| New-customer revenue per quarter | baseline | +63% |
| Expansion revenue | $0 | 9% of ARR (tier upgrades) |
| Logo churn (existing base) | 1.7%/mo | 1.9%/mo, settling to 1.6% |
| Support load per account (top tier) | unpriced | covered by Firm margin |

### Lessons Learned

1. **An 84% win rate was the loudest data point in the company, and nobody was listening.** Frictionless sales is a pricing symptom before it is a sales achievement.
2. **One number cannot serve a bimodal market.** The flat price was simultaneously too high and absurdly low — only segmentation exposed that both were true.
3. **Grandfathering bought the right to reprice.** The feared exodus never happened; churn moved 0.2 points and recovered.
4. **The win-rate drop was the plan working.** Losing more price-sensitive deals at $214 ARPU beat winning everything at $99.

## Case Study 2: Catching Feature Shock Before Launch

### Context

A seed-stage startup (9 people, 14 months of runway) is six weeks from launching an AI meeting assistant for sales teams. The spec has grown to seven modules: transcription, action-item extraction, CRM sync, deal-risk scoring, coaching scorecards, conversation analytics dashboards, and a manager digest. Target price: $45/seat to support the surface area. A board member asks one question: "What's the willingness-to-pay evidence?" There is none.

### The Problems

**The pitch had stopped fitting in a sentence.** Each module had a constituency inside the company; no two demos followed the same path; the deck described the product as "an AI revenue intelligence platform," which described nothing.

**Price was cost-derived.** $45/seat came from working backward from burn and headcount, not forward from value.

**Engineering was six weeks from shipping the hardest 40%** — the analytics dashboards and risk scoring consumed most of the remaining timeline and all of the model-hosting budget.

### The Intervention

**Step 1: Three-week WTP sprint.** 19 interviews with sales managers and RevOps leads (the economic buyers), run on concept cards — one card per module, then bundle questions. Methods: top-5 decision ranking, 100-point allocation, purchase-probability at $25/$45/$65 per seat.

**Step 2: The curve came back flat.** Purchase-probability top-box at $45 was nearly identical for "transcription + action items + CRM sync" (3 modules) and the full 7-module platform — 32% vs 35%. Four modules added cost, complexity, and weeks of timeline for three points of stated intent. Point allocation told the same story: transcription, action items, and CRM sync absorbed 71 of 100 points on average. Coaching scorecards polarized: managers allocated points; reps' organizations saw surveillance — a killer pattern for bottom-up adoption.

**Step 3: Classify and cut.** Leaders: transcription quality, action-item extraction, CRM sync. Fillers: manager digest, conversation analytics (v1). Killer (for the land motion): coaching scorecards. Deal-risk scoring: insufficient evidence either way — deferred. The launch spec dropped from seven modules to three plus a digest email.

**Step 4: Reprice the focused product.** With the WTP probes putting acceptable at $18-25 and expensive at $40-50 for the three-leader bundle, launch pricing landed at $24/seat (Team) with a $49/seat tier (Business: SSO, advanced CRM mappings, priority support) as anchor and enterprise home. The cost model also shrank: cutting the dashboards halved inference and storage spend per account.

**Step 5: Re-spec the roadmap behind evidence gates.** Coaching and risk scoring moved to a "build when 10 paying customers rank it top-3" rule — a standing WTP gate instead of a backlog debate.

### Results

| Metric | Original plan | Actual launch |
|--------|--------------|---------------|
| Modules at launch | 7 | 3 (+ digest) |
| Launch date | 6 weeks out (at risk) | Shipped 2 weeks early |
| Price | $45/seat, single plan | $24 / $49 two-tier |
| Trial → paid (first 90 days) | — (projected 8%) | 19% |
| Infra cost per account | $11/seat/mo | $4.10/seat/mo |
| Sales demo length | 40 min | 14 min |

Eight months later, deal-risk scoring cleared its evidence gate (12 customers ranked it top-3) and shipped into the Business tier — as an upgrade driver rather than launch ballast.

### Lessons Learned

1. **Feature shock is diagnosable before launch:** a flat WTP curve while scope grows is the signature. Three weeks of interviews saved six weeks of building and a mispriced launch.
2. **Cutting reduced the price and raised the margin simultaneously** — the cost structure of feature shock is part of the trap.
3. **A killer can hide in a feature the buyer loves:** managers wanted scorecards; the users who drive adoption feared them. Per-constituency classification caught it.
4. **Evidence gates ended the loudest-voice roadmap.** "Ten paying customers rank it top-3" is a rule everyone can lose to gracefully.

## Case Study 3: Fixing Freemium with a Leader Paywall

### Context

A collaborative moodboard and asset-review tool for design teams: 380,000 registered users, strong word-of-mouth growth, and a free-to-paid conversion rate of 1.1% that has not moved in a year. Free tier: unlimited boards, unlimited collaborators, full review tooling. Pro ($12/user/month): version history, brand-kit storage, priority support. The company raised on growth; the board now asks about revenue.

### The Problems

**Free contained the leader.** Interviews and support data showed the product's purchase-driving value was running structured client reviews on shared boards — fully available free. Pro's fence was made of fillers: version history was rated "nice"; brand kits served a minority.

**Heavy users had no reason to pay.** Agencies ran 30-board client workflows on the free tier. The "upgrade" page's top feature, version history, had been opened by 7% of free users — people do not pay for what they never reach for.

**The team feared touching free.** Unlimited-everything free was credited (correctly) for viral growth; any proposal to restrict it died as "killing the growth engine."

### The Intervention

**Step 1: Find the habit point in usage data.** Cohort analysis split free users by peak active boards. Users who reached 4+ active boards retained at 68% after six months and accounted for nearly all referral invitations; users at 1-3 boards retained at 22%. Four boards was where the tool stopped being a toy and became a workflow.

**Step 2: WTP research on actual value, not feature lists.** 250 survey responses from active free teams (three-point probe plus point allocation) and 12 interviews with agencies. Result: WTP concentrated on "running multiple client projects" ($10-18/user acceptable among agencies) — board capacity, not version history, was the leader. Collaborators and review tooling tested as the viral loop: gating them would tax the invitations that drove acquisition.

**Step 3: Move the fence to the leader, protect the loop.** New free tier: 3 active boards (archive anytime), unlimited collaborators, full review tooling — the viral surface untouched. Pro at $14: unlimited active boards, version history, brand kits. The paywall now sat exactly at the habit point: the fourth board, the moment a team was provably committed.

**Step 4: Migration with dignity.** Existing free users over the limit kept all boards editable for 90 days (clearly communicated), then boards beyond three became read-only — never deleted, always exportable. The in-product prompt at the limit said what the user was doing, not what they were missing: "This would be your 4th active board — that's where teams go Pro."

**Step 5: Pre-agreed launch triggers.** Before shipping, the team wrote thresholds: if weekly signups fell >15% for four consecutive weeks, or paid conversion failed to reach 2% by day 60, specific rollback and adjustment steps would execute. Nobody would be deciding policy at midnight from a panicked dashboard.

### Results After 90 Days

| Metric | Before | After |
|--------|--------|-------|
| Free → paid conversion | 1.1% | 3.9% |
| Weekly signups | baseline | −6% (within tolerance, recovered by week 9) |
| MRR | baseline | +212% |
| Referral invitations per active user | baseline | unchanged |
| Free-user support tickets | baseline | −18% (smaller active free surface) |
| Churn of new Pro cohort (monthly) | — | 2.3% |

### Lessons Learned

1. **Freemium fails when generosity and strategy are confused.** The free tier had been designed by enthusiasm; redesigning it as engineered acquisition (loop free, leader fenced) fixed conversion without breaking growth.
2. **Usage data found the fence; WTP research justified the price.** Neither alone was sufficient — the habit point said *where*, the interviews said *how much*.
3. **Gate the leader, never the viral loop.** Unlimited collaborators looked like the obvious thing to monetize and would have been the most expensive mistake available.
4. **Pre-agreed triggers kept the team from panic-reverting** during the week-3 signup dip that later self-corrected.

## Key Takeaways

**1. The diagnosis is in data you already have.** An 84% win rate, a flat WTP curve across growing scope, a 1.1% conversion with the leader given away — each company was sitting on its own answer before the first interview.

**2. WTP research changes the product, not just the price.** Case 2 cut four modules; case 3 redrew the free tier; case 1 unbundled onboarding. The price tag was the last thing to change in every story.

**3. Segments make contradictory signals coherent.** "Too expensive" and "comically cheap" arriving in the same week is not noise — it is two segments describing one mispriced product.

**4. Repricing is survivable when communication leads with value and migration preserves dignity.** Grandfathering, read-only (never deleted) data, and value-first announcements turned feared revolts into footnotes.

**5. Decide reactions before launch.** Both launches that could have triggered panic (cases 1 and 3) had pre-agreed thresholds — so temporary dips were monitored instead of "fixed" with permanent discounts.
