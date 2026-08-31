# Good Metrics vs Vanity Metrics

## Table of Contents

- [The Four Tests of a Good Metric](#the-four-tests-of-a-good-metric)
- [The Vanity Rewrite Table](#the-vanity-rewrite-table)
- [The Four Lens Pairs](#the-four-lens-pairs)
- [Cohort Analysis: Building and Reading a Retention Table](#cohort-analysis-building-and-reading-a-retention-table)
- [Segmentation Discipline](#segmentation-discipline)
- [From Correlation to Causation: The Experiment Loop](#from-correlation-to-causation-the-experiment-loop)
- [The Metric Definition Doc](#the-metric-definition-doc)

## The Four Tests of a Good Metric

Apply these four tests to every number on your dashboard. Archive anything that fails two or more. A metric that fails the fourth test fails, period.

**1. Comparative.** A good metric lets you compare — to last week, to another cohort, to a competitor's benchmark, to your line in the sand. "Conversion is up 0.4 points week-over-week" is a sentence you can act on; "we have 3,000 signups" is not, because there is nothing to compare it to. In practice: attach a comparison frame to every metric before it goes on a dashboard. If you can't name the frame (previous period, other cohort, other segment, target), the metric is decoration.

**2. Understandable.** If people can't remember the metric and argue about it at lunch, it won't change the culture. A "blended weighted engagement index v3" might be statistically sophisticated, but nobody will fight for it. Test: ask three people on the team to define the metric without looking it up. If you get three definitions, either simplify the metric or write a definition doc (see the template below) and socialize it until the definitions converge.

**3. A ratio or rate.** Ratios and rates are the analyst's power tool for three reasons. They are inherently comparative: a daily conversion rate compared to the monthly average shows movement immediately. They are operable: you drive a car by speed (distance per time), not by total miles driven. And they expose tensions: LTV:CAC compresses "are customers worth what they cost?" into one number; sales-per-rep against refunds-per-rep shows whether you're selling well or just selling hard. Convert totals to rates as a habit: signups → signup-to-active conversion; revenue → revenue per customer; content → posts per active creator.

**4. Behavior-changing.** The master test: *what will we do differently based on this number?* If you cannot answer, stop measuring it. The strongest form is a pre-registered decision rule: "If day-7 retention is under 20% we rework onboarding; if it's over 30% we start the referral experiment." A metric attached to a decision is an instrument; a metric without one is a souvenir.

**Quick audit checklist for any metric:**

- [ ] Named comparison frame (period, cohort, segment, or target)
- [ ] One-sentence definition the whole team repeats identically
- [ ] Expressed as a ratio or rate, not a running total
- [ ] An "if it goes up/down, we will..." decision attached
- [ ] Cohorted where time-based, segmented where mixed populations exist
- [ ] Counter-metric identified if anyone is incentivized to move it

## The Vanity Rewrite Table

Vanity metrics share a signature: they rise with time and spend, regardless of whether the business is improving. Rewrite each one into its actionable counterpart instead of deleting it — the underlying data is usually fine; the framing is the problem.

| Vanity metric | Why it flatters | Actionable counterpart |
|---------------|-----------------|------------------------|
| Hits / page views | Counts loads, not people or value | Conversion or goal completion per visit |
| Visits | Can be one person refreshing | Return visitor rate; visits per active user |
| Unique visitors | Says nothing about what they did | Visitor → signup → active funnel rates |
| Total signups | Cumulative; includes the dead | % of signups active in last 7/30 days |
| Total registered users | Only ever goes up | Active users (DAU/WAU/MAU) and their trend |
| Downloads | Installation isn't usage | Launch rate; day-1/7/30 retention |
| Followers / likes | Audience, not behavior | Click-through and conversion from social |
| Emails collected | A list isn't demand | Open → click → purchase rate of the list |
| Time on site | Could be engagement or confusion | Engaged time on key pages; task completion rate |
| Cumulative revenue | Hides slowing growth | MRR growth rate; revenue per customer per cohort |

The rewrite pattern is consistent: **totals become rates, audiences become behaviors, collection becomes usage.** When an investor or executive asks for the vanity number, give it — followed immediately by the ratio that says whether it matters.

## The Four Lens Pairs

Good analytics alternates between complementary lenses. Knowing which lens you're using prevents category errors like running a survey to get a conversion rate or A/B testing your way to a vision.

**Qualitative vs quantitative.** Qualitative input (interviews, support conversations, watching sessions) is unstructured, anecdotal, and revealing — it tells you *why*. Quantitative data tells you *how much* and *how many*. Early on (Empathy stage), qualitative dominates because you have no volume; later, every quantitative anomaly should trigger a qualitative investigation. Rule of thumb: numbers tell you where to look; conversations tell you what you're looking at.

**Exploratory vs reporting.** Reporting metrics keep the lights on: they're the known numbers you track on a cadence. Exploratory analysis digs through data for unexpected patterns — the "unknown unknowns" where unfair advantages hide. The classic example from the book: Circle of Friends, a general social network, explored its data and found that mothers had wildly outsized engagement — message lengths, attachment rates, return visits. The company pivoted to Circle of Moms and found traction. Schedule exploratory time deliberately; dashboards never volunteer surprises.

**Leading vs lagging.** A lagging metric (churn, quarterly revenue) reports history; a leading metric (complaint volume, day-3 trial activity, NPS-style intent) predicts it. Lagging metrics are easier to trust and useless to steer by. To find leading indicators: take a lagging outcome (churned vs retained at day 90), look backward at what each group did in their first week, and find the early behaviors that separate them — then validate with an experiment, because separation alone is just correlation.

**Correlated vs causal.** Ice cream sales correlate with drownings; summer causes both. Correlations are valuable — they tell you where to dig — but acting on them as if they were causes wastes whole quarters. Causality requires changing one variable for a randomized group while holding everything else steady. Correlation is good; causality is a superpower.

## Cohort Analysis: Building and Reading a Retention Table

Blended averages lie. If January's users retain terribly and April's retain well, the monthly active number can look flat while the product is actually improving fast. Cohorts fix this by comparing groups at the same age.

**Procedure:**

1. **Pick the cohort key.** Usually signup week or month. Weekly for young products with volume; monthly when volume is thin (cohorts under ~100 users produce noise, not signal).
2. **Define "retained."** Prefer the core value action over mere login — "created a document," "sent a message," "placed an order." Logins measure habit at best, crash loops at worst.
3. **Build the table.** Rows are cohorts, columns are periods since signup (month 0, 1, 2...), cells are the percentage of that cohort performing the action in that period.
4. **Read down the columns.** Same-age comparison: is month-1 retention better for newer cohorts than older ones? If yes, your product changes are working — this is the single clearest signal that the product is improving.
5. **Read across the rows.** Decay shape: where does each cohort lose people, and does the curve flatten? A flattening curve means a durable core audience exists; a curve sliding to zero means a leaky bucket no matter how fast the top of the funnel grows.

**Worked example** (cell = % of cohort performing the core action in that month):

| Signup cohort | M0 | M1 | M2 | M3 | M4 |
|---------------|-----|-----|-----|-----|-----|
| January | 100% | 42% | 31% | 26% | 24% |
| February | 100% | 45% | 33% | 28% | — |
| March | 100% | 51% | 40% | — | — |
| April | 100% | 58% | — | — | — |

Reading it: M1 retention climbs 42% → 58% across cohorts — the onboarding changes shipped in February and March are working. January's curve flattens around 24% — there is a real retained core, and ~24% is your current baseline for "long-term retained." Meanwhile the blended MAU chart for the same period looked flat, because shrinking old cohorts offset improving new ones. This is why cohort tables, not aggregate actives, are the honest view.

**Common cohort mistakes:** cohorts too small to be stable; counting logins instead of value actions; comparing a complete month against a partial one (the current period always looks like a crash); and changing the "retained" definition mid-stream without re-computing history.

## Segmentation Discipline

A segment is any group sharing a characteristic: acquisition channel, plan, device, geography, persona, company size. Segmentation is how you stop averages from lying about populations the way cohorts stop them lying about time.

- **Segment before you celebrate or panic.** A flat aggregate frequently decomposes into one segment soaring and another collapsing. The action implied by "flat" is wrong in both directions.
- **Standard first cuts:** acquisition channel, platform/device, price tier, geography, and use case. Run these five before inventing exotic segments.
- **Hunt 2x differences.** A segment converting 10% better is probably noise or seasonality; a segment retaining 2-3x better is a strategy (double down, reposition, or re-target).
- **Set a minimum segment size** (a few hundred users or events, depending on base rates) before drawing conclusions — small segments generate impressive, meaningless ratios.
- **Watch for Simpson's paradox:** the aggregate trend can point the opposite direction of every individual segment when the mix shifts. If paid traffic (low conversion) grows faster than organic (high conversion), overall conversion can fall while both channels improve.
- **Tie segments to action.** A segment is only worth tracking if you would treat it differently: different onboarding, different pricing, different ad spend, or an explicit decision to ignore it.

## From Correlation to Causation: The Experiment Loop

The loop that turns observed patterns into reliable levers:

1. **Mine.** Find behaviors correlated with the outcome you want. Example: "users who import contacts on day 1 retain 3x better at day 30."
2. **Hypothesize both directions.** Either importing *causes* retention (it creates value), or intent causes both (serious users import *and* retain). Write both down; the second is usually true more often than teams hope.
3. **Design the controlled test.** Randomly assign new users to a variant that drives the behavior (an onboarding step, a prompt, an incentive) and a control that doesn't. Change only this one thing.
4. **Pre-register the call.** Success metric, minimum effect size worth shipping, sample size, and end date — written before launch. Decide now what result kills the idea.
5. **Decide and iterate.** Effect appears → the behavior is (at least partly) causal; productize the nudge and re-measure. No effect → the behavior was a marker of intent; go back to mining, and consider targeting the *value moment* the behavior was standing in for.

In the example: forcing contact imports moved imports from 18% to 64% of new users — and day-30 retention didn't budge. Importing was a proxy for pre-existing intent. The team instead identified the actual value moment (first reply received within 48 hours) and engineered toward that, which did move retention.

**Hygiene rules:** don't peek and stop early when the numbers look good; one experiment tests one variable; expect novelty effects to fade (re-measure after a few weeks); and if the split of users between variants doesn't match what you configured, distrust the entire result.

## The Metric Definition Doc

When two teams compute "churn" differently, every meeting becomes an argument about arithmetic instead of a decision. Write a one-page definition for every metric that appears on a shared dashboard — especially the OMTM and its counter-metric.

```
Metric name:        Week-4 Retention (New Accounts)
Plain-English:      Of accounts created in a given week, the share still
                    performing the core action during week 4 after signup.
Formula:            accounts with ≥1 core action in days 22-28 ÷ accounts
                    created in cohort week
Core action:        "proposal_sent" event (not login)
Source:             events.proposal_sent, accounts.created_at (warehouse,
                    dbt model retention_weekly)
Cohorting:          weekly signup cohorts; exclude internal/test accounts
Segments tracked:   acquisition channel, plan tier, team size
Owner:              Head of Product (reviews weekly, signs off changes)
Counter-metric:     weekly trial signups (must not fall >10% while we
                    optimize retention)
Current baseline:   31% (trailing 6-cohort average)
Line in the sand:   45% by end of Q2; if missed → rebuild onboarding
                    around first-proposal moment and revisit ICP
Review cadence:     Monday metrics email + monthly deep dive
```

Two rules make the doc effective. First, **any change to a formula requires recomputing history** — otherwise trend lines silently mix definitions and become fiction. Second, **the owner owns the definition, not the result** — punishing the owner for the number's direction guarantees creative arithmetic. The doc's job is to make the number boring, stable, and trusted, so the arguments can be about what to do next.
