# Opportunity Assessment

A structured approach to evaluating product opportunities before committing teams and resources. The opportunity assessment prevents the two most common planning failures: building low-impact features because a stakeholder demanded them, and chasing too many opportunities simultaneously because there was no framework for saying no.

## The Opportunity Assessment Questions

Before any team begins discovery on an opportunity, the product manager should be able to answer these questions clearly and concisely. If they cannot, the opportunity is not yet understood well enough to warrant investment.

### 1. What business objective does this address?

**Why this question matters:** Every product opportunity must connect to a business objective. If you cannot articulate the connection, the opportunity is either misaligned or poorly understood.

**Good answers:**
- "Reducing first-week churn, which is our #1 growth bottleneck (42% of signups never return after day 3)"
- "Increasing expansion revenue from existing mid-market accounts, our most efficient growth channel"
- "Entering the European market, which represents 40% of our total addressable market"

**Bad answers:**
- "Our competitor launched this feature" (reactive, not objective-driven)
- "The CEO thinks we should do this" (authority-driven, not evidence-driven)
- "It would be nice to have" (no business objective connection)
- "Customers keep asking for it" (feature request, not objective)

**Follow-up questions:**
- How does this objective rank against our other business objectives?
- What is the expected business impact if we succeed?
- What is the cost of not addressing this?

### 2. Who is the target customer?

**Why this question matters:** "Everyone" is not a customer segment. Specificity about who you are building for determines every subsequent decision -- from discovery approach to solution design to go-to-market strategy.

**Good answers:**
- "Mid-market SaaS companies (50-200 employees) who have outgrown spreadsheet-based project management but find enterprise tools too complex and expensive"
- "First-time mobile users in Southeast Asia who are accustomed to messaging apps but unfamiliar with desktop-style productivity tools"
- "Product managers at B2B companies who are transitioning from feature-based roadmaps to outcome-based planning"

**Bad answers:**
- "All of our users" (too broad to guide decisions)
- "Small businesses" (too vague -- a 2-person consulting firm and a 50-person restaurant chain are both "small businesses")
- "Users who would benefit from this feature" (circular reasoning)

**Follow-up questions:**
- How many target customers exist (total addressable market)?
- Do we have access to these customers for discovery?
- Are these customers we can reach through our existing channels?

### 3. What problem are we solving?

**Why this question matters:** The problem statement is the foundation of everything. A clearly articulated problem enables creative solution discovery. A vague or assumed problem leads to building features that solve nothing.

**Good answers:**
- "New users cannot find value within their first session because onboarding requires 8 configuration steps before they can perform any core action"
- "Sales teams lose deals because they cannot generate accurate proposals quickly enough -- the average proposal takes 3 days to create, and prospects go cold after 24 hours"
- "Finance teams spend 15+ hours per month manually reconciling data between three systems, leading to errors that average $12,000 per quarter in corrections"

**Bad answers:**
- "Users want a dashboard" (solution, not problem)
- "We need better analytics" (internal desire, not customer problem)
- "The existing flow is clunky" (vague and subjective)

**Problem severity assessment:**

| Severity Level | Signal | Implication |
|----------------|--------|-------------|
| Hair-on-fire | Customer is actively spending money/time on workarounds | High willingness to adopt a solution; strong pull |
| Significant pain | Customer acknowledges the problem and wishes it were solved | Moderate willingness to adopt; needs clear value demonstration |
| Nice-to-have | Customer recognizes the problem only when prompted | Low willingness to change behavior; high risk of non-adoption |
| Non-problem | Customer does not recognize or care about this issue | Do not build; the team has a false assumption |

### 4. How will we know if we succeeded?

**Why this question matters:** Without a clear success metric, teams cannot evaluate whether their solution worked. This leads to the "launch and forget" pattern where features ship but nobody checks whether they actually solved the problem.

**Good answers:**
- "First-week retention increases from 58% to 70% within 60 days of launch"
- "Average proposal creation time decreases from 3 days to 4 hours"
- "Monthly reconciliation errors decrease by 80%"

**Bad answers:**
- "Users like it" (subjective, unmeasurable)
- "Positive feedback from stakeholders" (not a customer outcome)
- "Feature adoption" (adoption is a proxy, not the outcome)

**Metric design principles:**
- Leading indicators over lagging indicators when possible (activation rate vs annual revenue)
- Customer outcomes over business outcomes when both are available (time saved vs revenue impact)
- Specific numbers over directional goals ("from 58% to 70%" vs "improve retention")
- Time-bound (when will we evaluate?)

### 5. What alternatives do customers have today?

**Why this question matters:** Understanding the current alternatives reveals competitive dynamics, switching costs, and the minimum bar your solution must clear. If the alternatives are "good enough," your solution must be dramatically better to drive adoption.

**Good answers:**
- "Teams currently use a combination of spreadsheets (60%), email threads (25%), and dedicated tools they've outgrown (15%). Switching cost is moderate -- data migration is painful but not impossible"
- "Most customers handle this manually, spending 3-4 hours per week. They've adapted to the pain and would need a compelling reason to change. The primary competitor is inertia"
- "Two direct competitors address this, but both focus on enterprise (>1000 employees) and price above $50k/year, leaving the mid-market underserved"

**Bad answers:**
- "Nobody else does this" (almost never true; non-consumption and workarounds are always alternatives)
- "The main competitor is [company]" (too narrow -- what about non-consumption, workarounds, adjacent categories?)

### 6. Why are we best positioned to solve this?

**Why this question matters:** Not every opportunity is the right opportunity for your team and company. You need an honest assessment of your competitive advantages and whether they apply to this specific opportunity.

