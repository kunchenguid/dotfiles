# Opportunity Solution Trees

A comprehensive guide to building, maintaining, and using Opportunity Solution Trees (OSTs) as the central artifact of continuous product discovery.

## What Is an Opportunity Solution Tree?

An Opportunity Solution Tree is a visual diagram that maps the path from a desired business outcome to the customer opportunities that could drive that outcome, the solutions that could address those opportunities, and the experiments that could test those solutions.

### The Four Layers

```
           [Desired Outcome]
                 |
    ┌────────────┼────────────┐
    |            |            |
[Opportunity] [Opportunity] [Opportunity]
    |            |        |         |
  [Sub-opp]  [Solution] [Solution] [Sub-opp]
    |            |        |         |
[Solution]   [Experiment] [Experiment] [Solution]
    |                                    |
[Experiment]                         [Experiment]
```

**Layer 1 -- Desired Outcome:** A measurable business or product metric the team is responsible for. Examples: increase trial-to-paid conversion from 8% to 15%, reduce time-to-value below 3 minutes, increase weekly active usage by 20%.

**Layer 2 -- Opportunities:** Customer needs, pain points, and desires discovered through interviews and research. These are always framed from the customer's perspective. Example: "I can't tell if the product is worth paying for during the trial."

**Layer 3 -- Solutions:** Specific product changes, features, or interventions that could address an opportunity. Multiple solutions can map to one opportunity. Example: "Add a guided tour that highlights premium features during trial."

**Layer 4 -- Experiments:** Small, fast tests that validate whether a solution will work before the team commits to building it fully. Example: "Show a 30-second video walkthrough to 50% of trial users and measure upgrade rate."

## How to Build an Opportunity Solution Tree

### Step 1: Define the Outcome

Work with leadership to identify a clear, measurable outcome for the team. Good outcomes are:
- **Measurable:** Has a number attached (conversion rate, retention, revenue)
- **Controllable:** The team can influence it through product changes
- **Time-bound:** Has a target date or review cadence
- **Customer-connected:** Improving this metric also improves the customer's life

