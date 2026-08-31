# Agile Integration for Lean UX

Lean UX was designed to work inside Agile development teams, not alongside them. The central mechanism is dual-track agile, where a discovery track (learning what to build) runs in parallel with a delivery track (building it). This reference covers the practical mechanics of making UX and Agile work together.

## Dual-Track Agile

Dual-track agile separates the work of figuring out what to build from the work of building it. Both tracks run continuously and feed each other.

### Track Definitions

| Track | Purpose | Activities | Output |
|-------|---------|-----------|--------|
| **Discovery** | Learn what to build | Hypothesis writing, experiments, user research, collaborative design, prototype testing | Validated hypotheses, tested prototypes, experiment results |
| **Delivery** | Build what has been validated | Sprint planning, development, QA, deployment, monitoring | Shippable software, production features |

### How the Tracks Connect

```
DISCOVERY TRACK (Sprint N)          DELIVERY TRACK (Sprint N+1)
  Hypothesis → Experiment              Validated design → Development
  → Prototype → User test              → Code → QA → Deploy
  → Validated design ─────────────────→ (enters delivery backlog)
  → Invalidated design ──→ (discard or re-hypothesize)
```

**Key rule:** Only validated designs enter the delivery backlog. Invalidated designs are discarded, pivoted, or re-tested. The delivery team never builds something the discovery team has not tested.

### Discovery Track Activities

| Week | Activity | Participants | Output |
|------|----------|-------------|--------|
| Monday | Review last experiment results; write new hypotheses | PM, Designer, Tech Lead | Updated hypothesis log |
| Tuesday | Collaborative design session (Design Studio or sketching) | Full team | Sketches, direction to prototype |
| Wednesday | Build prototype (paper or clickable) | Designer + Developer pair | Testable artifact |
| Thursday | Run user tests (3-5 sessions) | Designer (facilitator), Team (observers) | Raw findings |
| Friday | Synthesize results; update backlog; plan next experiment | PM, Designer, Tech Lead | Validated/invalidated hypotheses |

### Delivery Track Activities

The delivery track follows standard Agile/Scrum ceremonies but with Lean UX modifications:

| Ceremony | Lean UX Modification |
|----------|---------------------|
| **Sprint Planning** | Each story includes its hypothesis and success metric. Team reviews experiment evidence before committing. |
| **Daily Standup** | Include discovery track updates alongside delivery updates. "Yesterday I tested the prototype with 3 users; today I'm synthesizing results." |
| **Sprint Review/Demo** | Demo includes experiment results and learnings, not just shipped features. "We shipped feature X AND we learned Y from our experiment." |
| **Retrospective** | Review learning velocity alongside delivery velocity. "How many hypotheses did we validate/invalidate? Are we learning fast enough?" |

## Fitting UX Work into Sprints

The most common complaint about UX in Agile is that design work does not fit into a sprint. Lean UX solves this with three techniques: staggered sprints, T-shaped participation, and hypothesis-driven stories.

### Staggered Sprints

Discovery runs one sprint ahead of delivery. While the delivery team builds features validated in Sprint N, the discovery team validates designs for Sprint N+1.

```
Sprint 1 Discovery: Validate design for Feature A
Sprint 1 Delivery:  (Build Feature Z from previous discovery)

Sprint 2 Discovery: Validate design for Feature B
Sprint 2 Delivery:  Build Feature A (validated in Sprint 1 Discovery)

Sprint 3 Discovery: Validate design for Feature C
Sprint 3 Delivery:  Build Feature B (validated in Sprint 2 Discovery)
```

**Benefits:**
- Design is never a bottleneck; validated designs are always ready when the sprint starts
- Discovery and delivery happen simultaneously, not sequentially
- If a hypothesis is invalidated, it does not derail the current delivery sprint

**Common pitfall:** If discovery gets more than one sprint ahead, validated designs become stale by the time they reach delivery. Keep the gap to exactly one sprint.

### T-Shaped Participation

In a Lean UX team, every member has a primary skill (the vertical bar of the T) and broad participation in adjacent activities (the horizontal bar).

