# Packaging, Tiers, and Bundles

## Table of Contents

- [Leaders, Fillers, Killers](#leaders-fillers-killers)
- [The Classification Procedure](#the-classification-procedure)
- [Good-Better-Best Design Rules](#good-better-best-design-rules)
- [Naming Tiers](#naming-tiers)
- [The Feature-Allocation Matrix](#the-feature-allocation-matrix)
- [Designing Upgrade Paths](#designing-upgrade-paths)
- [Bundle or Unbundle: A Checklist](#bundle-or-unbundle-a-checklist)
- [Pricing-Page Implications](#pricing-page-implications)

## Leaders, Fillers, Killers

Packaging starts from one observation: features are not equal in the buyer's mind, and treating them equally destroys value. Every feature falls into one of three classes — *for a given segment*:

- **Leaders** drive the purchase decision. The buyer would walk without them; they would pay meaningfully more to get them. A package exists to deliver its leaders.
- **Fillers** add modest value. Nice to have, tip the scales in a tie, harmless to include — but nobody buys for them and nobody pays extra for them. Fillers round out a package and differentiate tiers cheaply.
- **Killers** reduce willingness to pay when forced into the package. The buyer does not want them and resents funding them. Classic killers: paid-for capabilities a segment will never use ("why am I paying for call-center features?"), mandatory services (required onboarding fees), or features that add complexity the segment fears.

The segment qualifier is everything. On-premise deployment is a killer for a startup buyer (cost, maintenance, fear) and a leader for a bank (compliance). SSO is invisible to freelancers and non-negotiable for enterprises. There is no absolute list — only a per-segment classification, which is why segmentation precedes packaging.

## The Classification Procedure

Run this before designing tiers, and again whenever a significant feature ships:

1. **List the units of value.** Enumerate every feature or capability a buyer could perceive as a thing they get — typically 15-30 items. Group sub-features (ten small report types = "reporting"). If the list exceeds ~30, you are itemizing too finely.
2. **Collect evidence per item, per segment.** From WTP interviews and surveys:
   - *Decision impact:* "Which of these would have to be present for you to buy?" / "Rank the top 5 that drive your decision."
   - *Incremental WTP:* "How much more would you pay for a version with X?" or point-allocation across the list.
   - *Negative reaction:* "Which of these would you not want to pay for, even bundled?" / "Would including X at a higher price make you walk away?"
3. **Score and classify.** A practical rubric per segment:

| Evidence pattern | Class |
|------------------|-------|
| Top-5 decision ranking for ≥40% of segment, positive incremental WTP | Leader |
| Rarely ranked, near-zero incremental WTP, no negative reaction | Filler |
| ≥20% of segment reacts negatively to paying for it | Killer |

4. **Sanity-check against behavior.** Usage data, lost-deal notes, and support requests should corroborate. A "leader" nobody uses after purchase is a marketing leader only — fine, but know it. A "filler" that churned customers cite as missing was a leader you misread.
5. **Decide the fate of each killer.** Three options: unbundle into an optional add-on (the default), move it to a tier whose segment values it (where it may be a leader), or cut it entirely if it is a killer for everyone.

## Good-Better-Best Design Rules

Three tiers is the default architecture because it exploits how people choose: extremes feel risky, the middle feels safe, and a premium anchor makes everything below it look reasonable.

1. **Design "Better" first.** The middle tier is the offer most buyers should take — the compromise effect will pull them there anyway, so build it to be genuinely right for your core segment and price it where you want your average revenue to land.
2. **"Best" is the anchor and the enterprise home.** It must contain real leaders for the high-WTP segment (not just bigger limits), priced 2-4x "Better." Even at modest volume it pays twice: directly, and by making "Better" an easy yes.
3. **"Good" is the fenced entry.** It exists to capture the low-WTP segment and to start upgrade journeys. Give it real value — a taste of the leader, not the meal. If "Good" fully contains the leader, nobody upgrades; if it is useless, it poisons trust and trials.
4. **Plan around a 70/20/10 shape.** As a planning expectation, aim for roughly 70% of buyers in Better, 20% in Best, 10% in Good. Strong deviations are diagnostic: most buyers in Good means weak fences or an overpriced middle; most in Best means your anchor is missing and you are likely minivating.
5. **Fence with leaders, then limits.** The primary fence between tiers should be a feature the higher segment genuinely values (leader fence). Quantity limits (seats, projects, API calls) are secondary fences — good for growth-based upgrades, weak as the only differentiator.
6. **Four tiers maximum.** A fourth tier (usually a free or a custom-enterprise tier) is acceptable; five or more measurably increases choice paralysis and support burden. Collapse before you add.
7. **Price gaps must be explainable in one sentence per gap.** "Team adds the integrations and approvals agencies need" — if you cannot say it, the buyer cannot see it, and the gap reads as arbitrary.

## Naming Tiers

Tier names are a self-segmentation device: a buyer should know which tier is theirs within five seconds.

- **Name by customer or use stage:** Solo / Team / Business / Enterprise, or Starter / Growth / Scale. These work because buyers identify themselves before reading the feature table.
- **Avoid opaque sequences** (Bronze/Silver/Gold, Basic/Plus/Premium) when segments differ by *kind* of need — metals only communicate "more," not "for whom."
- **Never name a tier something aspirational that insults the others.** "Professional" above "Basic" implies Basic buyers are amateurs; they notice.
- **Keep names stable.** Renaming tiers invalidates documentation, reviews, and word-of-mouth ("get the Team plan") — rename only with a repackaging worth that cost.

## The Feature-Allocation Matrix

The working artifact of packaging design — every feature, its classification per target segment, and its tier placement:

| Feature | Class (segment) | Good ($19) | Better ($49) | Best ($129) | Add-on |
|---------|-----------------|------------|--------------|-------------|--------|
| Core editor | Leader (all) | ✓ | ✓ | ✓ | — |
| Projects | Fence (limit) | 3 | 25 | Unlimited | — |
| Slack/Teams integration | Leader (Team seg) | — | ✓ | ✓ | — |
| Approval workflows | Leader (Team seg) | — | ✓ | ✓ | — |
| Advanced analytics | Leader (Agency seg) | — | — | ✓ | — |
| API access | Leader (Agency seg) | — | Read-only | ✓ | — |
| Custom branding | Filler | — | ✓ | ✓ | — |
| Email support | Filler | ✓ | ✓ | ✓ | — |
| Dedicated CSM | Leader (Enterprise) | — | — | ✓ | — |
| On-prem deployment | Killer (SMB) / Leader (Ent) | — | — | — | $ |
| Mandatory onboarding | Killer (all) | — | — | — | Optional $ |

Rules visible in the template: each tier above Good adds at least one leader for its segment; killers never sit inside a tier price; limits create a second, growth-driven upgrade trigger; every row has an explicit decision (no "TBD" rows on a shipping pricing page).

## Designing Upgrade Paths

Packaging is static; customers are not. Design the journey between tiers:

- **Place the fence where usage naturally grows.** The best upgrade trigger is success: the team that hits the 3-project limit because the product worked. Analyze usage distributions and put limits just *below* the point where committed users land (if engaged teams typically reach 4-6 projects, the free/entry cap is 3).
- **Prompt at the moment of need, not on a schedule.** "You've hit your project limit — Team gives you 25" converts; a monthly upsell email annoys. Every fence needs an in-product moment that explains the next tier in terms of what the user was just trying to do.
- **Let users preview the leader.** Time-boxed trials of higher-tier features (7 days of analytics when first opened) outperform descriptions. A leader experienced is a leader bought.
- **Never make downgrades destructive.** Losing access to premium features is acceptable; losing data or exports is hostage-taking — it poisons reviews and, in some jurisdictions, regulators agree.
- **Mind the cliff between self-serve and enterprise.** If Best is $129/seat and Enterprise is "call us" starting at 10x, mid-market buyers fall into the gap. Bridge with a transparent volume schedule or a mid tier.

## Bundle or Unbundle: A Checklist

Bundling raises total willingness to pay when the parts reinforce each other; it destroys clarity when they do not. Work through the list:

**Bundle when most of these are true:**

- [ ] Components are complementary in use — each makes the others more valuable (editor + review + publishing)
- [ ] One buyer evaluates and pays for all components
- [ ] Buyers' WTP for components is *negatively correlated* (some value A highly and B mildly, others the reverse) — the bundle averages both into one strong yes
- [ ] Buying separately would create integration or decision friction you can remove
- [ ] The bundle story is tellable in one sentence ("everything a podcast team needs")

**Unbundle when any of these is true:**

- [ ] A component is a killer for a meaningful segment of bundle buyers
- [ ] Different components are bought by different roles or budgets
- [ ] A component's natural price metric differs (per-seat product bundled with a per-volume API)
- [ ] The bundle price exceeds the prohibitive threshold of your core segment even though individual WTPs are healthy
- [ ] Competitors win by selling the one component a customer wants without the rest

Default resolution for borderline cases: tiered bundles (the core bundle plus add-ons) — keep the complementary heart together and let contested components be chosen.

## Pricing-Page Implications

The pricing page is where packaging theory meets a visitor with 20 seconds of patience:

1. **Three or four columns, one highlighted.** Highlight "Better" with a "Most popular" badge — only if it is actually true; invented popularity claims are both unethical and, in several markets, illegal.
2. **Use the anchor deliberately.** Either order tiers premium-first (strong anchor for sales-led products) or highlight the middle with the premium adjacent (standard for self-serve). Never hide the premium tier — it is doing anchoring work even when unsold.
3. **Lead each column with its leader.** The first 2-3 bullets under each tier name must be that tier's leaders for its segment — not the longest list. Bury fillers in the expandable comparison table below.
4. **State the price metric next to the price.** "$49 per editor / month, billed annually" — ambiguity about the metric ("per user? per viewer?") kills conversion and seeds support debt.
5. **Make the annual/monthly toggle honest.** Show the math; don't display annual-billed prices as if monthly without labeling.
6. **Answer fence questions in an FAQ.** "What happens when I hit the project limit?", "Can I downgrade?", "Do viewers cost money?" — every fence creates a question; unanswered questions create abandoned carts.
7. **Test packaging before price.** A/B tests that move features between tiers or change the highlighted column routinely shift revenue more than ±10% price tests — and are safer to run.
