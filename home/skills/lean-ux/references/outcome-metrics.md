# Outcome Metrics for Lean UX

Lean UX shifts the definition of success from "did we ship it?" to "did it change behavior?" This reference covers how to choose, define, and track metrics that measure real outcomes rather than outputs.

## Outcomes vs. Outputs

The distinction between outcomes and outputs is the philosophical core of Lean UX.

### Definitions

| Term | Definition | Example |
|------|-----------|---------|
| **Output** | Something the team produces (a feature, a design, a release) | "We shipped the new onboarding flow" |
| **Outcome** | A measurable change in user or business behavior resulting from the output | "New user 7-day retention increased from 25% to 38%" |

### Why the Distinction Matters

Teams that measure outputs can ship features that fail silently. The feature is "done," the story is closed, and no one checks whether it actually helped. Teams that measure outcomes discover quickly when a shipped feature does not produce the expected behavior change, and they iterate or roll back before wasting more effort.

### The Output Trap

The output trap occurs when teams optimize for velocity (stories per sprint, features per quarter) instead of impact. Symptoms include:

- A long list of shipped features but flat or declining engagement metrics
- Stakeholders asking "what did we ship?" instead of "what did we learn?"
- Roadmaps measured by feature count, not behavior change
- Retrospectives that review delivery speed but never experiment results

### Shifting the Conversation

| Output-Focused Question | Outcome-Focused Question |
|------------------------|-------------------------|
| "When will this feature be done?" | "When will we know if this feature works?" |
| "How many story points did we complete?" | "How many hypotheses did we validate?" |
| "What's on the roadmap for Q3?" | "What user behavior are we trying to change in Q3?" |
| "Can we ship by the end of the sprint?" | "Can we measure the result by the end of the sprint?" |

## Leading vs. Lagging Indicators

Not all metrics are created equal. Leading indicators predict future results; lagging indicators confirm past results. Lean UX teams focus on leading indicators because they are actionable in the short term.

### Definitions

| Type | Definition | Characteristics | Example |
|------|-----------|----------------|---------|
| **Leading** | Predicts future outcomes; changes quickly in response to actions | Actionable, fast feedback, sometimes noisy | "Onboarding completion rate" (predicts retention) |
| **Lagging** | Confirms past outcomes; changes slowly | Reliable, slow feedback, hard to influence directly | "Monthly revenue" (confirms product-market fit) |

### Leading-Lagging Pairs

Every important lagging indicator has one or more leading indicators that predict it. Lean UX teams identify these pairs and focus experiments on the leading indicators.

| Lagging Indicator | Leading Indicator(s) | Why the Pair Works |
|-------------------|---------------------|-------------------|
| **Monthly revenue** | Trial-to-paid conversion rate, activation rate | Users who activate and convert drive future revenue |
| **Annual churn rate** | Weekly engagement score, feature adoption rate | Users who stop engaging will eventually churn |
| **NPS score** | Task completion rate, support ticket volume | Users who complete tasks without help are more likely to recommend |
| **Customer lifetime value** | Feature breadth usage, upgrade path completion | Users who use more features stay longer and spend more |
| **Market share** | Organic referral rate, branded search volume | Growing word-of-mouth predicts market share gains |

### Choosing Leading Indicators for Experiments

For each hypothesis, identify the leading indicator that will show change first:

| Hypothesis About | Lagging Indicator | Leading Indicator to Track |
|-----------------|-------------------|---------------------------|
| "New onboarding will improve retention" | 30-day retention | Onboarding completion rate (measurable in 1 day) |
| "Simplified pricing will increase revenue" | Quarterly revenue | Pricing page click-through rate (measurable in 1 week) |
| "In-app help will reduce support load" | Monthly support tickets | Help article engagement rate (measurable in 1 day) |
| "Social features will increase engagement" | MAU | Invite sent rate, social action completion (measurable in 1 week) |

## Choosing Metrics That Matter

### The HEART Framework

Google's HEART framework provides a structured way to choose metrics for UX outcomes:

