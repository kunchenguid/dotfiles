# Strategic vs Tactical Programming

The distinction between strategic and tactical programming is not about specific techniques -- it is about mindset. It determines whether a codebase improves or degrades over time, and it is the single biggest factor in long-term software quality.

## Two Mindsets

### Tactical Programming

**Goal:** Get the current feature working as quickly as possible.

**Characteristics:**
- The primary metric is "does it work?"
- Design happens incidentally (or not at all)
- Shortcuts are acceptable because "we'll fix it later"
- Each change introduces a small amount of complexity
- The codebase gradually degrades over months and years

**The inner monologue:**
- "This is a little hacky but it works"
- "I'll clean this up in the next sprint"
- "It's just one extra parameter, no big deal"
- "We don't have time for a proper abstraction"
- "It's technical debt but we'll pay it down later"

### Strategic Programming

**Goal:** Produce a great design that also happens to work.

**Characteristics:**
- The primary metric is "does this make the system simpler?"
- Design is deliberate and happens before implementation
- Working code is necessary but not sufficient
- Each change is an investment opportunity -- leave the code better than you found it
- The codebase gradually improves over months and years

**The inner monologue:**
- "This works, but is there a simpler way to express this interface?"
- "Before I add this feature, let me improve the module structure"
- "This parameter feels wrong -- the module should decide this internally"
- "Let me write the interface comment first to clarify the abstraction"
- "This will take an extra hour now but save many hours later"

## The Tactical Tornado

Ousterhout's most vivid concept: the **tactical tornado** is a developer who produces features at extraordinary speed, leaving a trail of complexity in their wake.

### Profile of a Tactical Tornado

