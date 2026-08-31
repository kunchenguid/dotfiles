# Prioritization Methods

A guide to structured methods for comparing and ranking opportunities on the Opportunity Solution Tree, so product teams focus on the highest-leverage bets backed by evidence.

## Why Structured Prioritization Matters

Without a structured approach, teams default to prioritizing by:
- **HiPPO** (Highest Paid Person's Opinion) -- the loudest voice wins
- **Recency bias** -- whatever the last customer said becomes the top priority
- **Squeaky wheel** -- the most vocal internal stakeholder gets their feature built
- **Gut feeling** -- the PM "just knows" what's important

Each of these leads to suboptimal outcomes because they skip the explicit tradeoff discussion that good prioritization requires. Structured methods don't eliminate judgment -- they channel it through a framework that surfaces disagreements early and ensures the team is aligned on why they're pursuing one opportunity over another.

## Compare and Contrast Prioritization

Teresa Torres recommends comparing opportunities head-to-head rather than scoring them independently. Independent scoring creates the illusion of objectivity while masking the real tradeoffs. Comparison forces the team to make explicit choices.

### How It Works

1. Take your top opportunities from the OST (ideally 5-7, no more than 10)
2. Compare each pair of opportunities across several dimensions
3. Through successive comparisons, a ranking emerges
4. The top-ranked opportunities become the team's focus

### Comparison Dimensions

| Dimension | Question to Ask | How to Evaluate |
|-----------|----------------|-----------------|
| **Opportunity size** | How many customers are affected? | Analytics data, segment sizes, interview frequency |
| **Frequency** | How often do customers encounter this need? | Interview stories, support ticket volume, usage data |
| **Severity** | How painful is this when it happens? | Emotional intensity in interviews, workaround complexity |
| **Strategic alignment** | Does this support our company's current strategy? | Team/company OKRs, leadership direction |
| **Evidence strength** | How much do we know about this opportunity? | Number of supporting interviews, data points |
| **Solution readiness** | Do we have promising solution ideas? | Quality and diversity of solutions mapped to this opportunity |

### Running a Comparison Session

**Time:** 60-90 minutes
**Participants:** Product trio (PM, designer, engineer)
**Preparation:** Each participant reviews the top opportunities and supporting evidence beforehand

**Process:**

1. **Round 1 -- Pair comparison (20 min):**
   - Compare opportunity A vs. opportunity B on each dimension
   - For each dimension, which opportunity is stronger?
   - Record the "winner" of each pair

2. **Round 2 -- Discussion (30 min):**
   - Where did the trio disagree? Discuss those dimensions
   - Surface the underlying assumptions behind disagreements
   - Look for dimensions where the answer is genuinely unknown -- these signal a need for more evidence

3. **Round 3 -- Stack rank (20 min):**
   - Based on the pair comparisons and discussion, create a rough rank order
   - The team doesn't need a perfect ranking -- they need to identify the top 2-3 opportunities to focus on

4. **Decide (10 min):**
   - Commit to a primary opportunity and a secondary opportunity
   - Identify any "must-know" questions before committing further (these become interview questions for the next week)

### Example Comparison

**Opportunity A:** "Users can't find relevant content in search results"
- Size: Affects 70% of active users (based on analytics showing search usage)
- Frequency: Daily for most users
- Severity: Moderate -- users work around it but it takes extra time
- Evidence: 8 interview snapshots mention search frustration

**Opportunity B:** "New users can't figure out how to complete their first project"
- Size: Affects 100% of new users (by definition)
- Frequency: Once per user, during onboarding
- Severity: High -- many users abandon before completing first project
- Evidence: 5 interview snapshots, plus analytics showing 60% drop-off at project creation

**Discussion:** A affects more total interactions (daily * 70% of users), but B affects a critical moment (first-use experience). If users never complete their first project, they never become the daily users who'd benefit from search improvements. The team decides B is higher priority because it gates everything else.

## Opportunity Scoring

For teams that need a lightweight quantitative approach, opportunity scoring provides a structured framework. This works well when you need to communicate priorities to stakeholders who expect numeric justification.

### Scoring Criteria

| Criterion | Scale | How to Score |
|-----------|-------|-------------|
| **Reach** | 1-5 | How many customers will this affect in a given time period? |
| **Impact** | 1-5 | How much will this improve the target outcome? |
| **Confidence** | 1-5 | How much evidence do we have? (Interviews, data, test results) |
| **Effort** | 1-5 (inverted) | How much work is required? (5 = very little effort) |

**Score = (Reach + Impact + Confidence + Effort) / 4**

### Confidence Scoring Guide

Confidence deserves special attention because it reflects the strength of your evidence:

| Score | Evidence Level | Description |
|-------|---------------|-------------|
| 1 | Gut feeling | Team speculation with no customer data |
| 2 | Weak signal | 1-2 interview mentions; anecdotal |
| 3 | Moderate signal | 3-5 interview snapshots; some supporting data |
| 4 | Strong signal | 6+ interview snapshots; supporting analytics; tested assumptions |
| 5 | Validated | Assumption tests passed; prototype feedback positive; quantitative data confirms |

### When Scoring Falls Short

Scoring methods have real limitations:
- **False precision:** A score of 3.7 vs. 3.5 is meaningless noise, not a real difference
- **Dimension conflation:** Averaging across dimensions hides tradeoffs (a high-reach, low-impact opportunity looks the same as a low-reach, high-impact one)
- **Gaming:** Teams unconsciously inflate scores for opportunities they already prefer
- **Missing context:** Numbers don't capture the strategic narrative

**Recommendation:** Use scoring as a starting point for discussion, not as a final decision. If the scores are close, switch to compare-and-contrast to resolve the tie.

## Impact vs. Effort

The classic 2x2 prioritization framework. Simple and intuitive, but should be used carefully.

### The Matrix

```
              HIGH IMPACT
                  │
     ┌────────────┼────────────┐
     │            │            │
     │  DO FIRST  │  BIG BETS  │
     │ (quick     │ (worth the │
     │  wins)     │  investment)│
     │            │            │
LOW ─┼────────────┼────────────┼── HIGH
EFFORT│            │            │  EFFORT
     │  FILL-INS  │  AVOID     │
     │ (do if     │ (high cost,│
     │  capacity  │  low return│
     │  allows)   │            │
     └────────────┼────────────┘
                  │
              LOW IMPACT
```

### Using It Well

**Impact estimation:** Base impact on customer evidence, not team opinion. An opportunity mentioned in 10 interviews with strong emotional language has higher estimated impact than one mentioned once.

**Effort estimation:** Get a rough engineering estimate -- not a detailed plan, but a t-shirt size (days, weeks, months). Include design, engineering, and validation effort.

**Common mistake:** Teams consistently underestimate effort and overestimate impact. Build in a skepticism factor: if you think it's "medium effort," it's probably "high effort."

### When to Use Impact vs. Effort

| Good Use Case | Poor Use Case |
|---------------|---------------|
| Quick triage of a long list of opportunities | Final decision on a major strategic bet |
| Sprint planning: choosing between several well-understood small items | Quarterly planning: choosing between fundamentally different directions |
| Identifying quick wins to build momentum | Prioritizing when evidence quality varies widely |

## Using Data to Prioritize

Quantitative data strengthens prioritization by grounding estimates in reality rather than intuition.

### Data Sources for Prioritization

| Data Source | What It Tells You | Prioritization Use |
|-------------|-------------------|-------------------|
| **Usage analytics** | How many users encounter a particular workflow | Estimate opportunity reach |
| **Funnel analysis** | Where users drop off in a process | Identify high-severity pain points |
| **Support tickets** | What problems users report most often | Frequency and severity signals |
| **NPS/CSAT verbatims** | What customers mention as positives and negatives | Opportunity framing in customer language |
| **Cohort analysis** | How behavior differs between retained and churned users | Identify opportunities that drive retention |
| **Competitive intelligence** | What competitors are investing in | Signal market-level opportunity size |

### Combining Qualitative and Quantitative

Neither data type alone is sufficient. Use them together:

| Qualitative (Interviews) | Quantitative (Data) | Combined Insight |
|--------------------------|---------------------|-----------------|
| "I struggle with search" (3 users) | 70% of active users use search daily | High-reach opportunity with validated pain |
| "Onboarding was confusing" (5 users) | 60% drop-off at project creation step | High-severity opportunity at a critical moment |
| "I'd love a mobile app" (2 users) | 5% of usage comes from mobile browsers | Low-reach opportunity despite vocal advocates |
| "I wish I could share with clients" (1 user) | No data yet | Needs more interviews before prioritizing |

**Rule:** Let qualitative data tell you what the opportunity is. Let quantitative data tell you how big it is.

## Avoiding Analysis Paralysis

The most common failure mode in prioritization is not choosing poorly -- it's not choosing at all. Teams get stuck in endless analysis, waiting for more data, debating criteria, and deferring decisions.

### Signs of Analysis Paralysis

- The team has been "prioritizing" for more than two sessions without a decision
- Every opportunity has roughly equal scores and the team can't break the tie
- The team keeps asking for "one more interview" or "one more data point" before deciding
- No opportunities have been committed to for more than two weeks

### How to Break Free

**1. Time-box the decision:** "We will commit to our top opportunity by end of day Friday. Period."

**2. Lower the stakes:** Remind the team that this is not an irreversible decision. You can switch opportunities as new evidence emerges. The cost of delay is higher than the cost of a suboptimal choice.

**3. Use the "regret minimization" test:** "If we spend the next 6 weeks on this opportunity and it doesn't pan out, would we regret it? Or would we say 'we learned something valuable'?"

**4. Default to evidence:** When opinions are split, ask: "Which opportunity has the most supporting evidence from interviews?" Default to the better-evidenced choice.

**5. Start with assumption testing:** If you truly can't decide between two opportunities, don't build either one yet. Instead, test the riskiest assumption for each and let the test results break the tie.

## When to Pivot Between Opportunities

Committing to an opportunity doesn't mean ignoring new evidence. Here's when to revisit:

| Signal | What It Means | Action |
|--------|---------------|--------|
| Assumption tests consistently fail | The opportunity may be smaller or different than expected | Re-examine the opportunity framing; consider pivoting |
| New interviews reveal a bigger opportunity | The landscape has changed | Add to the OST; run a comparison against current focus |
| Target outcome isn't moving despite shipping solutions | The opportunity may not be the right lever | Check if the opportunity is truly connected to the outcome |
| The team has exhausted solution ideas | Diminishing returns on the current opportunity | Move to the next-highest-priority opportunity |
| External change (market, competitor, regulation) | The priority landscape has shifted | Re-run prioritization with the new context |

### Pivot vs. Persevere Framework

Before pivoting, ask:
1. **Have we actually tested assumptions, or did we jump to building?** If you didn't test, go back and test.
2. **Did we give the solution enough time to show results?** Some solutions need weeks of adoption before impact appears.
3. **Is the evidence pointing consistently in one direction?** One failed test isn't enough; a pattern of failures is.
4. **What would we learn by spending one more week here?** If the answer is "nothing new," it's time to pivot.

## Prioritization Cadence

### Weekly

- Review test results and how they affect current opportunity ranking
- Quick check: is the team still working on the highest-priority opportunity?

### Monthly

- Full prioritization review with updated evidence
- Add new opportunities discovered through recent interviews
- Remove or de-prioritize opportunities that have been addressed or invalidated

### Quarterly

- Strategic review of the outcome itself -- is this still the right outcome?
- Major re-prioritization aligned with company goals
- Stakeholder alignment on opportunity ranking

## Communicating Priorities to Stakeholders

### What Stakeholders Need to See

| Audience | Format | Focus |
|----------|--------|-------|
| Executive leadership | OST summary with top 3 opportunities highlighted | Strategy and alignment with company goals |
| Cross-functional partners | Opportunity ranking with evidence summary | What to expect from the product team |
| Engineering team | Current opportunity + solutions with effort estimates | What to build and why |

### Handling Stakeholder Requests

When a stakeholder requests a feature that doesn't align with current priorities:

1. **Acknowledge the request:** "Thank you -- this is worth considering"
2. **Map it to the OST:** "Let me see which opportunity this serves"
3. **Show the tradeoff:** "Pursuing this would mean deprioritizing [current focus], which is supported by [evidence]. Here's what we'd give up."
4. **Offer alternatives:** "If the underlying need is [X], here's how we're addressing it through [current opportunity]"

This approach respects the stakeholder's input while keeping the team focused on evidence-based priorities.