| Category | Definition | Example Metrics |
|----------|-----------|-----------------|
| **Happiness** | User satisfaction, perceived ease of use | NPS, CSAT, SUS score, satisfaction survey |
| **Engagement** | Depth and frequency of interaction | DAU/MAU ratio, session length, actions per session |
| **Adoption** | New users or new feature uptake | New accounts, feature activation rate, first-use completion |
| **Retention** | Users who continue to use the product over time | Day-7 retention, Day-30 retention, churn rate |
| **Task Success** | Ability to complete core tasks efficiently | Task completion rate, time on task, error rate |

### Applying HEART to a Hypothesis

For each hypothesis, select 1-2 HEART categories most relevant to the expected outcome:

| Hypothesis | Primary HEART Category | Metric |
|-----------|----------------------|--------|
| "Setup wizard improves first-day experience" | Adoption | Setup completion rate |
| "Keyboard shortcuts speed up power users" | Task Success | Time on task for key workflows |
| "Redesigned dashboard increases daily usage" | Engagement | DAU/MAU ratio |
| "Simplified cancellation flow reduces complaints" | Happiness | CSAT score for cancellation flow |
| "Weekly email digest brings users back" | Retention | Day-30 retention for email recipients vs. non-recipients |

### Metric Selection Checklist

Before committing to a metric for a hypothesis, verify:

- [ ] **Measurable:** Can we actually collect this data with our current instrumentation?
- [ ] **Attributable:** Can we attribute changes to our experiment (not external factors)?
- [ ] **Timely:** Will we see results within the experiment's time box?
- [ ] **Actionable:** Will the result change what we do next?
- [ ] **Leading:** Does this metric predict future outcomes, or only confirm past ones?

## OKRs for UX Teams

OKRs (Objectives and Key Results) are a goal-setting framework that aligns well with Lean UX because Key Results are outcome-based, not output-based.

### Writing Outcome-Based OKRs

| Component | Output-Focused (Bad) | Outcome-Focused (Good) |
|-----------|---------------------|----------------------|
| **Objective** | "Ship the new dashboard" | "Help users make faster data-driven decisions" |
| **Key Result 1** | "Complete dashboard redesign by March 15" | "Dashboard users find their top metric in under 5 seconds (currently 18 sec)" |
| **Key Result 2** | "Add 3 new chart types" | "Daily dashboard visits increase from 40% to 65% of active users" |
| **Key Result 3** | "Write dashboard documentation" | "Support tickets about 'finding data' decrease by 50%" |

### OKR Templates for UX

**Template 1: Feature-level OKR**
```
Objective: [User behavior change we want to see]
KR1: [Leading metric] moves from [baseline] to [target]
KR2: [Happiness or task success metric] reaches [threshold]
KR3: [Adoption or engagement metric] reaches [threshold]
```

**Template 2: Team-level OKR (Learning velocity)**
```
Objective: Increase our team's learning velocity
KR1: Validate or invalidate 8+ hypotheses per quarter
KR2: Run user tests every sprint (0 sprints missed)
KR3: 100% of shipped features have post-launch metrics reviewed within 2 weeks
```

**Template 3: Product-level OKR**
```
Objective: Improve new user activation
KR1: Day-1 activation rate increases from 30% to 50%
KR2: Time to first value decreases from 12 minutes to under 5 minutes
KR3: Activation funnel drop-off at step 3 decreases by 40%
```

## Measuring Behavior Change

Lean UX ultimately measures whether a design changes behavior. Behavior change is the bridge between an output (what we shipped) and an outcome (what happened because we shipped it).

### Behavior Change Levels

| Level | Definition | Measurement Method | Example |
|-------|-----------|-------------------|---------|
| **Awareness** | User knows the feature exists | Feature visibility rate, tooltip hover rate | "70% of users saw the new filter option" |
| **Trial** | User tries the feature at least once | First-use rate, feature activation rate | "35% of users who saw the filter used it at least once" |
| **Adoption** | User incorporates the feature into regular workflow | Weekly active use rate, feature frequency | "20% of users use the filter at least 3x per week" |
| **Habit** | User uses the feature automatically without prompting | Unprompted use rate, time-to-first-use | "15% of users start their session by applying the filter" |