| Role | Primary Skill | Lean UX Participation |
|------|-------------|----------------------|
| **Designer** | Visual/interaction design | Facilitates experiments, writes hypotheses, codes simple prototypes |
| **Developer** | Code, architecture | Participates in Design Studio, pair-designs with designer, builds experiment infrastructure |
| **Product Manager** | Strategy, prioritization | Writes hypotheses, facilitates assumption workshops, defines success metrics |
| **QA** | Testing, edge cases | Participates in design critique, identifies testable scenarios, reviews experiment results |

### Hypothesis-Driven User Stories

Traditional user stories focus on what to build. Lean UX stories add why (the hypothesis) and how we will know (the metric).

**Traditional format:**
```
As a [user], I want [feature], so that [benefit].
Acceptance criteria: [technical specification]
```

**Lean UX format:**
```
As a [user], I want [feature], so that [benefit].

HYPOTHESIS: We believe [outcome] will happen if [persona] achieves [action] with [feature].
SUCCESS METRIC: [metric] will [change] by [amount] within [timeframe].
EXPERIMENT: [How this was validated in discovery]

Acceptance criteria: [technical specification]
```

**Example:**

```
As a project manager, I want to filter tasks by due date, so that I can focus on urgent work.

HYPOTHESIS: We believe task completion rate will increase by 15% if project managers
use a due-date filter to surface overdue tasks.
SUCCESS METRIC: Task completion rate measured over 2 weeks post-launch.
EXPERIMENT: Validated with clickable prototype (5 users, 4/5 completed filter task
in under 10 seconds, all reported it would change their daily workflow).

Acceptance criteria:
- Filter dropdown with options: Today, This Week, Overdue, Custom Range
- Persists across sessions
- Works on mobile
```

## Backlog Management

### Lean UX Backlog Columns

| Column | Definition | Entry Criteria | Exit Criteria |
|--------|-----------|---------------|---------------|
| **Assumptions** | Unvalidated ideas and assumptions | Any team member can add | Prioritized in assumption matrix |
| **Hypotheses** | Assumptions converted to testable predictions | Written in standard hypothesis format | Experiment designed and scheduled |
| **Testing** | Hypotheses currently being tested | Experiment is actively running | Experiment complete, results analyzed |
| **Validated** | Hypotheses confirmed by experiment | Data meets pre-set success threshold | Ready for delivery sprint planning |
| **Invalidated** | Hypotheses disproven by experiment | Data falls below pre-set threshold | Archived with learnings; team decides pivot or drop |
| **Delivery** | Validated designs in development | Enters delivery sprint | Shipped to production |

### Backlog Grooming for Lean UX

During backlog grooming:

1. **Review invalidated hypotheses.** Decide: pivot (new hypothesis for same problem) or drop (problem is not worth solving).
2. **Re-prioritize assumptions.** New information from experiments may change which assumptions are highest risk.
3. **Size experiments, not features.** In discovery, estimate the effort to run an experiment, not the effort to build the final feature.
4. **Remove zombie items.** If a backlog item has not been tested in 3 sprints, it is either not important enough to test or the team lacks conviction. Remove or re-prioritize.

## Working with Engineering Teams

### Building Trust

The biggest barrier to Lean UX adoption is often trust between design and engineering. Engineers may resist if they feel:
- Design decisions are arbitrary ("the designer just likes it this way")
- Requirements change constantly ("they keep changing their mind")
- Their input is not valued ("just build what the wireframe says")

**Trust-building practices:**

| Practice | How It Builds Trust |
|----------|-------------------|
| Invite engineers to Design Studio | Their ideas are valued; they see the reasoning behind design decisions |
| Share experiment results openly | Decisions are evidence-based, not opinion-based |
| Pair design sessions | Designer and developer solve problems together; mutual respect grows |
| Prototype together | Developer builds a quick prototype while designer directs; fast, collaborative |
| Celebrate invalidated hypotheses | Shows the team that being wrong is expected and valuable |

