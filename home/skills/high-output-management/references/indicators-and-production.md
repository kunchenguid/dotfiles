# Indicators and Production Principles for Software Teams

## Table of Contents

- [The Breakfast Factory, Translated](#the-breakfast-factory-translated)
- [Finding the Limiting Step](#finding-the-limiting-step)
- [Inspect at the Lowest-Value Stage](#inspect-at-the-lowest-value-stage)
- [Choosing Team Indicators](#choosing-team-indicators)
- [Pairing Indicators: Three Worked Examples](#pairing-indicators-three-worked-examples)
- [Leading vs Trend Indicators](#leading-vs-trend-indicators)
- [The Stagger Chart](#the-stagger-chart)
- [Running an Operation Review](#running-an-operation-review)
- [Measuring Administrative Work](#measuring-administrative-work)
- [Anti-Gaming Rules](#anti-gaming-rules)

## The Breakfast Factory, Translated

Grove opens the book with a waiter's problem: deliver a three-minute egg, buttered toast, and hot coffee to the table simultaneously, fresh, at acceptable cost. Everything in production is in that sentence — and everything in running a software team is too:

| Breakfast factory | Software team |
|-------------------|---------------|
| The egg (longest, least flexible step) | The limiting step: code review queue, staging environment, the one person who knows the billing system |
| Toast must start before the order is certain | Build to forecast: hiring, capacity, and roadmaps start on predicted demand |
| Candle the eggs before boiling | Inspect specs and designs before the build, not after |
| Batch toast in the toaster's capacity | Batch reviews, interviews, deploys where setup cost dominates |
| The waiter can't watch the kitchen continuously | Black-box the work; cut windows into it with indicators |

The discipline is to draw the team's actual production line — idea → spec → build → review → test → deploy → operate, or ticket → triage → fix → verify → close — and then manage the flow, not the individual heroics inside it.

## Finding the Limiting Step

The limiting step is the stage that is longest, most expensive, or hardest to scale. The whole flow should be built around it, because output equals the limiting step's throughput no matter how fast everything else runs.

**Procedure:**

1. **Draw the stages** of one unit of work from request to "alive in production." Six to eight boxes is the right altitude.
2. **Measure queue time at each boundary** for the last 20-30 units of work — time *waiting* between stages, not time being worked. Git timestamps, ticket histories, and PR metadata usually contain all of it.
3. **The stage with the longest queue in front of it is the limiting step.** Work piles up in front of constraints; that is the whole diagnostic.
4. **Verify with a thought experiment:** if this stage doubled its throughput, would the team's output rise? If yes, it is the constraint. If output would just pile up at the next stage, keep looking.

**Then build around it:**

- **Protect its capacity.** If review is limiting, reviewer hours are scheduled before new feature work, not squeezed after.
- **Stop starting work the constraint cannot absorb.** A WIP limit upstream of the limiting step is the software equivalent of not cracking eggs you cannot boil.
- **Offload it.** Move work off the constraint: linters and CI take mechanical findings off reviewers; templates take routine answers off the senior engineer.
- **Re-find it quarterly.** Constraints move once relieved. Teams that "fixed review" in Q1 are often staging-limited by Q3.

## Inspect at the Lowest-Value Stage

A flaw costs more at every stage it survives. The rule: detect and fix any problem at the lowest-value stage possible.

| Stage caught | Typical cost to fix |
|--------------|---------------------|
| One-page spec review | An hour and a conversation |
| Design/RFC review | A day and a revision |
| PR review | Days — code exists, sunk cost argues back |
| QA / staging | A week — context reload, retest |
| Production incident | Weeks — plus customers, trust, and on-call burnout |

Three kinds of inspection, mapped from the factory:

- **Incoming inspection:** requirements and specs. Is the problem real, the approach sound, the scope bounded? The cheapest hour in engineering is the hour spent killing a bad spec.
- **In-process inspection:** design reviews, PR review, CI. Catch flaws while the material is still cheap to rework.
- **Final inspection:** release checklists, canary deploys, smoke tests. Necessary, but if final inspection is your primary quality mechanism, you have built a factory that ships rotten eggs to the plating station.

Choose between **gate** (work stops until it passes — right for irreversible or high-blast-radius changes: schema migrations, auth, billing) and **monitoring** (work proceeds, samples are checked, drift triggers tightening — right for everything else, because gates everywhere destroy flow). A useful default: gates at incoming and final, monitoring in process — tightened temporarily where escapes have actually occurred, then loosened again. A variable-inspection scheme beats permanent maximum inspection.

## Choosing Team Indicators

Indicators are the windows cut into the black box. Choosing them well:

1. **Four to six, no more.** Beyond that, attention diffuses and nobody steers.
2. **Each measures output or a direct precondition of output** — not effort, not motion.
3. **Each has an owner and a review cadence** (the weekly team review and the monthly operation review below).
4. **Each quantity indicator gets a quality pair** — this is non-negotiable, because people will do what management measures, and an unpaired number is an instruction to game it.
5. **Cheap to collect.** An indicator that takes an afternoon to assemble dies in a month. Pull from systems (git, CI, ticketing, observability), not from human memory.

## Pairing Indicators: Three Worked Examples

**1. Code review throughput vs defect escape rate.**
A platform team measured time-to-first-review (median 26 hours) and made it the headline metric. Within six weeks the median fell to 4 hours — and rubber-stamp approvals rose with it; "LGTM" reviews with zero comments went from 18% to 55%, and bugs found after merge climbed. The fix was the pair: *PRs reviewed per week* and *time-to-first-review* displayed only alongside *defect escape rate* (bugs attributed to merged PRs per 100 merges, found within 30 days). Reviewers could no longer win by waving work through; the pair forced the real goal — fast *and* sound review. Stabilized at 8-hour first response with escapes at half the original rate.

**2. Ticket closes vs reopen rate.**
A support team paid attention (and a spiff) to tickets closed per agent-day. Closes rose 30%; so did "resolved" tickets that customers immediately reopened — agents were closing on first response with a boilerplate answer. Pairing *closes per agent-day* with *reopen rate within 7 days* and *CSAT on closed tickets* exposed the pattern in the first week: the two agents with the highest close counts had the worst reopen rates. Coaching, not punishment, followed — and the indicator pair was published to the team so everyone could see that the game had changed from "close fast" to "close once."

**3. Feature velocity vs incident rate.**
A product team celebrated rising velocity (story points per sprint, up 40% over two quarters). The same period: change-failure rate doubled, two sev-2 incidents per month became five, and on-call escalations rose. Velocity was being purchased with skipped tests and deferred migrations — invisible because nobody graphed the pair. The fix: a four-indicator dashboard — *features shipped per sprint*, *change-failure rate*, *incidents attributed to recent changes*, *p95 cycle time* — reviewed together in the monthly operation review. Velocity dropped 15% the next quarter; incidents fell by two-thirds; net output (features alive and stable in production) rose.

The general law: any indicator pushed hard will be achieved — the only question is what gets sacrificed to achieve it. The pair makes the sacrifice visible before the customer reports it.

## Leading vs Trend Indicators

**Leading indicators** let you act before output falls. Good ones for software teams: review queue age, build flakiness rate, on-call pages per week, backlog age of sev-2 bugs, recruiting pipeline depth, and a simple morale pulse. Each needs a believed threshold — a level at which you have pre-committed to act, otherwise you will explain away the warning ("the linearity index dipped, but surely it'll catch up").

**Trend indicators** show output against two baselines: your own history (deploys this month vs the last six) and your forecast (what you said you would do). Measurement against forecast is what turns an indicator from a mood into a commitment — which is the stagger chart's job.

## The Stagger Chart

A stagger chart re-forecasts the same horizon every period, keeping every previous forecast visible. Forecast the next three sprints' completed scope (or the quarter's ARR, or the month's hiring), and each period add a new row:

| Forecast made | Sprint 10 | Sprint 11 | Sprint 12 | Sprint 13 |
|---------------|-----------|-----------|-----------|-----------|
| In sprint 9 | 24 pts | 26 | 27 | — |
| In sprint 10 | **21 (actual)** | 24 | 26 | 27 |
| In sprint 11 | | **20 (actual)** | 23 | 26 |
| In sprint 12 | | | **22 (actual)** | 24 |

Read **down a column**: sprint 12 was forecast at 27, then 26, then 23, landing at 22. The team systematically over-forecasts by ~20% — visible in one glance, unarguable, and correctable. A team that sandbaggs shows the opposite signature (forecasts rising to meet comfortable actuals). The stagger chart does not punish misses; it makes forecast *bias* a measured, improvable quantity — which is the honest foundation under every commitment the team makes outward.

## Running an Operation Review

The operation review is where indicators meet an audience: managers present their area to people who do not see their work day-to-day — adjacent teams, skip-levels, new hires. Grove's purposes: it teaches, it motivates (people raise their game when their work has an audience), and it lets seniors sanity-check trends juniors might rationalize.

**Cast:** an *organizing manager* (logistics, agenda, timekeeping), a *reviewing manager* (senior; asks questions, sets the tone, never ambushes), 2-4 *presenters* (line managers/leads with their indicators), and the *audience* — whose job is to engage, not spectate.

**Cadence:** monthly for a department, quarterly for an org. Sixty to ninety minutes.

**Agenda template:**

1. (5 min) Reviewing manager: why we are here, what changed since last time.
2. (15 min × 3) Each presenter: their 4-6 indicators as *trends with forecasts* (stagger charts, not snapshots), one problem they are working, one ask of the room.
3. (10 min) Open questions across areas — the cross-pollination is the point.
4. (5 min) Reviewing manager: themes, decisions taken, actions with owners.

**Presenter rules:** trends, not points-in-time; pairs shown together; misses stated before anyone asks; no slide with more than one chart. **Reviewing-manager rules:** ask the second question ("what's underneath that?"), praise honest bad news, and never let the room punish a candid miss — one ambushed presenter converts the whole org's reviews into theater permanently.

## Measuring Administrative Work

Grove insisted administrative and knowledge work be measured like production, because it is production:

| Function | Output indicator | Quality pair |
|----------|------------------|--------------|
| Recruiting | Offers extended per week | Offer-accept rate; 90-day retention of hires |
| Support | Tickets resolved per agent-day | Reopen rate; CSAT |
| Documentation | Docs shipped/updated per month | Search success rate; support tickets on documented topics |
| Finance ops | Invoices processed per day | Error/dispute rate |
| IT/internal tools | Requests fulfilled per week | Repeat-request rate; requester satisfaction |

Same rules as engineering indicators: output not activity, paired, owned, trended against forecast.

## Anti-Gaming Rules

- **Publish the pair or publish nothing.** A quantity indicator released alone is a gaming instruction with a dashboard.
- **Indicators describe the work, not the worker.** Use team-level indicators for steering; individual performance is assessed in reviews with full context, not read off a throughput chart. The moment indicators become surveillance, people optimize the number and hide the truth — and you lose both the output and the warning system.
- **Never convert an indicator directly into compensation.** The instant money attaches, the indicator stops measuring reality (see the OKR pitfalls in [decisions-planning-okrs.md](decisions-planning-okrs.md)).
- **Expect Goodhart drift and rotate emphasis.** Any measure pushed for quarters degrades; re-derive indicators from the current limiting step, not from habit.
- **Let the team see everything you see.** Indicators reviewed in the open steer; indicators reviewed privately breed paranoia and creative accounting.
