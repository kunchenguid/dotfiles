# Hypothesis Canvas

The hypothesis canvas is the central planning artifact in Lean UX. It transforms vague product ideas into structured, testable predictions. Every design initiative should start here, not in a wireframing tool.

## The Lean UX Hypothesis Format

The standard hypothesis statement links four elements into a single testable prediction:

```
We believe [outcome]
will happen if [persona]
achieves [action]
with [feature].
```

### Breaking Down the Components

| Component | Definition | Example |
|-----------|-----------|---------|
| **Outcome** | The measurable business or user result you expect | "A 15% increase in trial-to-paid conversion" |
| **Persona** | The specific user segment the hypothesis targets | "First-time project managers using our free tier" |
| **Action** | The behavior you expect users to perform | "Complete the guided project setup wizard within the first session" |
| **Feature** | The design change or product element that enables the action | "A 3-step interactive setup wizard on the dashboard" |

### Complete Hypothesis Examples

**E-commerce checkout redesign:**
"We believe cart abandonment will drop by 20% if returning shoppers can complete checkout in under 60 seconds with a one-click reorder button on the product page."

**SaaS onboarding:**
"We believe 7-day retention will increase by 25% if new users who sign up via the marketing site achieve their first successful data import within 10 minutes with an auto-mapping CSV import tool."

**Internal tools:**
"We believe support ticket resolution time will decrease by 30% if support agents can view the full customer timeline without switching tabs with a unified customer context panel in the ticket view."

**Mobile app engagement:**
"We believe weekly active usage will increase by 40% if casual fitness users log at least 3 workouts in their first week with a simplified one-tap workout logging feature."

## Assumption Prioritization Matrix

Before writing hypotheses, the team must surface and prioritize assumptions. The prioritization matrix plots assumptions on two axes.

### The Two Axes

| Axis | Definition | Scale |
|------|-----------|-------|
| **Risk** | How damaging is it if this assumption is wrong? | Low risk (minor inconvenience) to High risk (project failure) |
| **Uncertainty** | How confident are we that this assumption is true? | Low uncertainty (strong evidence) to High uncertainty (pure guess) |

### The Four Quadrants

```
                    HIGH UNCERTAINTY
                          |
    +-----------+---------+---------+-----------+
    |           |                   |           |
    |  Monitor  |   TEST FIRST     |           |
    |  (Low R,  |   (High R,       |           |
    |   High U) |    High U)       |           |
    |           |                   |           |
LOW RISK -------+---------+---------+------- HIGH RISK
    |           |                   |           |
    |  Ignore   |   Mitigate       |           |
    |  (Low R,  |   (High R,       |           |
    |   Low U)  |    Low U)        |           |
    |           |                   |           |
    +-----------+---------+---------+-----------+
                          |
                    LOW UNCERTAINTY
```

### Quadrant Actions

| Quadrant | Risk | Uncertainty | Action |
|----------|------|-------------|--------|
| **Test First** | High | High | Write hypothesis, design experiment, test immediately |
| **Monitor** | Low | High | Gather data passively; test if uncertainty persists |
| **Mitigate** | High | Low | Build safeguards; standard engineering/design best practices |
| **Ignore** | Low | Low | Do not spend time here; proceed with confidence |

### Running the Prioritization Workshop

**Time:** 45-60 minutes
**Participants:** Product manager, designer, tech lead, and one stakeholder

**Steps:**

1. **Generate assumptions (15 min).** Each participant writes assumptions on sticky notes (physical or virtual). One assumption per note. Use prompts:
   - "Our users are..."
   - "Users will use this feature because..."
   - "This will work because..."
   - "We will make money by..."
   - "The biggest risk is..."

2. **De-duplicate and cluster (10 min).** Group similar assumptions. Combine duplicates. Give each cluster a label.

3. **Plot on matrix (15 min).** The facilitator reads each assumption aloud. The team discusses and places it on the 2x2 matrix. Disagreement is valuable; it reveals hidden uncertainty.

4. **Select top 3 for testing (10 min).** From the "Test First" quadrant, choose the three assumptions that, if wrong, would most damage the project. These become the first hypotheses.

5. **Write hypotheses (10 min).** Convert each selected assumption into a hypothesis using the standard format. Assign an owner and a target experiment date.

## Business Assumptions vs. User Assumptions

Lean UX distinguishes two categories of assumptions. Both must be tested, but they require different experiments.

### Business Assumptions

Business assumptions concern the viability and sustainability of the product from the organization's perspective.

| Assumption Category | Example | Experiment Type |
|---------------------|---------|-----------------|
| **Revenue model** | "Users will pay $29/month for this feature" | Pricing page test, pre-order, willingness-to-pay survey |
| **Market size** | "There are 50,000 potential customers in our ICP" | Market research, ad campaign response rates |
| **Cost structure** | "We can deliver this for less than $5/user/month" | Concierge MVP cost tracking |
| **Channel** | "Users will discover us through organic search" | SEO experiment, content test |
| **Competitive advantage** | "Our solution is 3x faster than alternatives" | Comparative usability test |

### User Assumptions

