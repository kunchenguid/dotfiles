# Managerial Leverage and the Calendar

## Table of Contents

- [The Output Equation](#the-output-equation)
- [Step 1: Log a Real Week](#step-1-log-a-real-week)
- [Step 2: Classify Every Block](#step-2-classify-every-block)
- [Step 3: Score the Leverage](#step-3-score-the-leverage)
- [The Leverage Catalog](#the-leverage-catalog)
- [The Delegation Protocol](#the-delegation-protocol)
- [Monitoring Depth by Task-Relevant Maturity](#monitoring-depth-by-task-relevant-maturity)
- [Redesigning the Calendar](#redesigning-the-calendar)
- [Managing Interruptions](#managing-interruptions)
- [The Weekly Re-Audit](#the-weekly-re-audit)

## The Output Equation

A manager's output is the output of their organization plus the output of the neighboring organizations under their influence. Nothing on the calendar has value in itself — a meeting, a review, an approval matters only through the output it eventually creates or destroys. Leverage is the exchange rate: output created per unit of managerial time spent on an activity.

Three ways to raise output follow directly:

1. **Speed up** — do the same activities faster (helps a little, caps quickly).
2. **Raise the leverage of existing activities** — better preparation, better timing, bigger audiences for the same hour.
3. **Shift the mix** — replace low- and negative-leverage activities with high-leverage ones. This is where almost all of the gain lives, and it is what the audit below finds.

The audit takes one logged week and roughly ninety minutes of analysis. Most managers who run it discover that 30-50% of their week is spent on activities that either anyone could do, that nobody should do, or that actively subtract output.

## Step 1: Log a Real Week

Log five working days at 30-minute granularity. Rules that keep the data honest:

- **Log as you go, classify later.** Classifying while logging biases what you record.
- **Log what actually happened**, not what the calendar said. The 9:00 "deep work block" that became forty minutes of Slack is logged as Slack.
- **Mark interruptions with a tally**, not a block. Six pings inside one hour is its own finding.
- **Note who else was present** for every meeting — you will need headcount for cost math later.
- **Pick a typical week.** Not launch week, not the week after reorg. If no week is typical, log two.

A spreadsheet with four columns is enough: time, what, who, interrupt count.

## Step 2: Classify Every Block

Grove's insight is that all managerial activities reduce to a small set. Tag each block with one of:

| Type | What it looks like | Notes |
|------|--------------------|-------|
| **Information gathering** | 1:1s, reading reports and dashboards, hallway/Slack conversations, customer calls, reading code or tickets | The base activity — everything else depends on its quality. Verbal sources are fastest but vaguest; written reports discipline the writer more than they inform the reader |
| **Information giving** | Announcements, briefings, documentation, answering questions, setting context in meetings | Includes conveying not just facts but objectives, priorities, and preferred ways of doing things |
| **Decision-making** | Choosing vendors, approving designs, allocating people, setting priorities — or participating in someone else's decision | Split "made the decision" from "sat in a meeting where a decision happened to me" |
| **Nudging** | Suggesting a direction without ordering it: a comment in a design review, a question in a planning doc | Legitimate and distinct from deciding — you nudge many times a day |
| **Being a role model** | Visible behavior: how you run meetings, handle incidents, treat people, write | Values transmit through observed behavior, never through speeches. You are doing this all day whether you intend to or not |

Anything that fits none of these — doing IC work, expediting a ticket, formatting a slide — gets tagged **doing**, and becomes a delegation candidate in Step 3.

## Step 3: Score the Leverage

Now score each block high, neutral, or negative. The test for each:

- **High leverage:** one hour affects many people's output (training, a well-run staff meeting, hiring), affects one person's output for a long time (a prepared review, a career conversation, an early spec read), or affects a large body of work through perfect timing (catching a wrong design before the build starts).
- **Neutral:** necessary, output-preserving, low multiplication — expense approvals, routine syncs, most email.
- **Negative leverage:** the hour subtracted output from others. See the catalog below.

Then compute three numbers: percentage of week in high-leverage work, in "doing", and in negative leverage. Typical first-audit results for a new engineering manager: 15% high, 35% doing, 10% negative, the rest neutral. Target after redesign: 40%+ high, under 10% doing, zero tolerated negative.

## The Leverage Catalog

**Reliably high-leverage activities:**

- **Training you deliver yourself** — Grove's arithmetic: four lectures taking ~12 hours of preparation, delivered to ten people who will work ~20,000 hours in the next year. A 1% improvement buys 200 hours of output for a dozen hours of work.
- **Performance reviews prepared properly** — one written assessment steers a year of one person's output.
- **1:1s** — ninety minutes can raise the quality of a subordinate's work for two weeks or more.
- **Writing once for many readers** — a decision memo, an onboarding doc, a postmortem; the alternative is explaining it eleven times.
- **Early-stage inspection** — an hour on a one-page spec saves a month on a wrong build.
- **Hiring** — few hours have a longer half-life.
- **The timely nudge** — one question in the right design review redirects a quarter of work.

**Negative-leverage activities (each hour subtracts):**

- **Meddling** — supervising in detail a person who has high task-relevant maturity for the task. The expert slows down, stops owning outcomes, and learns to wait for instructions.
- **Waffling** — sitting on a decision others are blocked on. Ten people idling for three days is a costlier purchase than almost anything you could buy with a PO.
- **Mood contagion** — a manager's visible anxiety or gloom propagates; the team spends its energy reading you instead of building.
- **The unprepared meeting** — eight people discovering the agenda live.
- **Being the approval bottleneck** — sign-offs queueing behind your travel schedule.
- **Last-minute review** — "fixing" finished work that should have been inspected at the spec stage; you pay full rework cost and demoralize the author.

## The Delegation Protocol

Delegation is how "doing" hours convert to high-leverage hours — but delegation without monitoring is abdication, and silent re-grabbing is worse. The protocol:

1. **Pick what to delegate: the tasks you know best.** This feels backwards and is not. Monitoring is cheap when you can judge the work at a glance; delegating what you understand least means you cannot supervise it at all. Your famous-for tasks are your best handoffs.
2. **Hand off outcomes, not steps.** State the output expected, the constraints (budget, deadline, interfaces), and the quality bar. Put it in writing — two paragraphs, not a contract.
3. **Agree on the monitoring plan in the handoff conversation.** Checkpoint cadence, what gets sampled, what triggers escalation. Monitoring announced up front is quality assurance; monitoring imposed after a stumble is punishment.
4. **Monitor at the task level, not the person level.** You are sampling work products — plans, PRs, dashboards — the way a factory samples incoming material, not auditing the human.
5. **Vary depth with task-relevant maturity** (table below), and loosen visibly as results come in.
6. **Never take a task back silently.** If it is going wrong, say so, raise monitoring frequency, add training — and if you must repossess it, do it explicitly with reasons. Quiet repossession teaches the team that delegation is a trap.

## Monitoring Depth by Task-Relevant Maturity

| Subordinate's TRM for this task | What you review | Cadence | Style |
|---------------------------------|-----------------|---------|-------|
| **Low** (new to task, regardless of seniority) | The plan before work starts, then work products at each stage | 2-3 times/week, scheduled | Structured: what, when, how; short feedback loops |
| **Medium** (done it with help before) | The plan plus spot-checks of in-progress work | Weekly | Mutual reasoning: what and why; they propose, you probe |
| **High** (done it well repeatedly) | Final outputs and a few agreed indicators | At milestones / monthly | Objectives only; monitor outcomes, intervene on request or on indicator drift |

Re-rate TRM whenever the task changes. The engineer who is high-TRM on service migrations may be low-TRM on their first vendor negotiation — and your monitoring must change with them, in both directions.

## Redesigning the Calendar

Treat the calendar as a production system and apply factory rules to it:

1. **Forecast the limiting steps first.** The high-leverage fixed events — 1:1s, staff meeting, planning, reviews, training you teach — go on the calendar before anything else, like the egg timer everything else offsets from. These are commitments others schedule around; they move only for emergencies.
2. **Batch similar work.** Group PR reviews into one or two daily windows, interviews into two afternoons, email into two or three passes. Every context switch is a setup cost; batching amortizes it.
3. **Create maker blocks and defend them.** Two or three half-days of focus time, treated like meetings with yourself. Your reports' maker time deserves the same defense — audit how many of their interruptions are you.
4. **Leave slack.** Keep roughly 15% of the week unscheduled. A manager at 100% utilization is a server at 100% utilization: every arrival queues, and latency explodes for everyone downstream.
5. **Say no at the source.** Capacity planning means refusing or renegotiating work beyond capacity at the moment it is offered — "yes, after the planning cycle" or "no, and here is who can" — rather than accepting it into a queue where it will silently rot.
6. **Use the cost test on every standing meeting you own.** Attendees × hours × loaded hourly rate. An eight-person hour costs about a thousand dollars; if you would not sign a purchase order for that amount for the value produced, restructure or kill it.

A redesigned week for an EM with six reports might look like: Monday — maker block AM, staff meeting after lunch, batched reviews 4pm; Tuesday/Wednesday — 1:1s in morning blocks, office hours 2-3pm; Thursday — interviews batched PM; Friday — planning/indicator review, maker block, slack.

## Managing Interruptions

Interruptions are demand arriving at random for a resource (you) that performs best in batches. Apply production thinking rather than heroics:

- **Count them first.** The week log's tally marks show who interrupts, about what, and when. Most managers find 60%+ of interrupts come from a handful of question types.
- **Export the answers.** Recurring questions become a FAQ, a runbook, a dashboard, or a trained delegate. Answering the same question eleven times is a documentation failure, not diligence. Each written answer is a small machine that works while you sleep.
- **Batch the rest with office hours.** Two predictable daily slots convert random arrivals into a queue with a known service time. Pair with the 1:1 hold list: "great question — put it on the hold list for Tuesday" is a complete, polite sentence.
- **Publish an escalation ladder.** Define what justifies an immediate page (production down, customer-visible failure, a person in trouble) versus the next office hours versus the next 1:1. People interrupt randomly when they cannot predict what you consider urgent.
- **Do not go dark.** The goal is batching, not unavailability — an unreachable manager simply trains people to make uninformed decisions in private.

## The Weekly Re-Audit

The full audit is occasional; this five-minute version runs every Friday:

1. What fraction of my hours this week were high-leverage? (Target: rising toward 40%.)
2. What did I do that someone on the team could now do — and what training or delegation would make that true next month?
3. Where did I create negative leverage — a delayed decision, a meddled task, a mood I broadcast — and what is the repair?
4. Which interrupt should become a document, a delegate, or a hold-list item?
5. Is next week's calendar forecast — 1:1s, maker blocks, batches — already in place, or will the week happen to me again?

Write the answers down; four weeks of them is its own stagger chart of whether your management is trending toward output.