### Handling Disagreements

When designers and engineers disagree on a solution:

1. **Frame it as a hypothesis.** "We have two approaches. Let's write a hypothesis for each and test the riskier one."
2. **Use data, not authority.** "The experiment showed users preferred A. Let's go with the evidence."
3. **Time-box the debate.** "We have 10 minutes to decide. If we can't agree, we test both with 5 users and let them decide."

## Definition of Done for UX

In traditional Agile, the Definition of Done focuses on engineering quality (code reviewed, tests passing, deployed). Lean UX expands the Definition of Done to include learning.

### Lean UX Definition of Done

A feature is "done" when:

| Criterion | Description |
|-----------|-------------|
| **Hypothesis validated** | The experiment met its pre-set success criteria |
| **Design tested with users** | At least 5 users have tested the design (prototype or live) |
| **Success metric defined** | The team knows exactly what metric to monitor post-launch |
| **Instrumented** | Analytics events are in place to measure the success metric |
| **Code complete and tested** | Standard engineering DoD (code review, unit tests, QA) |
| **Deployed** | Feature is in production (behind a flag or fully rolled out) |
| **Post-launch plan** | Team knows when and how they will review post-launch data |

### Post-Launch Learning Loop

The Definition of Done extends beyond deployment:

| Timeframe | Activity | Owner |
|-----------|----------|-------|
| **Day 1** | Verify instrumentation is working; check for errors | Engineer + Analyst |
| **Week 1** | Review early metric data; compare to hypothesis target | PM + Designer |
| **Week 2** | Run 3 follow-up interviews with users of the new feature | Designer |
| **Sprint end** | Report results: validated, invalidated, or inconclusive | PM (in sprint review) |

## Sprint Zero Anti-Pattern

**The problem:** Many teams use a "Sprint Zero" where designers work ahead for weeks before engineers start building. This creates a waterfall disguised as Agile.

**Why it fails:**
- Design decisions are made without engineering input
- By the time engineers start, context is lost and designs need rework
- The feedback loop between design and development is broken
- Designers become a bottleneck

**The Lean UX alternative:**
- Start discovery and delivery simultaneously from day one
- The first discovery sprint runs experiments with paper prototypes; there is no delay waiting for "finished designs"
- Engineers participate in design sessions from the start
- Use staggered sprints to maintain flow without a buffer sprint

## Scaling Lean UX

### Multiple Teams

When multiple squads work on the same product:

| Challenge | Solution |
|-----------|----------|
| Hypotheses overlap across teams | Shared hypothesis board visible to all squads |
| Inconsistent experiment standards | Shared experiment template and success criteria norms |
| Duplicate research | Shared research repository; weekly cross-team research sync |
| Diverging design directions | Shared design system; cross-team Design Studio quarterly |

### Lean UX in SAFe / Large-Scale Agile

| SAFe Concept | Lean UX Integration |
|-------------|---------------------|
| **Program Increment (PI) Planning** | Include discovery track objectives alongside delivery objectives |
| **Architectural runway** | Discovery track identifies UX patterns needed for future features |
| **Enabler stories** | Include experiment infrastructure (analytics, prototype tools, research ops) as enablers |
| **Inspect and Adapt** | Review learning velocity and hypothesis validation rate across teams |

## Metrics for Lean UX in Agile

Track these metrics to evaluate whether Lean UX is working within your Agile process:

| Metric | What It Measures | Target |
|--------|-----------------|--------|
| **Hypotheses validated per sprint** | Learning velocity | 2-4 per sprint |
| **Hypotheses invalidated per sprint** | Willingness to be wrong | At least 1 per sprint (0 means confirmation bias) |
| **Time from hypothesis to experiment** | Discovery speed | Less than 1 sprint |
| **Backlog items removed due to invalidation** | Waste prevention | At least 1 per quarter |
| **Team members observing research** | Shared empathy | All team members observe at least 1 session per sprint |
| **Post-launch metrics reviewed** | Closing the learning loop | 100% of shipped features reviewed within 2 weeks |
