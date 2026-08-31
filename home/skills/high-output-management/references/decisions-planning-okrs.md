# Decisions, Planning, and OKRs

## Table of Contents

- [The Ideal Decision Process](#the-ideal-decision-process)
- [The Decision Brief: Six Questions](#the-decision-brief-six-questions)
- [The Lowest Competent Level](#the-lowest-competent-level)
- [Countering Peer-Group Syndrome](#countering-peer-group-syndrome)
- [The Three-Step Planning Process](#the-three-step-planning-process)
- [Writing OKRs Grove-Style](#writing-okrs-grove-style)
- [A Worked OKR Cascade](#a-worked-okr-cascade)
- [Pitfalls](#pitfalls)

## The Ideal Decision Process

Grove's model has three stages, in strict order, with no skipping:

**1. Free discussion.** Every relevant view and fact gets on the table, including — especially — dissent. "Free" is literal: people argue the merits regardless of rank, half-formed worries are admissible, and the senior person's job is to *draw out* disagreement, not to win early. Two disciplines make it real: senior people speak last (the moment the boss leans, the discussion is over whether anyone admits it), and dissent is framed as an obligation, not a courtesy — staying silent in the discussion and critical in the hallway is the one unforgivable move.

**2. Clear decision.** Discussion converges or time runs out; either way, the named decision-maker states the decision crisply, in writing, with the reasoning. Grove's observation: the more contentious the issue, the *more* unambiguous the wording must be, precisely because everyone is motivated to hear their preferred version. Vague decisions are the most expensive output a meeting can produce — everyone leaves to execute a different one.

**3. Full support.** Everyone commits to the decision's success — *support*, not pretended agreement. "Disagree and commit" is honorable on both sides: the dissenter argued fully and now executes fully; the organization in turn owes them that the disagreement was genuinely heard. Relitigating in side channels is sabotage; reopening *openly* because material new facts arrived is management. The difference is the venue and the honesty.

The three stages also define the failure modes: discussion without decision (the circling committee), decision without discussion (rank ruling on partial knowledge), and decision without support (the quiet veto in execution).

## The Decision Brief: Six Questions

Grove insisted a decision be framed *before* the meeting that makes it. Answer six questions in writing and attach them to the invite:

```
DECISION BRIEF

1. What decision is needed?
   One sentence, phrased as a question with identifiable options.
2. By when?
   The real deadline and what it's anchored to (contract, launch, hiring window).
3. Who decides?
   One name. Not a committee.
4. Who must be consulted before the decision?
   The people whose knowledge or stake earns them input — with a date for it.
5. Who ratifies or can veto?
   Usually the decider's manager; ratification checks blast radius, not taste.
6. Who must be informed after?
   Everyone whose work changes because of the outcome.
```

**Worked example:**

```
1. Decision: Which payments provider for EU expansion — extend current
   vendor, or migrate to Adyen?
2. By when: June 30 (contract renewal is July 15; migration lead time 6 weeks).
3. Who decides: Priya (platform PM).
4. Consulted: payments eng lead (integration cost), finance (fees model),
   support lead (dispute tooling) — input by June 20.
5. Ratifies: VP Engineering (commits 2 engineers for a quarter if migrating).
6. Informed: checkout team, data team (settlement pipelines), exec staff.
```

The brief takes fifteen minutes to write and routinely saves weeks: half the time, writing it reveals the meeting is unnecessary (the decider can decide today), mis-staffed (the real consultations haven't happened), or premature (the deadline is invented).

## The Lowest Competent Level

Decisions should be made at the lowest level where someone has both the relevant technical grasp and acceptable judgment about consequences. Two reasons. First, knowledge currency: in fast-moving fields the people closest to the work hold the freshest technical truth; every level of escalation trades current knowledge for older generalizations. Second, speed and ownership: decisions made by the people who must execute them start with built-in commitment.

When no single person has both halves, **compose the decision**: pair the engineer with the freshest technical knowledge and the manager carrying organizational judgment, and have them decide *together* — explicitly, as named co-deciders, not as "input" flowing upward to be overruled. Grove considered this blend of knowledge-power and position-power the everyday business of a well-run company.

What escalates: decisions whose blast radius genuinely exceeds the local view (cross-org resource shifts, irreversible commitments, precedent-setting calls). What does not: decisions escalated because someone senior *would like* to make them. Each unnecessary escalation teaches the team that authority, not knowledge, decides — and the best people start pre-clearing everything, which is how organizations get slow.

## Countering Peer-Group Syndrome

Put six peers in a room with a contested question and watch: everyone hedges, nobody wants to stick out with a strong position that might lose, and the discussion circles — not because nobody knows, but because nobody wants to be *wrong in front of equals*. Grove named it peer-group syndrome, and its root is fear of looking dumb, which silences exactly the people with the most current knowledge.

Counters, in order of power:

- **Peer-plus-one.** Add one person senior to the group, sanctioned in advance to break ties and absorb the risk of the call. Their presence licenses strong positions: someone in the room can bless one.
- **The chairman states the question first.** Circling thrives on ambiguity about what is being decided. Opening with the decision brief's question collapses the fog.
- **Written positions before the meeting.** One paragraph from each participant, circulated with the pre-read. Positions taken in writing before social pressure exists are more honest, and the spread of views is visible immediately.
- **Senior people speak last** — and ask questions before stating views.
- **Assign the counter-case.** Name someone to argue the strongest version of the losing side, decoupling the argument from the arguer's reputation.
- **Reward visible mind-changing.** When someone updates on evidence, the senior person marks it as strength. Once changing your mind is safe, taking a position is too.

## The Three-Step Planning Process

Grove's planning frame, applicable to a yearly org plan or a quarter's team plan:

**Step 1 — Environmental demand: what will be wanted of you?** Not what you want to build — what your environment (customers, adjacent teams who depend on you, the market, the company's direction) will demand of you over the planning horizon, typically the next one to two years. List the demands and their trajectory: growing, flat, fading. The discipline is *outside-in*: a platform team's environment is its internal customers' roadmaps; a product team's is the market and the support queue.

**Step 2 — Present status: what are you producing now?** Current capabilities and trajectory, stated with uncomfortable honesty: what is actually shipping, what is in flight *and will genuinely finish*, what is in flight and will not (say so now, not in month eleven), and where capacity is actually going (run the leverage audit's numbers — firefighting and maintenance load included).

**Step 3 — Close the gap.** The difference between step 1 and step 2 is the gap, and the plan is the set of *actions taken now* — projects started, projects killed, hires opened, skills built — to close it. Two Grove rules govern this step:

- **The output of planning is decisions and actions, not documents.** A planning process that produces a deck and no changed behavior produced nothing. The test of a finished plan: what did we *start*, *stop*, and *commit to* this week because of it?
- **Today's gap reflects yesterday's planning failure.** If you are firefighting now, the fire was set by what last year's plan missed. Therefore plan for the *next* gap: today's actions affect output one to two years out. A plan addressed to this week's smoke is reaction wearing planning's clothes.

**Worked sketch:** a platform team's environment scan shows three product teams shipping mobile features next year (demand: mobile-ready APIs, rising) and the company entering the EU (demand: data residency, new and hard). Present status: the API gateway is web-centric; one engineer understands the data layer; 40% of capacity goes to toil from a legacy queue system. Gap-closing actions decided now: kill the legacy queue this quarter (frees the 40%), open one hire with data-residency experience, start the gateway redesign in Q3 — and explicitly *not* pursue the internal analytics tool two teams asked for, with the refusal communicated and dated. That last item matters: a plan that declines nothing has decided nothing.

## Writing OKRs Grove-Style

Grove's management by objectives — which John Doerr carried from Intel to Google as OKRs — answers exactly two questions:

1. **Where do I want to go?** The *objective*: directional, motivating, few in number.
2. **How will I pace myself to see if I am getting there?** The *key results*: measurable milestones, stated so you can answer "did I hit it?" with yes or no, **without argument**.

Grove's rules of construction:

- **Few objectives.** Two or three per level per cycle... and that is not a typo. Each objective you add steals attention from the others; an OKR set with seven objectives is a to-do list with ambitions.
- **Key results are verifiable, dated milestones**, not activities. "Engage with the migration project" is not a key result; "legacy queue serving 0% of production traffic by Nov 15" is.
- **Short cadence.** Quarterly objectives with a monthly look — the system exists to provide *feedback during the race*, not a grade after it.
- **Cascaded, not dictated.** One level's key results supply the next level's candidate objectives — but each team *writes its own*, and a healthy share of objectives flow bottom-up from the people closest to the work. Alignment comes from visibility and negotiation, not transcription.
- **A stretch instrument, not a contract.** Missing a genuinely ambitious key result while performing well is a fine outcome; hitting 100% of everything means the bar was set for safety. The review of a person weighs far more than their OKR scorecard — which is why OKRs must never be wired mechanically to compensation.

## A Worked OKR Cascade

**Company (quarter):**
- **Objective:** Make checkout the fastest in the mid-market segment.
  - KR1: p95 checkout latency under 800ms (from 2.1s).
  - KR2: Checkout conversion +2 points.
  - KR3: Zero sev-1 incidents in the checkout path this quarter.

**Platform team** (adopts KR1 as its objective — the cascade joint):
- **Objective:** Cut checkout p95 below 800ms.
  - KR1: Payment-provider calls parallelized; sequential wait eliminated by Aug 15.
  - KR2: Edge-cached session auth live in EU and US regions by Sep 1.
  - KR3: Latency budget dashboard with per-service attribution adopted by all three checkout services by Jul 31.

**Individual engineer** (adopts team KR1 as her objective):
- **Objective:** Eliminate sequential payment-call latency.
  - KR1: Parallel orchestration design ratified in RFC review by Jul 10.
  - KR2: Shipped behind a flag, 10% traffic, error rate within 0.1% of baseline by Aug 1.
  - KR3: 100% rollout with p95 contribution under 300ms by Aug 15.

Each level is written by its owner, each key result is a dated yes/no, and reading upward, any engineer can trace why her work matters to the company's quarter — Grove's definition of the system working.

## Pitfalls

| Pitfall | What it looks like | Correction |
|---------|--------------------|------------|
| OKRs wired to compensation | Objectives sandbagged to safely-hittable; stretch vanishes | Comp reviews weigh whole performance; OKR scores are one input at most, never a formula |
| 100% attainment celebrated | The bar was set where it couldn't be missed | Treat ~70-80% on genuine stretch as healthy; investigate perfect quarters like misses |
| Objective inflation | Six-plus objectives per team | Cap at three; the cut list is the strategy |
| Activity key results | "Work on", "support", "continue" | Rewrite as dated, verifiable outcomes |
| Cascade as dictation | Teams transcribe their slice from above | Each level writes its own; expect bottom-up objectives too |
| Set-and-forget | OKRs written in week 1, reread in week 13 | Monthly check against the stagger chart; re-forecast, don't re-write history |
| Decision relitigated in hallways | "Supported" decision quietly starved in execution | Name it: reopen openly with new facts, or commit — there is no third venue |
| Planning produces a binder | Beautiful deck, unchanged behavior | End planning with started/stopped/committed actions, owners, and dates |