| Good Outcomes | Poor Outcomes |
|---------------|---------------|
| Increase 30-day retention from 40% to 55% | "Make the product better" |
| Reduce onboarding drop-off by 30% | "Ship feature X" (that's a solution, not an outcome) |
| Increase NPS from 32 to 50 | "Win more deals" (not directly controllable by product) |

### Step 2: Populate the Opportunity Space

Use interview data, support tickets, analytics, and experience maps to identify customer opportunities. For each opportunity, ask:
- Is this framed from the customer's perspective?
- Is this a need, pain point, or desire -- not a solution?
- Did this come from research, not just team brainstorming?

**Common mistakes when writing opportunities:**
| What Teams Write | Why It's Wrong | Better Framing |
|-----------------|----------------|----------------|
| "Add search filters" | That's a solution | "Users can't find relevant items quickly" |
| "Users want a mobile app" | That's a solution disguised as a need | "Users need to check status on the go between meetings" |
| "Improve performance" | Too vague and internal-facing | "Pages take so long to load that users abandon tasks mid-flow" |

### Step 3: Break Down Large Opportunities

Large, abstract opportunities should be broken into smaller, more specific sub-opportunities. This makes them actionable and testable.

**Example decomposition:**

```
"Users struggle with onboarding"
    ├── "Users don't understand what the product does before signing up"
    ├── "Users can't figure out how to complete their first task"
    ├── "Users don't know which features are relevant to their role"
    └── "Users lose motivation before experiencing the core value"
```

Each sub-opportunity can have its own solutions and experiments. The team can choose to focus on one sub-opportunity at a time.

### Step 4: Generate Solutions

For each prioritized opportunity, brainstorm multiple solutions. The goal is to have at least three distinct approaches so the team can compare rather than falling in love with the first idea.

**Solution generation techniques:**
- **How Might We:** Reframe the opportunity as "How might we help users [opportunity]?" and brainstorm freely
- **Analogy mapping:** How do other industries or products solve a similar need?
- **Extreme constraints:** What would we do if we had only one day? One hour? No code changes?
- **Customer co-creation:** Show the opportunity to customers and ask how they'd solve it

### Step 5: Design Experiments

For each promising solution, identify the riskiest assumption and design a small test. See [assumption-mapping.md](assumption-mapping.md) for detailed assumption testing methodology.

## Comparing Solutions on the Tree

When multiple solutions map to the same opportunity, use these criteria to compare:

| Criterion | Question | How to Evaluate |
|-----------|----------|-----------------|
| Reach | How many customers does this affect? | Analytics data on the affected segment |
| Impact | How much will this improve the opportunity? | Assumption test results, analogous evidence |
| Confidence | How much evidence do we have? | Number of supporting interviews, test results |
| Effort | How long will this take to build? | Engineering estimate (rough) |

**Important:** Don't reduce this to a formula. Use the criteria to have an explicit conversation about tradeoffs. The goal is shared understanding, not a magic score.

## Keeping the Tree Alive

The OST is not a document you create once and file away. It is a living artifact that evolves weekly.

### Weekly Update Rhythm

| Activity | When | Who |
|----------|------|-----|
| Add new opportunities from interviews | After each interview | Product trio |
| Reorganize and re-cluster opportunities | Weekly synthesis session (30 min) | Product trio |
| Add or remove solutions based on new evidence | When assumption tests complete | Product trio |
| Review tree structure for completeness | Bi-weekly | Product trio + stakeholders |
| Update outcome metrics | Monthly | PM with data team |

### Signs Your Tree Is Healthy

- New opportunities are being added every week from fresh interviews
- The team can explain why they chose their current focus opportunity
- Solutions have been tested with assumption tests before being built
- Stakeholders can look at the tree and understand the team's strategy
- The tree has changed meaningfully in the last month

### Signs Your Tree Is Dying

- No new opportunities have been added in two or more weeks
- The tree was created once and lives in a forgotten document
- Solutions were added without connecting to a customer opportunity
- The team can't explain the relationship between their current work and the tree
- Opportunities are all written from the business perspective, not the customer's

## Visual Tree Examples

### Example 1: SaaS Trial Conversion

```
Outcome: Increase trial-to-paid conversion from 8% to 15%
│
├── Opportunity: "I don't understand the value before trial ends"
│   ├── Sub: "I don't know which features to try first"
│   │   ├── Solution: Personalized onboarding checklist
│   │   └── Solution: Role-based guided tour
│   └── Sub: "I can't tell how this is better than my spreadsheet"
│       ├── Solution: Side-by-side comparison calculator
│       └── Solution: Import existing spreadsheet data
│
├── Opportunity: "The pricing feels too high for what I've seen"
│   ├── Solution: Usage-based tier that starts cheaper
│   └── Solution: Highlight features user hasn't discovered
│
└── Opportunity: "I forget about the trial and it expires"
    ├── Solution: Smart reminder emails based on usage
    └── Solution: Extend trial for active users automatically
```

### Example 2: Consumer App Retention

```
Outcome: Increase Day-30 retention from 20% to 35%
│
├── Opportunity: "I run out of content that matches my interests"
│   ├── Solution: Improved recommendation algorithm
│   └── Solution: User-curated collections
│
├── Opportunity: "I don't have a reason to come back daily"
│   ├── Sub: "There's nothing new since yesterday"
│   │   └── Solution: Daily digest of new relevant content
│   └── Sub: "I don't have a routine around using the app"
│       └── Solution: Morning briefing notification
│
└── Opportunity: "I feel overwhelmed by too many choices"
    ├── Solution: Simplified home screen with 3 picks
    └── Solution: "Start here" single recommendation
```

## Common Anti-Patterns

### The Solution Tree

The tree has outcomes at the top and solutions at the bottom -- but no opportunity layer. This means the team is guessing at what customers need.

**Fix:** Go back to interviews. Every solution on the tree must trace to a customer opportunity discovered through research.

### The Wish List Tree

The opportunity layer is populated with feature requests from customers or stakeholders: "users want dark mode," "users want an API." These are solutions masquerading as opportunities.

**Fix:** Ask "why?" for each item. "Users want an API" becomes "Users need to connect our product to their existing workflow tools."

### The Stale Tree

The tree was created at the start of the quarter and hasn't been updated since. It no longer reflects what the team has learned.

**Fix:** Schedule a 30-minute weekly session to update the tree with insights from that week's interviews.

### The Disconnected Tree

The tree exists but the team's actual sprint work doesn't connect to it. Features are being built that don't appear anywhere on the tree.

**Fix:** Every sprint item should trace back to a solution on the tree. If it can't, either the tree is incomplete or the work isn't strategically aligned.

## Tools and Formats

The OST can be maintained in:
- **Physical whiteboard:** Best for co-located teams; highly visible and easy to modify
- **Digital whiteboarding tools:** Miro, FigJam, or Mural for remote teams
- **Dedicated tools:** ProductBoard, Vistaly, or Notion databases with relational views
- **Simple documents:** Even a nested bullet list in a shared doc works for small teams

The format matters less than the discipline of updating it weekly.
