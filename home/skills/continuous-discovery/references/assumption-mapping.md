# Assumption Mapping

A detailed guide to identifying, categorizing, prioritizing, and testing the assumptions that underlie product decisions, so teams invest in building only what evidence supports.

## Why Assumptions Matter

Every product decision rests on a stack of assumptions. When a team says "let's build feature X to solve opportunity Y," they are implicitly assuming:
- Customers actually have this need (desirability)
- Customers can figure out how to use it (usability)
- We can build it with acceptable effort (feasibility)
- The business can sustain it (viability)

Most teams never make these assumptions explicit. They build first and discover their assumptions were wrong after investing weeks or months. Assumption mapping inverts this: make assumptions explicit, identify the riskiest ones, and test them cheaply before committing resources.

## Types of Assumptions

### Desirability Assumptions

**Question:** Do customers want this? Will they choose to use it?

These are the most common and most dangerous assumptions because teams often believe their own enthusiasm is evidence of customer demand.

| Assumption Pattern | Example | Test Approach |
|-------------------|---------|---------------|
| "Customers have this problem" | "Users struggle to find relevant content" | Interview stories confirming the struggle |
| "Customers want this solution" | "Users would use AI-generated summaries" | Painted-door test measuring clicks |
| "This is important enough to switch for" | "Users would leave competitor X for this" | Pre-order or commitment test |
| "Customers will adopt this behavior" | "Users will share reports with their team" | Prototype test measuring sharing behavior |

### Viability Assumptions

**Question:** Does this work for our business? Can we sustain it?

| Assumption Pattern | Example | Test Approach |
|-------------------|---------|---------------|
| "Customers will pay for this" | "Users will upgrade from free to paid for this feature" | Pricing page test, pre-sale offers |
| "This won't cannibalize existing revenue" | "Adding a cheaper tier won't downgrade existing customers" | Conjoint analysis, segment analysis |
| "We can acquire customers profitably" | "CAC for this segment will be under $50" | Small-scale ad campaign test |
| "This fits our brand and strategy" | "Enterprise customers won't see this as too consumer-y" | Customer advisory board feedback |

### Feasibility Assumptions

**Question:** Can we build this? Do we have the capability?

| Assumption Pattern | Example | Test Approach |
|-------------------|---------|---------------|
| "The technology can do this" | "Our ML model can achieve 90% accuracy" | Technical spike or prototype |
| "We can build this in time" | "We can ship this in the current quarter" | Timeboxed prototype |
| "Third-party dependencies will work" | "The API we depend on can handle our volume" | Load test against the API |
| "Our data is sufficient" | "We have enough training data for the model" | Data audit and small-scale test |

### Usability Assumptions

**Question:** Can customers figure out how to use this? Will they succeed?

| Assumption Pattern | Example | Test Approach |
|-------------------|---------|---------------|
| "Users will find this feature" | "Users will notice the new button in the toolbar" | Unmoderated usability test |
| "Users will understand the concept" | "Users will understand what 'workspaces' means" | Five-second test or concept test |
| "Users can complete the workflow" | "Users can set up an automation in under 5 minutes" | Task-based usability test |
| "The mental model matches" | "Users think of this as a 'project,' not a 'folder'" | Card sort or tree test |

## The Assumption Mapping Technique

### Step 1: Generate Assumptions

For each solution the team is considering, brainstorm all the assumptions that must be true for it to succeed. Use the four categories as prompts:

**Facilitator prompts:**
- "For this solution to work, what must be true about what customers want?" (desirability)
- "For this to be viable, what must be true about our business model?" (viability)
- "For us to build this, what must be true about our technology and team?" (feasibility)
- "For customers to succeed with this, what must be true about the experience?" (usability)

**Tips for generating assumptions:**
- Write each assumption as a statement that could be true or false: "Users will share reports at least once per week"
- Be specific: "Users will pay" is too vague; "Users will pay $20/month for this feature" is testable
- Include implicit assumptions the team takes for granted -- these are often the most dangerous
- Aim for 10-20 assumptions per solution

