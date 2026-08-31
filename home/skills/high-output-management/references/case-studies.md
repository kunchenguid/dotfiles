# Case Studies: High Output Management in Practice

## Table of Contents

- [Case Study 1: The Manager Drowning in Meetings](#case-study-1-the-manager-drowning-in-meetings)
- [Case Study 2: Velocity Up, Quality Down](#case-study-2-velocity-up-quality-down)
- [Case Study 3: The Botched Performance Review](#case-study-3-the-botched-performance-review)
- [Key Takeaways](#key-takeaways)

## Case Study 1: The Manager Drowning in Meetings

### Context

Dana, a strong backend engineer at a 120-person fintech, was promoted to engineering manager of a seven-person team. Eight months in, she was working 55-hour weeks: 34 hours of meetings, the rest fragmented into slivers she spent reviewing PRs at night "to stay technical." Her team's delivery had slowed, two engineers were quietly job-hunting, and her own manager labeled the team "a black box."

### The Problems

**No process meetings, all ad hoc.** Dana held no regular 1:1s ("no time") and no staff meeting. Information reached her through interruptions — 40+ Slack pings a day — and through emergency meetings that existed because problems were caught late. The absence of process meetings was *creating* the ad hoc ones.

**Doing instead of managing.** A week log showed 14 hours of IC work: PR reviews she grabbed first, two production fixes she did herself because "it's faster," and a vendor integration she hadn't handed off. Meanwhile, delegation-shaped work — a design doc her senior engineer could own, interview loops, the on-call rotation redesign — sat with her.

**Negative leverage, invisible.** Three decisions (a schema change, a library upgrade, a hire) had been waiting on her for over two weeks, blocking four people. Her habit of "jumping in to help" on tasks her senior engineers owned was reread by them as distrust.

### The Intervention

**Week 1: Log and classify.** Dana logged five days at 30-minute granularity, then classified each block (information gathering / giving, decision-making, nudging, role model, *doing*) and scored leverage. Results: 11% high-leverage, 31% doing, 12% negative leverage (stalled decisions, meddling, unprepared meetings), the rest neutral. The three stalled decisions alone were blocking an estimated 30 engineer-days.

**Week 2: Install the process meetings.** Weekly 60-minute 1:1s with all seven reports (everyone was effectively new to *her*, and two were new to their tasks), each with a subordinate-owned agenda template and a hold list; one weekly 75-minute staff meeting with a metrics minute, a round, and two debated topics. She cleared the three stalled decisions in the first staff meeting using the six-question brief — two she delegated outright with a named decider.

**Weeks 2-3: Redesign the calendar as a production system.** Fixed events first (1:1s Tue/Wed mornings, staff meeting Monday after lunch); PR review batched to one 4pm window with a rule that she reviews only designs and risky changes, not routine PRs; two maker blocks; office hours 2-3pm daily replacing always-on Slack; 15% left unscheduled. Standing meetings she merely attended got the cost test — she exited four of them, sending a written update instead.

**Weeks 3-8: Delegate with TRM-based monitoring.** The vendor integration went to her senior engineer (high TRM: monitoring = rollout plan review only). The on-call redesign went to a mid-level engineer (medium TRM: weekly check on the plan plus spot checks). She wrote down the monitoring plan in each handoff conversation, and announced — publicly — that she would stop reviewing routine PRs.

### Results After 8 Weeks

| Metric | Before | After |
|--------|--------|-------|
| Meeting hours/week (Dana) | 34 | 19 (9 process, 10 other) |
| Ad hoc "urgent" meetings/week | 6-8 | 1-2 |
| Slack interruptions/day | 40+ | ~12 (office hours + hold lists) |
| Decisions pending >1 week | 3 | 0 |
| Dana's IC "doing" hours | 14 | 4 (design reviews only) |
| Team features shipped/sprint | 2-3 | 4-5 |
| Hours/week (Dana) | 55 | 44 |

The two job-hunting engineers stayed; both later said the 1:1s were the reason — problems they had assumed she didn't care about turned out to be hold-list items she now acted on.

### Lessons Learned

1. **The absence of process meetings creates the meeting overload.** The ad hoc meetings were the symptom; installing 1:1s and a staff meeting removed their cause.
2. **The log doesn't lie.** Dana guessed she spent "a few hours" on IC work; it was 14. Leverage cannot be improved before it is measured.
3. **Stalled decisions are the most expensive line item.** Twelve percent of her week was negative leverage, and most of its cost landed on other people's calendars.
4. **Delegation needed a published monitoring plan** — once monitoring was announced as task-level QA rather than improvised check-ins, her seniors stopped reading it as distrust.

## Case Study 2: Velocity Up, Quality Down

### Context

A nine-person product team at a B2B SaaS company adopted velocity (story points per sprint) as its headline metric after a slow quarter. Leadership praised rising numbers in all-hands. Two quarters later velocity was up 40% — and the team was miserable: incidents up, on-call brutal, and a key customer threatening to churn over reliability.

### The Problems

**A single unpaired indicator.** Velocity was quantity with no quality counterpart. Points rose exactly the way unpaired numbers always rise: tests skipped, migrations deferred, reviews rubber-stamped, stories inflated. Nobody was cheating consciously; the team was doing what management measured.

**The damage was visible only in unmeasured places.** Change-failure rate had doubled and sev-2 incidents went from two to five per month — but neither was on the dashboard, so velocity reviews stayed celebratory while on-call quietly burned out.

**The limiting step was being flooded, not fixed.** Code review was the constraint (median 31 hours to first review). Pushing more stories into the sprint didn't raise output; it raised WIP, pressure to rubber-stamp, and escapes.

**Forecasts had become theater.** Sprint commitments were set to impress and missed by 20-30%, then quietly re-explained. No record of forecast vs actual existed.

### The Intervention

**Step 1: Find the limiting step.** The team mapped its flow (spec → build → review → QA → deploy) and measured queue times for the last 30 stories. Review queues dominated: work waited 31 hours median, with WIP piling in front. Responses: reviewer hours protected before new work starts, a WIP limit upstream of review, linters and CI taking mechanical findings off reviewers, and risky-change review batched into a daily window.

**Step 2: Build the paired dashboard.** Four indicators, shown only together: features shipped per sprint (quantity) with change-failure rate (quality pair); time-to-first-review (quantity) with defect escape rate per 100 merges (quality pair). Two leading indicators alongside: review queue age and on-call pages per week, each with a pre-committed action threshold.

**Step 3: Stagger-chart the forecasts.** Each sprint, the team re-forecast the next three sprints' completed scope, keeping every prior forecast visible. The first month exposed a systematic 25% over-forecast — discussed openly, without blame, as a bias to correct.

**Step 4: Monthly operation review.** The lead presented the paired trends to the wider org — reviewing manager briefed to praise honest misses. The first review opened with the lead stating the quality cost of the velocity push before anyone asked.

### Results After Two Quarters

| Metric | Peak "velocity era" | After |
|--------|---------------------|-------|
| Story points/sprint | 58 | 49 |
| Change-failure rate | 14% | 5% |
| Sev-2 incidents/month | 5 | 1-2 |
| Median time-to-first-review | 31 h | 7 h |
| Defect escapes per 100 merges | 9 | 3 |
| Sprint forecast error | -25% (over-forecast) | -6% |
| On-call pages/week | 19 | 6 |

Velocity dropped 15% and nobody minded: features alive and stable in production — the team's actual output — rose, and the churn-threatening customer renewed.

### Lessons Learned

1. **Any indicator pushed hard will be achieved; the only question is what is sacrificed.** The pair makes the sacrifice visible before customers report it.
2. **The limiting step, not effort, sets output.** Flooding a constrained flow with more work converts effort into queues and defects.
3. **Stagger charts turn forecast bias into a measured, fixable quantity** — and honesty about forecasts proved contagious into estimates, reviews, and postmortems.
4. **Operation reviews changed incentives upward**: once leadership saw paired trends, "velocity up" stopped being praiseworthy on its own — the metric's audience, not the team, had been the root incentive problem.

## Case Study 3: The Botched Performance Review

### Context

Marcus, a staff engineer and the acknowledged ace of a data platform team, received a "meets expectations minus" annual review from his manager, Lena. He was blindsided — every prior signal had been positive — and furious. He stopped volunteering in design reviews, and his calendar began showing recruiter calls. Lena's own manager asked her to repair it.

### The Problems

**Total surprise.** Lena had been dissatisfied for months: Marcus's new charter (leading the streaming-platform migration — coordination, mentoring, stakeholder work) was going badly, while he kept retreating to the batch-pipeline work he was brilliant at. She had said nothing in their sporadic 1:1s. The review was the first time he heard any of it — a supervisor's failure, logged in public.

**Blended message.** The written review mixed praise and criticism so thoroughly ("exceptional technical depth, though stakeholders sometimes…") that drafting it had felt safe — and reading it felt incoherent. The rating contradicted the prose. Marcus latched onto the praise, concluded the rating was arbitrary, and assigned it to politics.

**A TRM misread at the root.** Lena had reasoned: staff engineer, ten years' experience, needs no support. But TRM is task-specific. On batch pipelines Marcus's TRM was the highest in the org; on cross-team migration leadership it was *low* — he had never done it. Lena's hands-off style was right for the old task and was abandonment on the new one. He had been coasting on the ace task partly because no one had structured the one he was failing at — the classic ace-who-coasts pattern, mishandled.

**Comp drove the message.** The "minus" existed mostly to justify a budget-constrained comp outcome, inverting the review's purpose: assessment had been reverse-engineered from money rather than performance.

### The Repair

**Step 1: Assess, don't blend — in writing, first.** Lena rewrote the assessment before scheduling any meeting: outcomes only, in two explicitly separated lanes. Batch platform: exceptional, with named results. Migration leadership: not delivering — milestones missed, two partner teams escalating, mentoring not happening — with named instances. Then she chose the three messages that would change next year's output: (1) the migration is now the job and it is going badly; (2) the cause is missing skills for a new kind of task, not effort or talent; (3) here is the structure we'll build, because the goal is for you to lead at the next level.

**Step 2: Own the failure, then deliver straight.** In the repair conversation Lena opened with her own miss: "You learned this in a review instead of in March. That was my failure, and the no-surprises rule starts now." Then the three messages, undiluted — no praise sandwich. Marcus argued; Lena listened fully (the heart-to-heart a review requires), and did not retract the assessment.

**Step 3: TRM-matched structure.** Together they re-scoped the work explicitly: migration leadership treated as a low-TRM task — weekly structured 1:1s on it (stakeholder map, milestone plan, a "what/when/how" level of detail that would have insulted him on pipeline work and was relief here), Lena attending his first partner-team negotiations as observer-coach, and a two-session course Lena taught herself on running cross-team programs. Batch-pipeline work stayed high-TRM: objectives and monitoring only.

**Step 4: No surprises, ever again.** Task-relevant feedback moved to the moment of the event — wins and misses named in the week they happened, logged in the shared 1:1 doc. A six-month interim review was scheduled in writing, with the explicit promise that nothing in it would be new.

### Results

| Signal | At the botched review | Six months later |
|--------|----------------------|------------------|
| Migration milestones | 2 of 5 hit | 5 of 5 hit |
| Partner-team escalations | 2 open | 0 |
| Marcus's 1:1 cadence on migration work | Sporadic | Weekly, his agenda |
| Engineers Marcus is mentoring | 0 | 2 |
| Interim review surprises | — | None, by design |
| Retention | Recruiter calls | Took the senior-staff track; stayed |

The interim review rated the migration work "exceeds" — and contained, verbatim, sentences Marcus had already heard in 1:1s. He later told Lena the original review was the most useful bad day of his career, "but only because of what came after it."

### Lessons Learned

1. **A surprise in a review is always the supervisor's failure.** The review is where accumulated, already-delivered feedback is consolidated — never where it debuts.
2. **Assess, don't blend.** Write the full assessment first, then choose the few messages that change next year's output. Blending to make delivery comfortable makes the message incoherent.
3. **TRM is task-specific, and promotions reset it.** The org's best engineer was a beginner at the new task; structured management there was coaching, not condescension.
4. **Your ace deserves the most review effort, not the least.** "Keep it up" robs the top performer of their next level — and the coasting ace is usually a structure problem before it is an attitude problem.

## Key Takeaways

**1. Output is the only judge.** Every intervention above was scored the same way: did the organization's output rise? Meetings, indicators, reviews, and OKRs are machinery for that, not deliverables in themselves.

**2. Measure before moralizing.** Dana's week log, the team's queue times, and Lena's written assessment all replaced a story ("I'm just busy", "we're faster", "he's difficult") with data — and the data redirected the fix every time.

**3. Pair every number and forecast in the open.** Unpaired indicators manufactured the velocity crisis; stagger charts and paired dashboards cured it. Honesty is a system property before it is a virtue.

**4. Style follows task-relevant maturity.** The same person needs structure on one task and autonomy on another, simultaneously. Most "people problems" in these cases were style-to-TRM mismatches wearing personality costumes.

**5. Process meetings are where problems get caught small.** 1:1s with hold lists, staff meetings with debated topics, and operation reviews with honest trends starved the emergency meetings and the year-end detonations alike.