**Good answers:**
- "We already have the data pipeline infrastructure and a large user base in this segment; a competitor would need 18+ months to build equivalent data coverage"
- "Our design team has deep expertise in mobile-first experiences for emerging markets, which is the core challenge of this opportunity"
- "We have existing relationships with 200+ mid-market finance teams through our current product, giving us a distribution advantage"

**Bad answers:**
- "We're smart and move fast" (not a defensible advantage)
- "We were first" (first-mover advantage is usually overstated)
- "Our technology is better" (how specifically, and does it matter for this problem?)

### 7. What are the key risks and dependencies?

**Why this question matters:** Every opportunity has risks. Identifying them upfront allows the team to design discovery activities specifically to address the highest risks first.

**Risk categories to assess:**

| Risk Category | Key Questions |
|---------------|---------------|
| Value risk | Will customers actually want this? Is the problem severe enough to drive behavior change? |
| Usability risk | Can customers figure out how to use the solution? Is the interaction model intuitive? |
| Feasibility risk | Can we build this with our current technology and team skills? What's the timeline? |
| Viability risk | Does this work with our business model? Are there legal, compliance, or ethical concerns? |
| Market timing risk | Is the market ready for this? Are we too early or too late? |
| Dependency risk | Do we depend on external partners, APIs, or teams that we don't control? |

---

## Prioritization Framework

Once multiple opportunities have been assessed, the team needs a framework for comparing and prioritizing them.

### The Severity-Impact Matrix

| | High Business Impact | Low Business Impact |
|--|---------------------|---------------------|
| **Hair-on-fire problem** | Top priority -- start discovery immediately | Good opportunity if resources allow |
| **Significant pain** | Strong candidate -- assess feasibility and timing | Deprioritize unless strategically important |
| **Nice-to-have** | Defer -- severity too low to justify investment | Do not pursue |

### Weighted Scoring (When Needed)

For organizations that need a more quantitative approach:

| Criterion | Weight | Score (1-5) |
|-----------|--------|-------------|
| Problem severity for target customer | 30% | |
| Business impact (revenue, retention, growth) | 25% | |
| Strategic alignment with vision and strategy | 20% | |
| Feasibility and team capability | 15% | |
| Market timing and competitive urgency | 10% | |

**Total weighted score = sum of (weight x score)**

**Caution:** Scoring frameworks create a false sense of precision. Use them to structure conversation and surface disagreements, not as a mechanical decision-making tool. The conversation about scores is more valuable than the scores themselves.

---

## Stakeholder Alignment Through Assessment

One of the most powerful uses of the opportunity assessment is as a communication tool for stakeholder alignment.

### Pre-Assessment Sharing

Before the team commits to an opportunity:
1. Draft the opportunity assessment
2. Share with key stakeholders for input
3. Incorporate feedback and address concerns
4. Gain alignment before committing resources

This process prevents the common failure mode where teams discover stakeholder objections late in development, after significant investment.

### Assessment as "No" Tool

The opportunity assessment provides a structured, respectful way to say no to low-priority requests:
- "We assessed this opportunity and the problem severity is low -- here's why"
- "This opportunity scores below three higher-priority items -- here's the comparison"
- "We cannot identify a clear business objective this serves -- can you help us understand?"

This is far more effective than saying "we don't have time" or "it's not on the roadmap," which invites escalation and political maneuvering.

---

## Opportunity Assessment Template

A concise, one-page format for capturing and communicating the assessment:

```
OPPORTUNITY ASSESSMENT: [Name]
Date: [Date]
Author: [PM Name]

1. BUSINESS OBJECTIVE
[Which business objective does this serve and why?]

2. TARGET CUSTOMER
[Who specifically are we building for?]

3. PROBLEM STATEMENT
[What problem are we solving? How severe is it?]

4. SUCCESS METRICS
[How will we know if we succeeded? Specific numbers and timeframe.]

5. CURRENT ALTERNATIVES
[What do customers do today? What are the switching costs?]

6. OUR ADVANTAGE
[Why are we well-positioned to solve this?]

7. KEY RISKS
[Top 3 risks and how we plan to address them in discovery]

8. RECOMMENDATION
[Pursue / Defer / Decline, with reasoning]
```

---

## Common Assessment Pitfalls

### 1. Solution-First Assessment

**Problem:** The assessment starts with "we should build X" and works backward to justify it.

**Fix:** Force the assessment to begin with the customer problem. If you cannot clearly articulate the problem independent of any solution, you are not ready to assess the opportunity.

### 2. Confirmation Bias in Research

**Problem:** The team conducts interviews or analyses designed to confirm the opportunity rather than genuinely evaluate it.

**Fix:** Explicitly seek disconfirming evidence. Ask: "What evidence would convince us this is NOT a good opportunity?" Then look for that evidence.

### 3. Anchoring on Competitors

**Problem:** The assessment focuses on "competitor X has this feature, so we need it too."

**Fix:** Reframe around the customer problem. Competitors may be solving a problem your customers don't have, or solving it for a different customer segment.

### 4. Ignoring Opportunity Cost

**Problem:** The assessment evaluates the opportunity in isolation without considering what the team will NOT do if they pursue it.

**Fix:** Always compare against the next-best alternative use of the team's time. "This is a good opportunity" is incomplete; "this is a better opportunity than the alternatives" is the real question.

### 5. Over-Assessment Paralysis

**Problem:** The team spends so long assessing opportunities that they never start discovery.

**Fix:** Time-box the assessment. A PM should be able to complete a first-draft assessment in 2-3 hours. Remaining uncertainties become discovery questions, not assessment blockers.