### Step 2: Map Assumptions on the 2x2

Plot each assumption on a two-axis grid:

```
                    HIGH IMPORTANCE
                    (fatal if wrong)
                          │
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        │   TEST THESE    │   WATCH THESE   │
        │   FIRST         │   (probably OK)  │
        │                 │                 │
LOW ────┼─────────────────┼─────────────────┼──── HIGH
EVIDENCE│                 │                 │  EVIDENCE
        │   TEST THESE    │   SAFE TO       │
        │   SECOND        │   ASSUME        │
        │                 │                 │
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                    LOW IMPORTANCE
                    (survivable if wrong)
```

**Importance (vertical axis):** How critical is this assumption? If it's wrong, does the whole solution fail (high), or is it a minor setback (low)?

**Evidence (horizontal axis):** How much do we already know? Do we have strong evidence from interviews, data, or tests (high), or is this pure speculation (low)?

### Step 3: Identify Leap-of-Faith Assumptions

The assumptions in the top-left quadrant -- high importance, low evidence -- are your **leap-of-faith assumptions**. These are the ones that could kill your solution if wrong, and you have little or no evidence to support them.

**Rule:** Never build a solution without first testing its leap-of-faith assumptions.

### Step 4: Prioritize Testing Order

Test in this order:
1. **High importance, low evidence** (leap-of-faith) -- test first, these are fatal unknowns
2. **Low importance, low evidence** -- test second if easy, or defer
3. **High importance, high evidence** -- monitor but don't spend testing effort
4. **Low importance, high evidence** -- safe to assume; revisit only if context changes

## Designing Assumption Tests

### Principles of Good Tests

| Principle | What It Means | Anti-Pattern |
|-----------|---------------|-------------|
| **Fast** | Complete in days, not weeks | 3-month A/B test for a single assumption |
| **Cheap** | Minimal resource investment | Building the full feature to "test" it |
| **Specific** | Tests one assumption at a time | Test that conflates desirability with usability |
| **Falsifiable** | Could produce a negative result | Test designed to only confirm what you hope |
| **Pre-committed criteria** | Success/failure defined before the test | "We'll know it when we see it" |

### Test Types by Assumption Category

#### Desirability Tests

| Test Type | Description | When to Use | Example |
|-----------|-------------|-------------|---------|
| **Painted door** | Add a button/link for a feature that doesn't exist yet; measure clicks | Early signal of interest | "Export to PDF" button that shows "Coming soon" and counts clicks |
| **One-question survey** | Ask one targeted question in-app to a sample of users | Quick pulse on a specific need | "How often do you need to share reports with people outside your team?" |
| **Fake feature** | Describe a feature in marketing material and measure interest | Before building anything | Landing page describing the feature; measure signup intent |
| **Concierge test** | Manually deliver the value to a small group | Validate the value before automating | Manually create the reports users would get from the feature |

#### Viability Tests

| Test Type | Description | When to Use | Example |
|-----------|-------------|-------------|---------|
| **Pricing page test** | Show different pricing options and measure selection | Before setting prices | A/B test with $10/mo vs. $20/mo tier including the feature |
| **Pre-sale** | Offer early access at a discount; measure commitment | Before building | "Get lifetime access for $99 if you commit now" |
| **Unit economics model** | Build a spreadsheet model with conservative estimates | When cost structure is uncertain | Model the cost per user of running the ML model at scale |

#### Feasibility Tests

| Test Type | Description | When to Use | Example |
|-----------|-------------|-------------|---------|
| **Technical spike** | Timeboxed engineering exploration (1-3 days) | When technical risk is high | Can we get API response times under 200ms for this query? |
| **Prototype** | Working but unpolished implementation | When the approach is novel | Build a rough version of the algorithm and test accuracy |
| **Third-party evaluation** | Test external dependencies | When relying on external services | Can the vendor's API handle our expected request volume? |

