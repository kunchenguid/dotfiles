# Tracer Bullets and Prototypes

Deep reference for two distinct approaches to uncertainty: tracer bullets (keep the code) and prototypes (throw it away). Load when guidance is needed on which approach to use and how to execute each.

## Table of Contents
1. [The Tracer Bullet Metaphor](#the-tracer-bullet-metaphor)
2. [Tracer Bullet Development](#tracer-bullet-development)
3. [Prototyping](#prototyping)
4. [Tracer Bullets vs. Prototypes](#tracer-bullets-vs-prototypes)
5. [Shooting in the Dark](#shooting-in-the-dark)
6. [Iterating on Tracer Code](#iterating-on-tracer-code)
7. [Walking Skeletons](#walking-skeletons)
8. [Common Pitfalls](#common-pitfalls)

---

## The Tracer Bullet Metaphor

In military usage, tracer bullets are loaded at regular intervals alongside regular ammunition. When fired in the dark, they leave a visible trail showing the path of fire. If the tracer misses, you adjust your aim and fire again. The feedback loop is immediate.

In software, tracer bullet development serves the same purpose: you build something thin but real that travels through all the layers of the system, giving you immediate feedback on whether you're hitting the target.

---

## Tracer Bullet Development

### What It Is

A tracer bullet is a thin, end-to-end implementation that connects all the major components of the system. It is **production code** -- not throwaway. It may be minimal, but it is real.

### Characteristics of Tracer Bullet Code

| Property | Description |
|----------|-------------|
| **End-to-end** | Touches every layer: UI, API, business logic, data store |
| **Functional** | Actually works, even if only for one scenario |
| **Production quality** | Written with proper error handling, tests, and structure |
| **Incomplete** | Handles one path through the system, not all edge cases |
| **Extensible** | Built as a framework that other features can fill in |

### Example: Building a New Web Application

Instead of building the full database schema, then all the API endpoints, then the full UI, a tracer bullet approach:

1. **Pick one feature** (e.g., "user creates an account")
2. **Build the UI** -- a single form with email and password
3. **Build the API** -- one `POST /users` endpoint
4. **Build the data layer** -- one `users` table with two columns
5. **Connect them** -- form submits to API, API writes to DB, response confirms success
6. **Deploy** -- to the real production environment (or staging)

You now have a working system. It only does one thing, but all the layers are connected, the deployment pipeline works, and you can see the real behavior. Every subsequent feature fills in more of the skeleton.

### When to Use Tracer Bullets

- Requirements are vague or rapidly changing
- You're using a new technology stack you haven't worked with before
- The architecture involves multiple integrated components (services, queues, databases)
- Stakeholders need to see something real early
- You want to validate that all the pieces connect before investing in each individually

---

## Prototyping

### What It Is

A prototype is a focused investigation of one specific aspect of the system. Unlike tracer bullets, prototypes are **disposable** -- they are built to learn, not to keep.

### What to Prototype

| Aspect | Question It Answers |
|--------|-------------------|
| **Algorithm** | Is this approach fast enough? Does it produce correct results? |
| **UI/UX** | Does this interaction model make sense to users? |
| **Architecture** | Can these components communicate at the required scale? |
| **Third-party tool** | Does this library/service meet our requirements? |
| **Performance** | Can this database handle our query patterns at load? |

### Characteristics of Prototype Code

| Property | Description |
|----------|-------------|
| **Focused** | Explores one question, ignores everything else |
| **Incomplete** | No error handling, no edge cases, no tests |
| **Disposable** | Will be thrown away -- this must be explicit and agreed upon |
| **Fast** | Built to answer a question quickly, not to last |
| **Unrestricted** | Can use any language, tool, or shortcut |

### What to Ignore When Prototyping

When building a prototype, you can and should ignore:

- **Correctness:** Dummy data and hard-coded values are fine
- **Completeness:** Handle the happy path only
- **Robustness:** No error handling or recovery
- **Style:** No need for clean code, proper naming, or documentation
- **Performance:** Unless performance IS the question being investigated

### Example: Prototyping a Recommendation Engine

Before building a real recommendation system, prototype:

```python
# PROTOTYPE - DO NOT SHIP
# Question: Does collaborative filtering produce useful recommendations
# from our dataset?

import pandas as pd
from scipy.sparse import csr_matrix
from sklearn.neighbors import NearestNeighbors

# Load raw data (no proper ETL pipeline)
df = pd.read_csv("raw_purchases.csv")

# Quick and dirty pivot
matrix = df.pivot(index='user_id', columns='product_id', values='purchased').fillna(0)

# Fit nearest neighbors
model = NearestNeighbors(metric='cosine')
model.fit(csr_matrix(matrix.values))

# Test with one user
distances, indices = model.kneighbors(matrix.iloc[0:1], n_neighbors=5)
print("Similar users:", indices)
print("Their top products:", matrix.iloc[indices[0]].sum().nlargest(10))
```

This prototype answers: "Does collaborative filtering work with our data?" The code is not production-quality and should never ship. But the *learning* it produces guides the real implementation.

---

## Tracer Bullets vs. Prototypes

This is the critical distinction:

| Aspect | Tracer Bullet | Prototype |
|--------|--------------|-----------|
| **Purpose** | Build the real framework, thin but complete | Explore a specific risk or question |
| **Code quality** | Production quality | Throwaway quality |
| **Scope** | End-to-end across all layers | Focused on one aspect or component |
| **After completion** | Keep and extend | Throw away completely |
| **Team visibility** | Shows real progress | Shows research findings |
| **Risk addressed** | Integration risk, architectural unknowns | Technical feasibility, design questions |
| **Deliverable** | Working (minimal) system | Knowledge and a decision |

### Decision Guide

```
Is the question about whether the pieces fit together?
  → Tracer Bullet

Is the question about whether one piece works at all?
  → Prototype

Are you building a new feature in an existing system?
  → Tracer Bullet (add the feature end-to-end, then iterate)

Are you evaluating a new technology or algorithm?
  → Prototype (test it in isolation, then decide)

Do stakeholders need to see/use something?
  → Tracer Bullet (it's real, they can interact with it)

Do you need to answer a technical question quickly?
  → Prototype (optimize for speed of learning)
```

---

## Shooting in the Dark

Tracer bullets are most valuable when you can't see the target clearly:

### Unclear Requirements

Users say "I want a dashboard." What does that mean? Build a tracer: one chart, one data source, deployed and accessible. Show it to users. Their reaction tells you more than any requirements document.

### New Technology Stack

Team is adopting Rust for the first time. Don't spend three months building the data layer in isolation. Build a tracer: one request, from HTTP endpoint through business logic to database response, in Rust. You'll discover the pain points (borrow checker, async runtime, ORM maturity) immediately.

### Complex Integration

Your system needs to coordinate five microservices, two queues, and a third-party API. Build a tracer: one transaction that flows through all of them. Integration problems surface immediately, not three months into development.

---

## Iterating on Tracer Code

When a tracer bullet misses the target (stakeholders don't like what they see, performance is wrong, the architecture doesn't work), you adjust and fire again:

### The Iteration Cycle

1. **Build** -- thin end-to-end implementation
2. **Show** -- demonstrate to stakeholders and the team
3. **Learn** -- collect feedback, observe behavior, measure performance
4. **Adjust** -- modify the implementation based on learnings
5. **Repeat** -- fire again with improved aim

### What "Missing" Looks Like

| Miss Type | Symptom | Adjustment |
|-----------|---------|------------|
| Wrong feature | Users don't use it | Pivot to a different feature |
| Wrong UX | Users are confused | Redesign the interaction model |
| Wrong architecture | Performance is unacceptable | Restructure the layers |
| Wrong technology | Library doesn't scale | Swap the component (orthogonality helps here) |
| Wrong integration | Services don't coordinate well | Redesign the communication pattern |

The cost of each adjustment is low because you only built a thin slice. Compare this to building the full system and discovering at the end that the architecture is wrong.

---

## Walking Skeletons

A walking skeleton is a special case of tracer bullet development applied to the project's infrastructure:

### What It Includes

- Source control repository setup
- Build pipeline (compile, lint, test)
- Deployment pipeline (staging, production)
- Monitoring and logging
- One trivial feature (health check endpoint, hello world page)

### Why It Matters

The walking skeleton proves that your entire delivery pipeline works before you write any real features. This is enormously valuable because:

- Infrastructure problems are the most painful to fix when discovered late
- CI/CD pipeline issues block the entire team
- Deployment automation is complex and error-prone
- Monitoring gaps are invisible until production incidents

### Walking Skeleton Checklist

| Component | Verification |
|-----------|-------------|
| Source control | Code is tracked, branches work, PRs are reviewed |
| Build | `make build` (or equivalent) produces an artifact |
| Unit tests | `make test` runs and passes (even with one trivial test) |
| Integration tests | At least one test hits a real dependency |
| Linting | Code style is enforced automatically |
| Staging deploy | One command deploys to a staging environment |
| Production deploy | Same pipeline deploys to production |
| Monitoring | Logs are collected, metrics are reported |
| Alerting | At least one alert fires on failure (health check) |

---

## Common Pitfalls

### Pitfall 1: Prototype Becomes Production

The most dangerous mistake. A prototype is built quickly, stakeholders see it, love it, and demand it ship. The throwaway code becomes permanent.

**Prevention:**
- Write "PROTOTYPE - NOT FOR PRODUCTION" in the README, code comments, and PR description
- Use a different repository or branch for prototypes
- Present findings, not the code -- show screenshots, not live demos when possible
- Make it ugly on purpose -- if it looks polished, people will want to ship it

### Pitfall 2: Tracer Bullet Becomes Big Design Up Front

Teams sometimes use "tracer bullet" as justification for spending months on architecture before writing any features.

**Prevention:** A true tracer bullet should be deployable within days, not weeks. If it's taking longer, you're building too much. Narrow the scope to the thinnest possible slice.

### Pitfall 3: Confusing the Two Approaches

Using tracer bullet code quality for a prototype (wasting time on production quality for throwaway code) or prototype quality for a tracer bullet (shipping hack code as the foundation of the system).

**Prevention:** Decide upfront which approach you're using and communicate it clearly to the team. The choice determines code quality expectations, review standards, and what happens to the code afterward.

### Pitfall 4: Never Iterating on the Tracer

Building a tracer bullet and then treating it as the final architecture. The whole point is to iterate -- if you're not adjusting based on feedback, you're not using the technique correctly.

**Prevention:** Plan for at least 2-3 iterations. Budget time for adjustment after each demonstration. Expect the first tracer to miss.