User assumptions concern the people who will use the product, their behaviors, needs, and context.

| Assumption Category | Example | Experiment Type |
|---------------------|---------|-----------------|
| **Who they are** | "Our primary user is a mid-level marketing manager" | Customer interviews, analytics demographics |
| **What they need** | "Users need to generate reports weekly" | Usage analytics, interview, diary study |
| **Current behavior** | "Users currently use spreadsheets for this task" | Contextual inquiry, survey |
| **Motivation** | "Users will switch because our tool saves 2 hours/week" | Time-on-task comparison, prototype test |
| **Barriers** | "Users will not adopt if setup takes more than 10 minutes" | Onboarding funnel analysis, usability test |

### Connecting the Two

A complete Lean UX canvas pairs business and user assumptions:

```
BUSINESS ASSUMPTION: Users will pay $29/month
  └─ USER ASSUMPTION: Users value the time saved enough to justify $29
       └─ HYPOTHESIS: We believe paid conversion will reach 5%
            if marketing managers who complete 3 reports
            with our auto-generated template feature
            save at least 2 hours per week.
```

## Sub-Hypotheses

Large hypotheses often need decomposition. A sub-hypothesis isolates one variable from the parent hypothesis so it can be tested independently.

### When to Use Sub-Hypotheses

- The parent hypothesis involves multiple unknowns
- Testing the parent hypothesis requires building too much
- The team disagrees on which component is the riskiest

### Decomposition Example

**Parent hypothesis:** "We believe monthly active users will increase by 30% if new users complete a personalized onboarding flow with an AI-powered recommendation engine."

**Sub-hypotheses:**

| # | Sub-Hypothesis | Tests |
|---|---------------|-------|
| 1 | "We believe new users will engage with a personalized onboarding flow (measured by 70% completion rate)" | Clickable prototype test with 8 users |
| 2 | "We believe AI recommendations during onboarding will feel relevant (measured by >4/5 relevance rating)" | Wizard of Oz test: manual recommendations presented as AI |
| 3 | "We believe users who complete personalized onboarding will return within 7 days at 2x the rate of standard onboarding" | A/B test with coded prototype |

### Sub-Hypothesis Decision Tree

After testing sub-hypotheses:

- **All pass:** Proceed to build the parent feature.
- **Some pass, some fail:** Redesign the failing component; retest.
- **All fail:** Pivot. The parent hypothesis is likely wrong.

## Hypothesis Tracking Log

Maintain a living document (spreadsheet or wiki) to track all hypotheses across sprints.

| ID | Hypothesis | Status | Experiment | Metric | Target | Actual | Decision |
|----|-----------|--------|------------|--------|--------|--------|----------|
| H-001 | Trial-to-paid +10% with setup wizard | Testing | Prototype test | Completion rate | 70% | -- | -- |
| H-002 | Cart abandonment -20% with one-click reorder | Validated | A/B test | Abandonment rate | 60% | 58% | Ship |
| H-003 | Support time -30% with context panel | Invalidated | Usability test | Task time | 4 min | 6 min | Pivot |

### Review Cadence

- **Weekly:** Update status of active experiments.
- **Sprint boundary:** Review validated/invalidated count. Celebrate invalidations as learning.
- **Quarterly:** Review patterns. Which assumption categories are most often wrong? Adjust future prioritization.

## Hypothesis Canvas Template

Use this canvas at the start of every initiative:

```
LEAN UX HYPOTHESIS CANVAS
==========================

Project: _______________
Date: _______________
Team: _______________

ASSUMPTIONS (top 3 from prioritization)
1. _______________
2. _______________
3. _______________

HYPOTHESIS #1
We believe _______________
will happen if _______________
achieves _______________
with _______________.

Success metric: _______________
Target: _______________
Experiment type: _______________
Time box: _______________

HYPOTHESIS #2
We believe _______________
will happen if _______________
achieves _______________
with _______________.

Success metric: _______________
Target: _______________
Experiment type: _______________
Time box: _______________

SUB-HYPOTHESES (if needed)
1a. _______________
1b. _______________

OUTCOME (fill after experiment)
Result: _______________
Learning: _______________
Decision: [ ] Validate & ship  [ ] Iterate  [ ] Pivot  [ ] Kill
Next hypothesis: _______________
```

## Anti-Patterns

| Anti-Pattern | Why It Fails | Fix |
|-------------|-------------|-----|
| Writing hypotheses after building | Retroactive justification, not real testing | Hypotheses must exist before any design work |
| Vague outcomes ("improve UX") | Cannot be measured or falsified | Use specific metrics with numeric targets |
| Testing the safe assumption first | Wastes time; risky assumptions remain hidden | Use the prioritization matrix; test high-risk, high-uncertainty first |
| One giant hypothesis per quarter | Too many variables; impossible to learn from failure | Decompose into sub-hypotheses testable in 1-2 weeks |
| No pre-set success criteria | Team rationalizes any result as success | Define pass/fail thresholds before the experiment begins |
| Hypothesis written by one person | Lacks diverse perspectives; blind spots persist | Run collaborative assumption workshop with full team |
