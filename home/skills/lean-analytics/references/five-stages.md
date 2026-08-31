# The Five Stages of Lean Analytics

## Table of Contents

- [How the Stages Work](#how-the-stages-work)
- [Stage 1: Empathy](#stage-1-empathy)
- [Stage 2: Stickiness](#stage-2-stickiness)
- [Stage 3: Virality](#stage-3-virality)
- [Stage 4: Revenue](#stage-4-revenue)
- [Stage 5: Scale](#stage-5-scale)
- [Stage, Funding, and Runway](#stage-funding-and-runway)
- [Diagnosing Your Stage](#diagnosing-your-stage)

## How the Stages Work

Lean Analytics sequences a startup's life into five stages — **Empathy, Stickiness, Virality, Revenue, Scale** — each answering one question, each gated by evidence. The gates exist because the stages compound: virality multiplies whatever retention you have (multiply a leak, get a bigger leak), and paid acquisition multiplies whatever unit economics you have (scale negative margins, get faster death). Three rules govern the system:

1. **Gates are evidence, not time.** You don't age into a stage. You exit with data: a flattening retention curve, a payback period inside tolerance.
2. **Your OMTM is stage × model.** The stage names the question; your business model names the metric that answers it.
3. **Movement is bidirectional.** A pivot, a new segment, or a collapsed metric sends you back. Going back early is cheap; refusing to is how runways end.

## Stage 1: Empathy

**The question:** have we found a real problem, painful and frequent enough that identifiable people will pay to fix it?

**What to measure:** this stage is mostly qualitative, and that's correct — at zero volume, quantitative metrics are noise with decimal points. The instrument is the problem interview: 15+ conversations per target segment, scored for pain (do they describe it with emotion and specifics?), frequency (weekly beats yearly), budget (do they already pay for or hack around a solution?), and reachability (can you find more people like this?). Weak quantitative signals — landing-page conversion, waitlist signups from a concept ad — are useful smoke tests, not proof. Track interview findings in a simple tally: how many of the last 15 interviewees confirmed the problem unprompted?

**Exit criteria:**

- [ ] 15+ problem interviews in one named segment, without pitching the solution
- [ ] A majority describe the problem as painful, frequent, and currently costing them money or time
- [ ] They've tried workarounds — spreadsheets, hires, competing tools (apathy is the kiss of death; existing hacks are demand)
- [ ] Solution interviews produce real commitment: time, data, a pilot, a deposit — not compliments
- [ ] You can describe exactly who has the problem and where to find a thousand more of them

**Premature-scaling symptoms:** writing code for months before the first interview; buying ads to a problem nobody confirmed; hiring sales for a pitch that hasn't survived 15 conversations; mistaking friends' politeness for validation.

**Funding/runway:** the cheapest stage — burn conversation hours, not cash. Pre-seed money here buys interviews, prototypes, and smoke tests. Raising a large round at Empathy converts unvalidated guesses into payroll.

## Stage 2: Stickiness

**The question:** do people use the product repeatedly, of their own accord?

**What to measure:** retention cohorts on the core value action (not logins), DAU/MAU for habit-shaped products, time-to-value for new users, and frequency of the core action among retained users. Two cross-checks help calibrate: the Sean Ellis product-market-fit survey ("how would you feel if you could no longer use this?" — around 40%+ answering "very disappointed" is the classic threshold), and for apps, the 30/10/10 heuristic — roughly 30% of signups active monthly, 10% daily is a strong showing.

**Exit criteria:**

- [ ] Cohort retention curves flatten — they stop decaying and hold at a floor that supports the business model
- [ ] Newer cohorts retain as well as or better than older ones (the product is improving, not just the audience)
- [ ] Users return without prompting — organic return visits, not notification-driven spikes
- [ ] You know your value moment: the early behavior causally linked (tested, not just correlated) to long-term retention
- [ ] Engagement is concentrated in the segment you intend to build for

**Premature-scaling symptoms:** spending on acquisition or building referral loops while the bucket leaks; shipping breadth (new features, new platforms) when depth (the core loop) hasn't proven habit-forming; celebrating MAU growth driven entirely by top-of-funnel while cohort curves slide to zero.

**Funding/runway:** the longest stage for most companies — budget runway for several product iterations, not one. This is the worst stage to raise a growth round: money arrives with growth expectations the retention can't support, and the spend pressure starts the leaky-bucket fire.

## Stage 3: Virality

**The question:** do users bring other users — sustainably and cheaply enough to change your acquisition math?

**What to measure:** the viral coefficient k = invitations sent per user × conversion rate of invitations, and **viral cycle time** — how long a generation takes. Cycle time is the under-appreciated half: growth compounds per cycle, so shortening the cycle from weeks to days often outgrows raising k. Distinguish three kinds of virality: **inherent** (the product works better when shared — documents, payments, multiplayer), **artificial** (incentivized invites — bought, and it shows in invited-cohort quality), and **word-of-mouth** (untracked praise — survey "how did you hear about us?" to estimate it). Even k < 1 is valuable: each acquired user yields 1/(1−k) total users, so k = 0.5 doubles every acquisition channel's efficiency.

**Exit criteria:**

- [ ] k measured from instrumented invite flows, not inferred from growth wishes
- [ ] Invited users retain comparably to organic users (counter-metric — incentives often recruit tourists)
- [ ] Virality meaningfully discounts blended CAC, with cycle time short enough to compound within a quarter
- [ ] The viral loop is inherent to product use, or its incentive costs are sustainable at scale

**Premature-scaling symptoms:** paying for incentivized invites that bring low-retention users and poison cohort data; bolting share buttons onto a product nobody's attached to (virality is a multiplier on love, not a substitute); optimizing k while cycle time stays at six weeks.

**Funding/runway:** virality work is cheap relative to paid acquisition — mostly product iterations. The risk isn't burn; it's time lost polishing loops on top of weak stickiness. If k stalls below ~0.2-0.3 after honest attempts, take the answer: your growth will be paid or content-led, and that's a Revenue-stage problem, not a failure.

## Stage 4: Revenue

**The question:** does a dollar in produce more than a dollar out — soon enough to survive the gap?

**What to measure:** revenue per customer (or ARPU/ARPA), conversion to paid, CAC fully loaded, **CAC payback** (months of gross-margin contribution to recover CAC — under 12 months is the standard SaaS heuristic), LTV:CAC (>3 as the health line), gross margin, and churn's effect on revenue (net vs gross). The mindset shift: before this stage you optimized for learning and love; now you optimize a machine — money goes in via acquisition, comes out via margin, and the ratio plus the cycle speed is the whole game.

**Exit criteria:**

- [ ] Unit economics positive at realistic volume assumptions, not best-case ones
- [ ] CAC payback inside your runway tolerance (an 18-month payback with 12 months of cash is a death sentence in slow motion)
- [ ] Pricing has been tested — at least one deliberate experiment, not a launch-day guess carried forever
- [ ] Revenue concentration is survivable (no single customer or channel whose loss ends the company)
- [ ] Margins hold after support, infrastructure, and discounting are honestly allocated

**Premature-scaling symptoms:** scaling ad spend while payback exceeds runway; discounting to manufacture growth that evaporates at renewal; hiring a sales team before founders have repeatedly closed deals themselves; reporting GMV or bookings growth while contribution margin stays negative and unexamined.

**Funding/runway:** the stage where "default alive" becomes computable — model whether current growth and margins reach profitability before zero cash. Raise to *accelerate working economics*, not to discover them. Investors at this stage buy your unit economics plus a credible multiplication plan; a raise that papers over negative unit economics just buys a bigger crater.

## Stage 5: Scale

**The question:** can the machine grow through new channels, partners, and markets without breaking what made it work?

**What to measure:** channel-level economics (CAC, payback, and churn *per channel* — blended numbers hide dying channels inside growing ones), partner- and platform-sourced revenue, market share within the segment, expansion revenue, and operational health: support load per customer, uptime, margin at volume, hiring velocity vs quality. Analytics itself changes shape — from one company-wide OMTM to a metrics hierarchy where each team owns a number that ladders into the top-line goal, with reporting discipline (definition docs, owners, cadences) keeping the numbers trustworthy as headcount grows.

**Exit criteria** (Scale doesn't exit upward — these confirm you belong here):

- [ ] At least two acquisition channels with independently healthy economics
- [ ] Growth doesn't degrade the core: retention and NPS-style signals hold as volume rises
- [ ] Operations scale sub-linearly — support tickets and infra cost grow slower than customers
- [ ] New-market entries are deliberate experiments with their own lines in the sand

**Premature-scaling symptoms — and the inverse failure:** classic premature scaling is arriving here early (the symptoms listed in every prior stage). The inverse failure is real too: a company that has passed every gate but keeps tinkering with onboarding instead of opening channels is hiding from execution risk. Passing the Revenue gate creates an obligation to scale.

**Funding/runway:** growth rounds belong here — the money multiplies proven loops. Diligence will probe exactly what this framework tracks: cohort retention, channel-level CAC/payback, net churn. A company managed by these stages walks into diligence with the data room already true.

## Stage, Funding, and Runway

| Stage | Sane funding posture | What the money buys | Red flag |
|-------|---------------------|---------------------|----------|
| Empathy | Pre-seed / none | Interviews, prototypes, smoke tests | Big raise pre-validation → payroll on guesses |
| Stickiness | Seed | Product iterations toward flat retention curves | Growth round arrives, growth pressure starts the burn |
| Virality | Seed / bridge | Loop experiments, instrumentation | Buying incentivized invites to fake organic growth |
| Revenue | Seed extension / Series A | Pricing tests, channel tests, payback proof | Scaling spend while payback > runway |
| Scale | Series A/B+ | Channel expansion, team, new markets | Raising to hide deteriorating cohort economics |

The general law: **raise on a passed gate, spend on the next one.** Each stage's evidence is the next round's pitch, and runway should cover 2-3 full iteration cycles of the current stage's loop — one cycle of cash means one roll of the dice.

## Diagnosing Your Stage

Walk the gates bottom-up; the first one you cannot evidence is your stage, regardless of what the org chart or the fundraising deck says.

1. Can you show 15+ interviews proving a painful, paid-for problem? No → **Empathy.**
2. Do cohort retention curves flatten at a viable floor? No → **Stickiness.**
3. Is there revenue with measured CAC, payback, and margin? No → **Revenue** (visit Virality on the way only if users plausibly bring users; many fine businesses skip it).
4. All of the above at volume, with channel economics holding? → **Scale.**

Common misdiagnoses: *"We have revenue, so we're at Revenue"* — revenue with collapsing retention means you're at Stickiness with a billing system; *"Growth stalled at Scale"* — usually a Stickiness regression in a new segment or channel, so cohort the new population separately and re-walk the gates for it; *"We're raising a growth round, so we're at Scale"* — funding stage and evidence stage are independent variables, and the gap between them is exactly the danger zone this framework exists to close.