### Cohort Analysis for Behavior Change

Track behavior change by cohort (users grouped by when they first encountered the change):

| Cohort | Week 1 Trial | Week 2 Adoption | Week 4 Habit | Drop-off |
|--------|-------------|-----------------|-------------|----------|
| Jan 6-12 | 42% | 28% | 15% | 64% |
| Jan 13-19 | 45% | 31% | 18% | 60% |
| Jan 20-26 | 48% | 35% | 22% | 54% |

If the trial-to-habit drop-off decreases over time, your iterations are working.

## Vanity Metrics to Avoid

Vanity metrics make teams feel productive without revealing whether the product is improving. They are dangerous because they can mask failure.

### The Vanity Metric Test

A metric is vanity if:
1. It only goes up (total signups, total page views)
2. It does not help you make a decision
3. It cannot be tied to a specific action or experiment
4. It looks impressive in a slide deck but does not change your behavior

### Common Vanity Metrics and Their Alternatives

| Vanity Metric | Why It Misleads | Actionable Alternative |
|---------------|----------------|----------------------|
| **Total registered users** | Includes inactive, churned, and fake accounts | Monthly active users (MAU) |
| **Page views** | Bots, accidental clicks, confusion loops inflate it | Engaged sessions (sessions with meaningful actions) |
| **Time on site** | Could mean confusion, not engagement | Task completion rate + time on task for key flows |
| **App downloads** | Download does not equal usage | Day-7 retention, activation rate |
| **Social media followers** | Follower count does not equal engagement | Engagement rate (actions / impressions) |
| **Feature count** | More features does not mean better product | Feature adoption rate (% of users using each feature) |
| **Story points completed** | Measures delivery speed, not impact | Hypotheses validated per sprint |
| **NPS alone** | Single number hides the distribution | NPS by cohort, segment, and feature + qualitative follow-up |

## Metric Dashboards for Lean UX

### Team Dashboard

A Lean UX team dashboard should be visible to the entire team (physical wall or always-open screen) and updated at least weekly.

**Essential dashboard elements:**

| Section | Contents | Update Frequency |
|---------|----------|-----------------|
| **Current hypotheses** | Active experiments with status (testing, validated, invalidated) | Real-time |
| **Key outcomes** | 3-5 outcome metrics with trend lines and targets | Weekly |
| **Leading indicators** | 2-3 leading metrics that predict the key outcomes | Daily |
| **Experiment log** | Last 5 experiments with results and decisions | Per experiment |
| **Learning backlog** | Questions the team wants to answer next | Sprint boundary |

### Stakeholder Dashboard

Stakeholders need a different view: less operational detail, more strategic outcome tracking.

| Section | Contents | Purpose |
|---------|----------|---------|
| **OKR progress** | Key results with current vs. target | Shows strategic progress |
| **Outcome trends** | 3-month trend lines for primary outcomes | Shows direction of change |
| **Validated hypotheses** | Count + top learnings this quarter | Shows learning is happening |
| **Pivots and kills** | Features removed or pivoted based on evidence | Shows discipline and waste prevention |

## Metric Anti-Patterns

| Anti-Pattern | Why It Fails | Fix |
|-------------|-------------|-----|
| **Measuring too many things** | Team cannot focus; every metric is someone's priority | Choose 1 primary metric per hypothesis; max 3 OKR key results |
| **No baseline** | Cannot tell if a metric improved or declined | Establish baseline before running any experiment |
| **Post-hoc metric selection** | Cherry-picking the metric that showed improvement | Pre-commit to the metric in the hypothesis statement |
| **Ignoring qualitative data** | Numbers say "what" but not "why" | Pair every quantitative metric with 3-5 user interviews |
| **Dashboard but no action** | Data is collected but never reviewed or acted upon | Schedule weekly metric review; assign action items |
| **Comparing averages** | Averages hide segment differences | Use cohort analysis and segment breakdowns |
