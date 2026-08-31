# The One Metric That Matters

## Table of Contents

- [Why One Metric](#why-one-metric)
- [Choosing the OMTM Step by Step](#choosing-the-omtm-step-by-step)
- [The Stage × Model Matrix](#the-stage--model-matrix)
- [Counter-Metric Pairing](#counter-metric-pairing)
- [Drawing the Line in the Sand](#drawing-the-line-in-the-sand)
- [Communicating the OMTM](#communicating-the-omtm)
- [Rotation Triggers](#rotation-triggers)
- [Worked Examples](#worked-examples)

## Why One Metric

The One Metric That Matters is the single number you optimize above all others at your current stage. Four things happen when a team commits to one:

1. **It answers the most important question you have.** A startup is a stack of risky assumptions; the OMTM measures the riskiest one still unproven. Choosing it forces the team to name that risk out loud.
2. **It forces a line in the sand.** One metric invites one target. "Improve engagement" survives forever; "week-4 retention to 45% by June 30" can succeed or fail.
3. **It focuses the entire company.** When everyone knows the number, every project pitch, support policy, and design debate gets evaluated against the same question: does this move it?
4. **It builds a culture of experimentation.** A visible number that must move invites bets, measurements, and honest post-mortems instead of opinion battles.

Two clarifications prevent misuse. *One metric that matters* does not mean *collect only one metric* — you instrument broadly and drill into many numbers; you *watch* one. And the OMTM is temporary by design: it's the metric that matters **now**, and graduating past it is the goal.

## Choosing the OMTM Step by Step

1. **Name your business model.** One of the six archetypes: e-commerce, SaaS, free mobile app, media, user-generated content, two-sided marketplace. Hybrids pick a primary (see business-model-metrics reference).
2. **Name your stage.** Walk the five gates — Empathy, Stickiness, Virality, Revenue, Scale — from the bottom; the first gate you haven't passed is your stage (see five-stages reference).
3. **Read the candidate from the matrix below** and adapt it to your product's actual mechanics: the "core action" in a retention metric must be *your* value moment, not a generic login.
4. **Make it pass the four tests.** Comparative, understandable, a ratio or rate, behavior-changing. Almost always this means a rate over a recent window, cohorted.
5. **Pair a counter-metric** so the OMTM can't be gamed (next section).
6. **Draw the line in the sand** — target, date, miss response — and publish all of it in one place the whole company sees.

If the team cannot agree on step 1 or 2, stop: the disagreement is not about analytics, it's about what business you're in and what could kill it. That conversation is worth more than any dashboard, and it must end in a decision.

## The Stage × Model Matrix

Empathy-stage companies share the same OMTM regardless of model — validated problem signal from interviews (count of interviewees confirming pain, frequency, and willingness to pay). Scale-stage companies converge too — channel-level unit economics and operational health. In between, the model differentiates:

| Model | Stickiness OMTM | Virality OMTM | Revenue OMTM |
|-------|-----------------|---------------|--------------|
| E-commerce | Repeat-purchase rate; cart completion | Shares/referrals per buyer that convert | Revenue per customer; AOV × repurchase |
| SaaS | Trial activation rate; week-4 retention | Invites per account × acceptance rate | MRR growth; net churn; LTV:CAC |
| Free mobile app | D1/D7/D30 retention; DAU/MAU | k-factor; invite cycle time | ARPDAU; % paying |
| Media | Return-visitor rate; engaged time | Shares per article; social referral % | RPM; sell-through of inventory |
| UGC | Voyeur → creator conversion; content per user | Invites/embeds per creator | Premium conversion; ARPU |
| Marketplace | Repeat listing/buy rate per side | Seller- and buyer-referred signups | Net take-rate revenue per transaction |

Use the matrix as a menu, not a mandate. The right cell still needs translating into your product's vocabulary, and occasionally the honest answer sits one cell over — a marketplace whose sellers churn instantly has a stickiness problem even if its dashboard says "virality stage."

## Counter-Metric Pairing

Any metric a team optimizes hard will be hit — sometimes by improving the business, sometimes by quietly damaging it. The counter-metric is the guardrail that catches the second case. Choose it by asking: *how would a cynical team hit the OMTM while hurting the company, and which number would betray them?*

| OMTM | Gaming risk | Counter-metric |
|------|-------------|----------------|
| Signup growth | Buy junk traffic, inflate top of funnel | 30-day retention of new cohorts |
| Activation rate | Force users through hollow checklist steps | Week-4 retention; support tickets per new user |
| Sales velocity | Overselling, discount abuse | Refund/return rate; 90-day churn of new deals |
| Engagement (time in app) | Dark patterns, infinite feeds | Task completion time; session value rating |
| Email-driven revenue | Send more, burn the list | Unsubscribe + spam-complaint rate |
| Marketplace fill rate | Delist anything slow, hide breadth | Listing growth in target categories; dispute rate |
| Cost per acquisition | Chase cheap, low-intent users | LTV of acquired cohorts by channel |

Display the counter-metric next to the OMTM, always — same dashboard, same weekly email. A win that breaches the guardrail is not a win, and the team should hear that from the dashboard before they hear it from customers.

## Drawing the Line in the Sand

A line in the sand converts a metric into a falsifiable bet. It has three parts, all written **before** you start optimizing:

1. **The target.** Derive it from three inputs: your current baseline (measure it first — even if embarrassing), external benchmarks for your model (as starting heuristics), and *need* — the number at which the next stage, the next funding round, or default-alive economics become real. When the three conflict, need wins: a benchmark can't pay your bills.
2. **The date.** Tie it to runway and iteration speed. A useful target is reachable within 2-3 experiment cycles, not one heroic quarter.
3. **The pre-commitment.** What happens if you hit it (advance to the next stage's OMTM; unfreeze the growth budget) and what happens if you miss (iterate with a specific focus, pivot the segment, or kill the initiative). Writing the miss response in advance is the entire point — after the fact, every miss can be rationalized into "almost."

Template:

```
OMTM:               Week-4 retention (new accounts, core action basis)
Today:              31%
Line in the sand:   45% by June 30
If we hit it:       Move OMTM to net MRR churn; unfreeze paid acquisition tests
If we miss it:      Two-week diagnosis sprint; if interviews show wrong ICP,
                    pivot target segment; no new feature work until decided
Counter-metric:     Weekly trial signups must stay within 10% of current
Owner:              CEO (reviewed in Monday metrics email)
```

"Good enough" deserves emphasis. Perfectionists keep optimizing a passed gate; optimists declare victory at any uptick. The pre-committed target defines *enough* so the company knows when to stop polishing one stage and start risking the next.

## Communicating the OMTM

A chosen-but-hidden OMTM changes nothing. Make it environmental:

- **Dashboard design: one big, 4-6 small.** The OMTM renders as a single large number with its trend and the line-in-the-sand target drawn on the chart. Below it, 4-6 supporting metrics in small tiles — the counter-metric always among them, plus the 3-5 drivers the team can directly move. Everything else lives in drill-down reports. If your dashboard tool shows 30 tiles, your dashboard is a filing cabinet, not a scoreboard.
- **The weekly metrics email.** One paragraph in plain language: the OMTM's value, the delta, the experiments that touched it, and the single biggest thing happening next. Written by the owner, readable by a new hire.
- **Experiment review anchored on the OMTM.** Every experiment proposal states its predicted effect on the OMTM (or explicitly claims counter-metric/infrastructure status). Every review starts with what the OMTM did.
- **Pitch hygiene.** Roadmap items, sales promises, and design debates get one standard question: "what does this do to the number?" Not everything must move it — but everything must answer the question.

## Rotation Triggers

The OMTM rotates when the question it answers stops being the riskiest one. Legitimate triggers:

- **You passed the line in the sand and held it** for several consecutive cohorts or weeks — graduation, the happy path. Move to the next stage's metric.
- **You pivoted.** New model or segment means re-deriving model × stage from scratch; yesterday's OMTM is now someone else's metric.
- **The metric saturated.** It's high, stable, and experiments barely move it while a different constraint visibly throttles the business. Rotate toward the constraint.
- **It stopped changing behavior.** If three consecutive reviews produced no decision tied to the number, either re-attach decisions or admit the risk lives elsewhere.

One illegitimate trigger, named explicitly: **the number looks bad and the date is near.** Rotating away from a failing OMTM is goalpost-moving. The pre-commitment exists precisely for this moment — execute the miss response instead.

Expect a healthy early-stage company to rotate every one to three quarters. Faster usually means thrashing; a year on one metric usually means nobody is looking at it anymore.

## Worked Examples

**1. B2B SaaS — CRM for landscaping companies (14-day trial).** Model: SaaS. Stage: stickiness — trials sign up but churn after converting. Mining showed trials that scheduled ≥5 jobs in week 1 converted and retained at 3x the average. An onboarding experiment that drove job-scheduling moved retention, so the behavior is causal enough to bet on. **OMTM:** % of new trials scheduling ≥5 jobs in week 1 (currently 22%). **Counter-metric:** trial-to-paid conversion and 60-day churn (to catch hollow activation). **Line in the sand:** 40% by quarter end; miss → rebuild setup flow around importing existing client lists, the step where most trials stall.

**2. Two-sided marketplace — vintage furniture.** Model: marketplace. Stage: stickiness/liquidity — GMV grows from new listings, but buyers search and leave. **OMTM:** % of new listings that sell within 30 days (currently 14%). **Counter-metrics:** median sale price (to prevent hitting the target by forcing fire-sale pricing) and dispute rate. **Line in the sand:** 35% in the two launch cities by Q3; hit → expand to two more cities with the same playbook; miss → narrow to the three categories with proven demand and delist the rest.

**3. Free mobile app — habit tracker.** Model: free mobile app. Stage: stickiness, despite investor pressure to spend on installs. **OMTM:** D7 retention (currently 12%). **Counter-metric:** notification opt-out rate — the obvious gaming path is spamming reminders. **Line in the sand:** D7 ≥ 25% and DAU/MAU ≥ 20% before any paid acquisition; miss after three onboarding iterations → revisit the core loop (the product, not the marketing, is the problem). The pre-commitment here is mostly a *spending freeze*: it protects the runway from buying users who would leave.

Three different companies, one shape: a single rate, cohorted, with a guardrail, a number, a date, and a decision already made about both outcomes.