| Trait | Description |
|-------|-------------|
| **Speed** | Ships features faster than anyone else on the team |
| **Heroics** | Often praised by management for delivering quickly |
| **Trail of wreckage** | Every module they touch becomes harder for others to work with |
| **Special cases everywhere** | Adds boolean parameters, flags, and one-off workarounds |
| **No refactoring** | Never goes back to clean up; always moving to the next thing |
| **Knowledge hoarding** | Often the only one who can work on their code (because it's incomprehensible to others) |

### The Damage

A tactical tornado produces code that:
1. **Works today** (they are often technically skilled)
2. **Is hard to understand** (optimized for writing speed, not reading speed)
3. **Is hard to modify** (full of implicit assumptions and hidden dependencies)
4. **Slows the entire team** (others spend hours understanding and working around the tornado's code)
5. **Cannot be safely changed** (unknown unknowns abound)

### The Math

If a tactical tornado produces features at 2x speed but creates code that is 3x harder to maintain, the team loses productivity as soon as anyone else touches that code. Over a year, the tornado's output is a net negative because the maintenance cost exceeds the development speed gain.

### How to Handle Tactical Tornados

| Approach | Details |
|----------|---------|
| **Code reviews** | Require design quality, not just correctness; reject PRs that add unnecessary complexity |
| **Design discussions** | Require interface design before implementation |
| **Complexity budgets** | Set explicit limits on interface size and module coupling |
| **Team metrics** | Measure team velocity over time, not individual output |
| **Mentoring** | Help the tornado see long-term impact; often they genuinely don't realize the cost |

## The Investment Mindset

### The 10-20% Rule

Ousterhout recommends spending roughly 10-20% of development time on design improvement. This is not a separate "refactoring phase" -- it is part of every feature's development.

**What the investment looks like:**

| Investment | Time | Payoff |
|-----------|------|--------|
| Write interface comments before code | 15-30 minutes | Catches bad designs before implementation |
| Improve a module's interface while adding a feature | 1-2 hours | Simplifies the module for all future changes |
| Refactor a function that has become too complex | 30-60 minutes | Reduces cognitive load for the next developer |
| Add missing comments to code you had to study | 15 minutes | Saves the next developer hours of reverse-engineering |
| Rename variables and functions for clarity | 15 minutes | Reduces obscurity throughout the module |
| Eliminate a configuration parameter by auto-detecting | 1-2 hours | Removes complexity for every caller |

### Why 10-20% Is Enough

You don't need massive refactoring projects. Small, continuous improvements compound:

```
Month 1:  Codebase quality: ████████░░ (80%)
Month 3:  Codebase quality: █████████░ (85%)  -- steady small investments
Month 6:  Codebase quality: █████████░ (90%)  -- improvements compound
Month 12: Codebase quality: ██████████ (95%)  -- team is highly productive
```

Compare with tactical programming:

```
Month 1:  Codebase quality: ████████░░ (80%)
Month 3:  Codebase quality: ███████░░░ (75%)  -- small shortcuts accumulate
Month 6:  Codebase quality: ██████░░░░ (65%)  -- velocity drops noticeably
Month 12: Codebase quality: ████░░░░░░ (45%)  -- team spends more time fighting code than building features
```

### Investment Opportunities in Every PR

Every pull request is an opportunity to improve the system. Some investments:

| Opportunity | Example |
|------------|---------|
| **Improve naming** | Rename `process()` to `validateAndPersistOrder()` |
| **Simplify an interface** | Remove a parameter that can be auto-detected |
| **Add missing comments** | Document the interface of a function you had to study |
| **Merge shallow classes** | Combine `OrderValidator` and `OrderService` |
| **Extract hidden information** | Move format knowledge from three modules into one |
| **Remove dead code** | Delete unused methods, parameters, or configuration options |
| **Fix temporal decomposition** | Merge `readConfig()` and `applyConfig()` into `loadConfig()` |

### The Boy Scout Rule with Teeth

"Leave the code better than you found it" is a common principle, but Ousterhout gives it teeth: every change should include at least one design improvement. Not every change needs a major refactoring, but every change should make some small improvement to the system's design.

## How Startups Should Approach Design

### The Myth: "We'll Fix It Later"

Many startups believe that design quality is a luxury they will invest in once they have product-market fit. This is almost always wrong.

**Why:**
1. "Later" never comes -- there is always another urgent feature
2. Technical debt compounds -- the cost of fixing grows exponentially
3. Early design decisions become architectural constraints that are extremely expensive to change
4. As the team grows, bad abstractions slow everyone down (not just the original author)
5. Velocity problems from poor design often look like "we need more engineers" problems

### The Reality

Startups that invest in design from day one:
- Ship features faster after the first few months (clean code is faster to modify)
- Onboard new developers faster (clear abstractions reduce ramp-up time)
- Have fewer production incidents (fewer unknown unknowns)
- Can pivot more easily (well-abstracted code adapts to new requirements)

Startups that take tactical shortcuts from day one:
- Ship features fast for the first few weeks
- Gradually slow down as complexity accumulates
- Spend increasing time debugging, not building
- Eventually face a "rewrite or die" decision (and rewrites usually fail)

### The Startup Investment

The 10-20% investment is even more affordable for startups because:
- The codebase is small, so improvements have outsized impact
- Early design decisions propagate through all future code
- The team is small, so design discussions are fast
- There is no legacy code to work around

**Practical startup approach:**
1. Spend 10% of time on design improvement -- not 0%, not 50%
2. Write interface comments for all public APIs
3. Don't create shallow classes "because that's how enterprise code works"
4. Refactor aggressively while the codebase is small and the cost is low
5. Establish code review norms that include design quality

## Culture: Facebook vs Google

Ousterhout contrasts two engineering cultures to illustrate the strategic vs tactical distinction.

### Facebook's "Move Fast and Break Things" (Tactical Culture)

| Aspect | Details |
|--------|---------|
| **Motto** | "Move fast and break things" (later changed to "Move fast with stable infrastructure") |
| **Incentive** | Ship features quickly; promotions based on launch velocity |
| **Design investment** | Minimal; design happens incidentally during implementation |
| **Result** | Large codebase with significant complexity; Facebook eventually had to invest heavily in infrastructure to manage the mess |
| **Lesson** | Tactical culture produces speed early but creates compounding problems |

Note: Facebook later changed their motto because the approach became unsustainable at scale. The "break things" philosophy worked for a small team but created enormous costs as the organization grew.

### Google's Design Culture (Strategic Culture)

| Aspect | Details |
|--------|---------|
| **Emphasis** | Design quality, readability reviews, code health |
| **Incentive** | Readability reviewers, design documents for significant changes |
| **Design investment** | Substantial; design documents and reviews before implementation |
| **Result** | Engineers reported being more productive on complex systems; easier to understand and modify unfamiliar code |
| **Lesson** | Strategic culture costs more upfront but compounds into higher long-term productivity |

### The Lesson

Neither extreme is right for every organization. But the evidence suggests that investing in design produces better outcomes over any timeframe longer than a few weeks. The key is not to choose between speed and quality but to recognize that strategic design **is** the fastest path when measured over months, not days.

## When to Invest Strategically

### Always Invest When:

| Situation | Why |
|-----------|-----|
| **Designing a new module interface** | Interface decisions are the hardest to change later |
| **A module's complexity is growing** | Small interventions now prevent major rewrites later |
| **Onboarding new team members** | Clear abstractions and comments dramatically reduce ramp-up time |
| **Multiple teams will use the code** | Interface quality multiplies across consumers |
| **The code is on a critical path** | Complexity in critical paths causes production incidents |

### Accept Tactical Approach When:

| Situation | Why | Caveat |
|-----------|-----|--------|
| **True prototype/throwaway code** | Code that will genuinely be deleted | Be honest -- most "prototypes" ship to production |
| **Tight deadline with defined scope** | The tactical code will be immediately followed by a design pass | Actually schedule the design pass; put it on the calendar |
| **Exploring an unfamiliar domain** | You don't know enough to design well yet | Plan to redesign once you understand the domain |

The critical discipline: if you take a tactical shortcut, acknowledge the debt and plan to repay it. Don't pretend the shortcut has no cost.

## Practical Exercises

### Exercise 1: Interface Audit

Pick a module you work with frequently. For each public method:
1. Write the interface comment you wish existed
2. Compare it to the actual interface
3. Identify unnecessary parameters, missing defaults, and leaked implementation details
4. Propose a simpler interface that covers all current use cases

### Exercise 2: Complexity Budget

For your next feature:
1. Before starting, write down the current complexity of the affected modules (interface size, number of dependencies, known pain points)
2. After finishing, measure again
3. Goal: the feature adds functionality without increasing complexity, or even reduces it

### Exercise 3: Tactical Tornado Detection

Review the last 10 PRs on your team:
1. Which PRs added new parameters to existing interfaces?
2. Which PRs added special-case handling?
3. Which PRs included comments explaining design decisions?
4. Which PRs simplified existing code while adding new features?

PRs that score poorly on these questions may indicate tactical programming.

### Exercise 4: Design Review

For your next code review, add these questions:
1. Does this change make the system simpler or more complex?
2. Is the interface simpler than the implementation?
3. Is information properly hidden?
4. Are there interface comments that describe the abstraction?
5. Could any configuration parameters be eliminated?
6. Are there pass-through methods that should be merged?

## Summary

The strategic vs tactical distinction is ultimately about whether you view design as an investment or a cost. Tactical programmers see design as overhead that slows them down. Strategic programmers see design as an investment that speeds them up. The evidence -- from individual careers, team productivity, and company outcomes -- overwhelmingly favors the strategic approach. The 10-20% investment in design is the highest-return activity in software engineering.