#### Usability Tests

| Test Type | Description | When to Use | Example |
|-----------|-------------|-------------|---------|
| **Five-second test** | Show a design for 5 seconds; ask what they noticed | Testing discoverability | "Where would you click to export your report?" |
| **Unmoderated test** | Give users a task with a prototype; observe via recording | Testing task completion | "Using this prototype, create a weekly report" |
| **Concept test** | Show a description/sketch and ask for comprehension | Testing mental model | "Based on this description, what do you think 'workspace' means?" |
| **Wizard of Oz** | Users interact with what seems real but is manually operated | Testing the full experience | Users submit a request; team manually fulfills it behind the scenes |

## Setting Success Criteria

**Before running any test**, define what success and failure look like. This prevents post-hoc rationalization.

### Formula for Success Criteria

"We'll consider this assumption **validated** if [measurable outcome] reaches [threshold] within [timeframe]."

**Examples:**
- "We'll consider 'users want PDF export' validated if at least 15% of active users click the painted-door button within one week."
- "We'll consider 'users can complete setup in under 5 minutes' validated if 80% of test participants finish the task without help."
- "We'll consider 'users will pay $20/month' validated if at least 5% of free users shown the upgrade page initiate checkout."

### Choosing Thresholds

| Factor | Lower Threshold | Higher Threshold |
|--------|----------------|-----------------|
| High-cost solution | Need stronger signal before investing | 20%+ engagement |
| Low-cost solution | Moderate signal is sufficient | 10%+ engagement |
| Many alternatives exist | Need to be clearly better | Above baseline by 2x |
| No alternatives exist | Lower bar for "good enough" | Any measurable engagement |

## Assumption Testing in Practice

### Weekly Rhythm

| Day | Activity | Time |
|-----|----------|------|
| Monday | Review last week's test results; update assumption map | 30 min |
| Monday | Identify next assumption to test; design the test | 30 min |
| Tue-Thu | Run the test | Varies (often passive) |
| Friday | Collect results; decide: validated, invalidated, or inconclusive | 30 min |

### When Tests Are Inconclusive

Not every test produces a clear signal. When results are ambiguous:

1. **Check the test design:** Was the sample large enough? Was the test specific enough?
2. **Refine and retest:** Adjust the test to be more targeted
3. **Lower the stakes:** If you can't get a clear signal, is there a way to build a smaller version that lets you learn in production?
4. **Time-box the uncertainty:** "If we can't validate this in two more weeks of testing, we'll move to a different solution"

### Documenting Test Results

For each assumption test, record:
- **Assumption tested:** The specific statement
- **Test type:** What you did
- **Success criteria:** What you defined upfront
- **Results:** What actually happened
- **Decision:** Validated, invalidated, or inconclusive
- **Next step:** What changes based on this result

This creates an audit trail of evidence that supports decision-making and helps new team members understand why choices were made.

## Leap-of-Faith Assumptions: Deep Dive

Leap-of-faith assumptions are the untested beliefs that, if wrong, make the entire solution pointless. They deserve special attention.

### How to Identify Them

Ask the team: "If we could only test one thing before building, what would tell us the most about whether this will work?"

Common leap-of-faith patterns:
- **"They have this problem"** -- the need hasn't been validated through interviews
- **"They'll change their behavior"** -- the solution requires users to adopt a new habit
- **"They'll pay for this"** -- no evidence of willingness to pay
- **"This will work technically"** -- novel technology that hasn't been proven at this scale

### The Cost of Skipping

| Scenario | If You Test First | If You Skip Testing |
|----------|-------------------|---------------------|
| Assumption is true | Confidence to invest; 1-2 weeks of testing | Same confidence but weeks later |
| Assumption is false | Pivot early; save weeks/months of build time | Discover after full build; waste entire investment |
| Assumption is partially true | Refine the approach; build the right version | Build the wrong version; costly rework |

The asymmetry is clear: the cost of testing is always small compared to the cost of building on a false assumption.
