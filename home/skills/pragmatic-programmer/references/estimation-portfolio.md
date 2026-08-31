# Estimation and Knowledge Portfolio

Deep reference for reliable estimation techniques and continuous learning strategies. Load when guidance is needed on project estimation, PERT analysis, or managing a developer's knowledge portfolio.

## Table of Contents
1. [How to Estimate](#how-to-estimate)
2. [Understanding Scope](#understanding-scope)
3. [Building a Model](#building-a-model)
4. [PERT Estimation](#pert-estimation)
5. [Decomposition Strategies](#decomposition-strategies)
6. [Estimation Calibration](#estimation-calibration)
7. [Knowledge Portfolio Management](#knowledge-portfolio-management)
8. [Critical Thinking](#critical-thinking)

---

## How to Estimate

Estimation is the pragmatic programmer's most valuable communication skill. A good estimate sets appropriate expectations. A bad estimate destroys trust.

### The Context Question

Before estimating anything, ask: **"What is this estimate for?"** The answer determines the precision required:

| Context | Precision Needed | Appropriate Format |
|---------|-----------------|-------------------|
| Budget planning (next year) | Order of magnitude | "6 months, give or take 3" |
| Quarterly planning | Weeks | "4-8 weeks" |
| Sprint planning | Days | "3-5 days" |
| Daily standup | Hours | "About 4 hours remaining" |
| Production incident | Minutes | "ETA: 30-60 minutes" |

**Key insight:** Stating "it'll take 2 weeks" for a quarterly planning exercise implies false precision. Stating "1-3 weeks" is more honest and more useful.

### The Units Tell a Story

Choose units that convey the right level of uncertainty:

| Estimate | What the Listener Hears |
|----------|------------------------|
| "128 hours" | "They calculated this precisely; it should be exactly 128 hours" |
| "About 3 weeks" | "Roughly 3 weeks, could be 2-4" |
| "1-2 months" | "It's a big effort with meaningful uncertainty" |
| "6 months, give or take" | "We're really not sure; this is a rough order of magnitude" |

Use the roughest unit that matches your actual confidence level.

---

## Understanding Scope

The first step in any estimate is understanding what you're estimating. This sounds obvious but is the most common source of estimation failure.

### Scope Clarification Questions

| Question | Why It Matters |
|----------|---------------|
| What's included? | "Build a login page" -- does that include password reset? OAuth? 2FA? |
| What's excluded? | Explicit exclusions prevent scope creep after estimation |
| What can I assume? | "Can I use an existing component library or build from scratch?" |
| What's the quality bar? | MVP vs. production-hardened vs. enterprise-grade |
| Who's the audience? | Internal tool vs. public-facing vs. API for partners |
| What are the dependencies? | "I need the design team to deliver mocks first" |

### The Scope Multiplier Table

The same feature at different quality levels:

| Quality Level | Multiplier | Includes |
|--------------|-----------|----------|
| **Spike/Prototype** | 1x | Happy path only, no tests, no error handling |
| **MVP** | 2-3x | Happy path + basic error handling + basic tests |
| **Production-ready** | 4-6x | Full error handling, monitoring, tests, documentation |
| **Enterprise-grade** | 8-12x | Security audit, compliance, HA, disaster recovery, SLA |

A "login page" that takes 2 days as a prototype takes 8-12 days as production-ready. Make sure you and the stakeholder agree on the quality level before estimating.

---

## Building a Model

Good estimates come from models, not gut feelings. A model breaks the work into components whose effort you can reason about.

### Types of Models

**Analogy-based:** "This is similar to the payment integration we built last quarter, which took 3 weeks. This is simpler, so 2 weeks."

**Decomposition-based:** Break into tasks, estimate each, sum with a buffer. (See Decomposition Strategies below.)

**Historical data-based:** "Our team averages 8 story points per sprint. This epic is ~40 points, so 5 sprints."

**Three-point (PERT):** Estimate optimistic, most likely, and pessimistic. Calculate expected value. (See PERT Estimation below.)

### Model Validation

After building a model, sanity-check it:

| Check | How |
|-------|-----|
| **Comparison** | "Is this estimate in the same ballpark as similar past work?" |
| **Gut check** | "Does this feel right based on my experience?" |
| **Peer review** | "Does another senior engineer agree with this estimate?" |
| **Boundary test** | "What's the absolute minimum time? What's the longest it could possibly take?" |

---

## PERT Estimation

Program Evaluation and Review Technique (PERT) uses three estimates to produce a weighted average:

### The Formula

```
Expected = (Optimistic + 4 × Most Likely + Pessimistic) / 6
Standard Deviation = (Pessimistic - Optimistic) / 6
```

### Example

Estimating a database migration:

| Scenario | Value | Reasoning |
|----------|-------|-----------|
| **Optimistic (O)** | 3 days | Schema is simple, no data transformation needed |
| **Most Likely (M)** | 7 days | Some data transformation, testing in staging |
| **Pessimistic (P)** | 15 days | Complex data issues, rollback needed, multiple attempts |

```
Expected = (3 + 4×7 + 15) / 6 = (3 + 28 + 15) / 6 = 46 / 6 ≈ 7.7 days
Std Dev = (15 - 3) / 6 = 2 days
```

Communicate: **"About 8 days, with a range of 6-10 days (one standard deviation). Worst case: 15 days."**

### PERT for Multiple Tasks

When estimating a project with multiple tasks, PERT each task separately, then sum:

| Task | O | M | P | Expected | Std Dev |
|------|---|---|---|----------|---------|
| Schema design | 1 | 2 | 5 | 2.3 | 0.7 |
| Migration script | 2 | 4 | 8 | 4.3 | 1.0 |
| Testing | 1 | 3 | 7 | 3.3 | 1.0 |
| Rollback plan | 0.5 | 1 | 3 | 1.3 | 0.4 |
| **Total** | | | | **11.2** | **1.6** |

Total standard deviation for independent tasks: `sqrt(0.7² + 1.0² + 1.0² + 0.4²) = sqrt(0.49 + 1.0 + 1.0 + 0.16) = sqrt(2.65) ≈ 1.6 days`

Communicate: **"About 11 days, likely 10-13. Worst case: 23 days."**

---

## Decomposition Strategies

### Work Breakdown Structure (WBS)

Break work into progressively smaller pieces until each piece is estimable:

```
Feature: User Authentication
├── Design
│   ├── API design (0.5 days)
│   └── Database schema (0.5 days)
├── Implementation
│   ├── Registration endpoint (1 day)
│   ├── Login endpoint (1 day)
│   ├── Password hashing (0.5 days)
│   ├── JWT token generation (0.5 days)
│   ├── Token refresh (1 day)
│   └── Password reset (1.5 days)
├── Testing
│   ├── Unit tests (1 day)
│   ├── Integration tests (1 day)
│   └── Security testing (0.5 days)
├── Infrastructure
│   ├── Database migration (0.5 days)
│   └── Environment config (0.5 days)
└── Documentation
    └── API docs (0.5 days)

Subtotal: 10 days
Buffer (20%): 2 days
Total estimate: 12 days
```

### The Rule of Small Tasks

- Break tasks until each is **1 day or less**
- Tasks larger than 2 days are too vague to estimate reliably
- If you can't break a task down, you don't understand it well enough to estimate it

### Buffer Strategy

| Buffer Type | Amount | Rationale |
|-------------|--------|-----------|
| **Task buffer** | +20% per task | Unknown unknowns within the task |
| **Integration buffer** | +10-20% of total | Time to connect components |
| **Risk buffer** | +10-30% based on novelty | New tech, new domain, new team |
| **Communication buffer** | +10% | Meetings, reviews, decisions |

**Total project buffer** typically ranges from 30-50% on top of raw task estimates. This isn't padding -- it's realism.

---

## Estimation Calibration

The secret to getting better at estimation: **track your accuracy and adjust.**

### The Estimation Log

Keep a simple log:

| Date | Task | Estimate | Actual | Ratio | Notes |
|------|------|----------|--------|-------|-------|
| Jan 5 | Payment integration | 5 days | 8 days | 1.6x | Underestimated API complexity |
| Jan 15 | User dashboard | 3 days | 2.5 days | 0.8x | Reused more components than expected |
| Jan 22 | Data migration | 2 days | 6 days | 3.0x | Unexpected data quality issues |

### Calibration Metrics

After 20+ entries, calculate:

| Metric | What It Tells You |
|--------|------------------|
| **Average ratio** | Your systematic bias (>1 = underestimate, <1 = overestimate) |
| **Standard deviation** | Your consistency (lower = more reliable) |
| **Pattern by task type** | Where you're consistently wrong (always underestimate infra work?) |
| **Trend over time** | Are you getting better? |

If your average ratio is 1.5x, multiply all future estimates by 1.5 until you recalibrate.

### Common Estimation Biases

| Bias | Description | Fix |
|------|-------------|-----|
| **Optimism** | Assuming best case | Use PERT to force pessimistic thinking |
| **Anchoring** | First number heard dominates | Estimate independently before discussing |
| **Planning fallacy** | Ignoring past overruns | Consult your estimation log |
| **Scope neglect** | Forgetting testing, deployment, documentation | Use a checklist of "hidden" work |
| **Confidence bias** | Being too sure of your estimate | Always provide ranges |

---

## Knowledge Portfolio Management

Hunt and Thomas argue that your knowledge and experience are your most important professional assets -- and they're *expiring* assets. Technology changes. What you know today becomes obsolete.

### The Portfolio Analogy

Manage your knowledge like a financial portfolio:

| Financial Principle | Knowledge Equivalent |
|--------------------|---------------------|
| **Invest regularly** | Learn something every week, even when busy |
| **Diversify** | Don't only learn your current stack; explore adjacent areas |
| **Manage risk** | Mix safe investments (deepen expertise) with speculative ones (learn something wild) |
| **Buy low, sell high** | Learn emerging technologies early, before they're mainstream |
| **Review and rebalance** | Periodically assess what you know and identify gaps |

### Practical Investment Strategies

| Strategy | Time Commitment | Example |
|----------|----------------|---------|
| **Learn a new language every year** | 2 hours/week for 3 months | Learn Rust if you're a Python developer |
| **Read a technical book every quarter** | 30 min/day | One book on architecture, one on a new domain |
| **Take a course or workshop** | 1 day/quarter | Online course, conference workshop |
| **Participate in open source** | 2 hours/week | Contribute to a project outside your comfort zone |
| **Attend user groups or meetups** | 2 hours/month | Learn what other people are building and how |
| **Experiment with different environments** | 1 day/quarter | Try Windows if you use macOS; try Linux if you use Windows |
| **Stay current** | 15 min/day | Read technical newsletters, blogs, papers |

### The Portfolio Balance

| Category | Investment | Examples |
|----------|-----------|---------|
| **Core expertise (50%)** | Deepen what you do daily | Advanced patterns in your primary language, deep database knowledge |
| **Adjacent skills (30%)** | Expand your range | DevOps if you're a developer, UX if you're backend, security for everyone |
| **Speculative bets (20%)** | Explore the frontier | New paradigms (functional, AI/ML, blockchain), new languages, new domains |

---

## Critical Thinking

The pragmatic programmer doesn't just consume knowledge -- they evaluate it critically.

### Questions to Ask About What You Read and Hear

| Question | Why It Matters |
|----------|---------------|
| **Who's saying it?** | A vendor promoting their own product has different motivations than an independent researcher |
| **What's their context?** | "Microservices are the answer" -- at Google's scale, maybe. At your 5-person startup, probably not |
| **When was it written?** | A 2015 article about JavaScript best practices may be obsolete |
| **Why are they telling me this?** | Conference talks often promote the speaker's product or approach |
| **What are the trade-offs?** | Every technique has downsides. If the source doesn't mention any, be skeptical |

### The "Works for Us" Fallacy

Just because Netflix uses microservices doesn't mean you should. Critical thinking means understanding:

- **Scale:** Their problems are not your problems
- **Resources:** Their engineering team is not your engineering team
- **Context:** Their domain constraints are not your domain constraints
- **Survivorship bias:** You hear about the successes, not the failures

### Building a Bullshit Filter

| Claim | Red Flag | Better Question |
|-------|----------|----------------|
| "X is dead" | Absolutism | "In what contexts is X still appropriate?" |
| "Everyone is using Y" | Bandwagon | "What problem does Y solve that we actually have?" |
| "Z scales to millions" | Irrelevant scale | "Does Z work well at our scale of thousands?" |
| "You should always do W" | No nuance | "What are the trade-offs of W vs. alternatives?" |
| "This is best practice" | Appeal to authority | "Best for whom, in what context, measured how?" |

### The Pragmatic Evaluation Framework

When evaluating a new technology, methodology, or approach:

1. **Understand the problem it solves** -- What pain does it address?
2. **Understand the trade-offs** -- What does it cost (complexity, performance, learning curve)?
3. **Consider your context** -- Does it solve a problem you actually have?
4. **Try it small** -- Prototype or spike before committing
5. **Measure the results** -- Did it actually help, or just feel modern?
6. **Re-evaluate periodically** -- Is it still the right choice?

The pragmatic programmer's goal is not to use the newest technology. It's to use the **most appropriate** technology for their specific context. Sometimes that's cutting-edge; sometimes it's boring and well-proven. The critical thinker knows the difference.
