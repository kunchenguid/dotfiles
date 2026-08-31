# Case Studies: Lean Analytics in Practice

## Table of Contents

- [Case Study 1: From 34 Widgets to One Number](#case-study-1-from-34-widgets-to-one-number)
- [Case Study 2: The Marketplace That Measured the Wrong Thing](#case-study-2-the-marketplace-that-measured-the-wrong-thing)
- [Case Study 3: The App That Almost Bought Growth](#case-study-3-the-app-that-almost-bought-growth)
- [Key Takeaways](#key-takeaways)

## Case Study 1: From 34 Widgets to One Number

### Context

A 20-person B2B SaaS company sells proposal software to creative agencies. Two years in: ~$70K MRR, growing slowly. The leadership dashboard, assembled tile by tile over two years, shows 34 widgets — MRR, signups, sessions, NPS, feature usage charts, support volume, Twitter followers, blog traffic, and more.

### The Problems

**Meetings argued about interpretation, not action.** Every Monday, an hour dissolved into debating why sessions dipped or which definition of "active" was correct. Three teams used three different churn formulas. Nobody could say which number, if it halved, would constitute an emergency.

**The metrics never changed a decision.** Reviewing six months of roadmap choices, the founders found exactly zero that had been triggered by a dashboard number. Features shipped because customers asked loudly or competitors had them. The dashboard was a spectator.

**The flattering numbers masked the dangerous one.** Total signups and cumulative revenue climbed reliably up and to the right. Buried in a drill-down: monthly customer churn was 7.2%, meaning the company replaced more than half its customer base every year just to stay still.

### The Application

**Step 1: Audit every widget with the four tests.** Comparative, understandable, ratio or rate, behavior-changing. Nine of 34 survived; the rest were totals, cumulative curves, or numbers nobody could attach a decision to. The deleted tiles moved to an archive report — available, not ambient.

**Step 2: Name the model and the stage.** Model: SaaS, unambiguous. Stage: the team assumed Revenue ("we have MRR"). The cohort table said otherwise — retention curves didn't flatten; every cohort slid toward zero by month 10. Revenue with collapsing retention is Stickiness with a billing system. Stage: Stickiness.

**Step 3: Find the value moment.** Mining cohorts showed accounts that sent at least one real proposal in their first week retained at 3x the rate of those that didn't. An onboarding experiment that pushed trials toward sending a first proposal (template gallery plus a "send your first proposal" checklist) moved week-4 retention in the test group — evidence the behavior was causal, not just a marker of motivated customers.

**Step 4: Install the OMTM and counter-metric.** OMTM: **week-4 retention of new accounts**, defined as performing the core action (proposal sent) in days 22-28, cohorted weekly. Baseline: 31%. Counter-metrics: weekly trial signups (don't strangle the funnel while optimizing depth) and monthly churn (the lagging confirmation).

**Step 5: Draw the line in the sand.** 45% week-4 retention by end of Q2. Pre-committed responses, written in the metrics doc: hit → rotate the OMTM to net MRR churn and unfreeze paid acquisition tests; miss → a two-week diagnostic sprint, and if interviews showed the product served freelancers better than agencies, pivot the ICP.

**Step 6: Rebuild the dashboard and the ritual.** One screen: week-4 retention huge, with the 45% target line drawn on the chart; five small tiles below — trial signups, activation rate, churn, MRR, support load. Monday meeting agenda became three questions: what did the number do, which experiments touched it, what's the next bet.

### Results After One Quarter

| Metric | Before | After |
|--------|--------|-------|
| Dashboard widgets | 34 | 6 |
| Week-4 retention | 31% | 47% |
| Monthly customer churn | 7.2% | 4.4% |
| Monday metrics meeting | 60 min, inconclusive | 25 min, ends in decisions |
| Decisions traceable to metrics (per quarter) | 0 | 9 |
| MRR growth rate | 3%/mo | 5%/mo |

### Lessons Learned

1. **Deleting metrics created information.** With 34 widgets, every signal was ambient noise; with one number and a target, a bad week was unmissable and meant something.
2. **The stage diagnosis was the unlock.** Calling themselves "Revenue stage" had justified acquisition spend that churn quietly canceled. Admitting Stickiness redirected the same budget to onboarding, where it compounded.
3. **The counter-metric earned its keep immediately.** The first onboarding redesign gated features aggressively and trial signups dropped 14% — the guardrail caught a "win" that was strangling the funnel, and the second iteration fixed both.

## Case Study 2: The Marketplace That Measured the Wrong Thing

### Context

A two-sided marketplace for renting camera and film gear between owners and working videographers. Eighteen months in, operating in six cities. The investor update headlines: GMV up 19% quarter-over-quarter, total listings up 31%, 11,000 registered users. The seed round is being raised on a "growth" story.

### The Problems

**Both headline numbers were vanity.** GMV grew because listings grew; listings grew because signup promos rewarded posting gear. Neither number said whether renters found what they needed or whether owners earned anything.

**The experience contradicted the dashboard.** Renters searched, found nothing available nearby, and left. Owners listed three lenses, got zero inquiries for a month, and went dormant. Support tickets said "ghost town"; the dashboard said "up and to the right."

**Growth spend amplified the dysfunction.** Acquisition budget recruited more owners (the easy side), worsening the imbalance — more shelves, same few shoppers.

### The Application

**Step 1: Define liquidity for the category.** The team adopted two definitions: **fill rate** — % of listings rented at least once in 30 days — and **search-to-fill** — % of searches leading to a completed rental within 7 days. Gear rental is time-sensitive (shoots have dates), so the windows were set accordingly rather than copied from another marketplace.

**Step 2: Measure honestly, per market.** The blended numbers were grim: fill rate 9%, search-to-fill 11%. Per-city was worse: one city accounted for most transactions; in three cities, search-to-fill was under 4% — dead pools propped up by the blend. Concentration analysis showed 9% of listings produced 78% of rentals: a few well-stocked, responsive owners *were* the marketplace.

**Step 3: Choose the OMTM and counter-metrics.** OMTM: **search-to-fill in the two strongest cities** — demand-side liquidity, since searches were abundant and dying. Counter-metrics: median rental value (to prevent juicing fills with fire-sale pricing) and dispute rate (to catch quality collapse from rushed transactions). Baseline: 11%. Line in the sand: 25% in both focus cities within two quarters; miss → contract to one city and one gear category until liquidity worked somewhere.

**Step 4: Act against the vanity metrics.** The playbook deliberately *shrank* the flattering numbers: pause all acquisition spend outside the two focus cities; delist inventory inactive for 60 days (listings fell 38%); require availability calendars so search returned only rentable gear; recruit "anchor owners" with deep, in-demand inventory near production hubs; add date-first search.

**Step 5: Survive the optics.** The investor update explained why listings and GMV would fall while the business improved, replacing the growth story with a liquidity story: "marketplaces are bought on density, and we now measure it."

### Results After Two Quarters

| Metric | Before | After |
|--------|--------|-------|
| Search-to-fill (focus cities) | 11% | 27% |
| Fill rate, 30-day (focus cities) | 9% | 31% |
| Total listings | 8,400 | 5,200 |
| Repeat renters per month | 6% | 19% |
| Owner 90-day dormancy | 71% | 44% |
| GMV | flat, then +12%/quarter | compounding from repeat usage |

### Lessons Learned

1. **The right metric was the one that got worse before better.** Listings and GMV had to fall for liquidity to rise. A team graded on vanity numbers could never have made those moves.
2. **Liquidity is local.** The blended dashboard averaged one working city with five dead ones. Measuring per market turned "we're growing" into "we work in exactly one place — make it two."
3. **The constraint side is rarely the easy side.** Promos recruited supply because supply was easy. The business was demand-constrained the whole time, and only search-to-fill made that visible.

## Case Study 3: The App That Almost Bought Growth

### Context

A free mobile habit-tracking app with premium subscriptions. A seed round just closed, and the plan in the deck allocates $60K/month to paid user acquisition starting next month. Launch buzz delivered 40,000 installs organically.

### The Problems

**Retention was catastrophic and unexamined.** D1 retention: 38%. D7: 12%. D30: 4%. DAU/MAU: 9%. Against the ~14% D30 average for casual apps, the product sat well below par — but the deck quoted total installs.

**The UA plan multiplied a leak.** At those curves, paid installs would be 96% gone within a month. Modeled honestly, the $60K/month bought a treadmill: spend stops, "growth" stops, cash gone.

**Monetization math depended on retention that didn't exist.** Premium conversion happened almost exclusively after day 14 of use. With 8% of users surviving to day 14, the LTV model in the spreadsheet was fiction.

### The Application

**Step 1: Stage check, then freeze.** Model: free mobile app. Stage: Stickiness — unambiguously, given the curves. The founders froze the UA budget with a written unfreeze condition rather than an open-ended delay: **D7 ≥ 25% and DAU/MAU ≥ 20%, held for four consecutive weekly cohorts.**

**Step 2: Mine cohorts for the value moment.** Two behaviors separated retained users: setting a reminder in the first session (3x D30 retention) and tracking 3+ habits in week one (2.5x). Interviews with retained users added the why: the reminder *was* the product — people stayed because the app interrupted their day at the right moment.

**Step 3: Test causality.** Experiment 1: onboarding redesign making reminder setup the default path → D7 rose 12% → 19% — causal, productize. Experiment 2: prompting users to add three habits → no retention effect — a marker of pre-existing intent, not a lever. The team stopped pushing habit count.

**Step 4: Install the OMTM and guardrail.** OMTM: **D7 retention**, weekly cohorts, displayed against the 25% line. Counter-metric: notification opt-out rate — the obvious failure mode of a reminder-centric strategy is spam, and opt-outs permanently destroy the channel the retention strategy depends on.

**Step 5: Iterate inside the freeze.** Smart reminder timing (learn from completion times), a streak-repair flow (lapsed users churned out of shame — "repair your streak" brought a measurable share back), and a home-screen widget. Two cohort-weeks per iteration, each judged only on D7 and the opt-out guardrail.

**Step 6: Unfreeze deliberately.** After 14 weeks: D7 at 27%, D30 at 13%, DAU/MAU at 22%, opt-outs flat. UA unfroze at $15K/month — a test, not a flood — with channel-level cohort tracking and a new line in the sand: paid cohorts must hit D7 ≥ 20% per channel, or that channel stops.

### Results

| Metric | At funding | At UA unfreeze (14 weeks) |
|--------|------------|---------------------------|
| D7 retention | 12% | 27% |
| D30 retention | 4% | 13% |
| DAU/MAU | 9% | 22% |
| Notification opt-out rate | 11% | 12% (guardrail held) |
| Day-14 survivors (premium-eligible) | 8% | 21% |
| Projected payback on $60K/mo UA | never | ~11 months |

### Lessons Learned

1. **The freeze was the highest-ROI decision of the year.** Three months of planned UA at the old curves would have spent ~$180K renting users who left. Stickiness first made the same dollars buy compounding users later.
2. **Correlation mining found two candidates; experiments kept one.** Without the causality test, the team would have spent a quarter pushing habit counts — a metric that moved nothing.
3. **The counter-metric shaped the solution space.** Knowing opt-outs were the guardrail pushed the team toward *smarter* notifications instead of *more* notifications — the lazy path was closed in advance.

## Key Takeaways

1. **The OMTM is a focusing device, not a data strategy.** All three teams kept collecting broad data; what changed was that one number, with a target and a date, decided what the company did next.
2. **Vanity numbers can shrink while the business improves.** Deleted widgets, delisted inventory, frozen install campaigns — each case required making a flattering number worse to make the real one better.
3. **Stage discipline protects runway.** Every case contains the same near-miss: spending scale-stage money on a stickiness-stage product. The gates exist to make that error visible before the wire transfer.
4. **Counter-metrics keep wins honest.** Trial signups, median rental value, notification opt-outs — in each case the guardrail caught or prevented a "win" that would have quietly cost more than it paid.
5. **Lines in the sand turn analytics into decisions.** Pre-committed targets and miss responses meant results — good or bad — executed a plan instead of starting a debate.
