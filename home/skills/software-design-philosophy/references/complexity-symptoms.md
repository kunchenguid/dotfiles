# Complexity: Symptoms, Causes, and Measurement

The single greatest challenge in software engineering is managing complexity. This reference details how to recognize complexity, understand its causes, and measure it informally to guide design decisions.

## Definition of Complexity

Complexity is anything related to the structure of a software system that makes it hard to understand and modify. It is not about the size of the system or the sophistication of its features. A large system with clean abstractions can be less complex than a small system with tangled dependencies.

Ousterhout defines it with a practical formula:

```
C = sum(cp * tp) for each part p
```

Where:
- `cp` is the complexity of part `p`
- `tp` is the fraction of time developers spend working on part `p`

A module that is extremely complex but never touched contributes little overall complexity. A module that is moderately complex but modified constantly dominates the system's effective complexity.

## The Three Symptoms of Complexity

### 1. Change Amplification

**Definition:** A seemingly simple change requires modifications in many different places.

**How to recognize it:**
- Adding a new field to a data model requires changes in 8+ files
- Changing a color scheme means updating dozens of components
- Adding a new API endpoint requires modifications in routing, validation, serialization, testing, and documentation files that all repeat similar patterns

**Examples:**

| Symptom | Root Cause | Better Design |
|---------|-----------|---------------|
| Adding a database column touches 12 files | Schema knowledge is scattered across ORM, API, serialization, validation layers | Use a single source of truth for schema that generates other artifacts |
| Changing error message format requires editing every handler | Error formatting is duplicated in each endpoint | Centralize error formatting in middleware |
| Adding a new event type requires changes in producer, consumer, schema, and 3 processors | Event structure knowledge is not encapsulated | Define event schemas in one place; processors discover structure from schema |
| Renaming a field touches API, database, frontend, tests | The same concept is named differently in each layer | Use consistent naming conventions and code generation where possible |

**The test:** Ask "If I need to make this change, how many files do I need to touch?" If the answer is more than 2-3 for a conceptually simple change, you have change amplification.

### 2. Cognitive Load

**Definition:** A developer must know too much to complete a task safely.

**How to recognize it:**
- You need to read 5 files to understand what one function does
- A function has 8 parameters, each with non-obvious constraints
- Understanding the order of operations requires knowing implementation details of 3 other modules
- Global state means any function could have side effects that affect your code

**Examples:**

| Symptom | Root Cause | Better Design |
|---------|-----------|---------------|
| Must understand memory allocation to use an API | Interface leaks implementation details | Hide allocation behind the API; manage memory internally |
| Must configure 6 parameters before calling a function | Module pushes decisions to callers | Provide sensible defaults; auto-detect where possible |
| Must hold 4 invariants in mind when modifying a data structure | Invariants are not enforced by the module | Encapsulate invariants inside the module; enforce them automatically |
| Must read all callers before changing a shared utility | Utility has implicit contracts with each caller | Define explicit interfaces; use type systems to enforce contracts |

**The test:** Ask "How much does a developer need to know to use this module correctly?" If the answer involves understanding the implementation, the interface is too complex.

**Important nuance:** Lines of code can be misleading. An approach with more lines but less cognitive load is preferable. A 10-line function that requires understanding 5 external systems is more complex than a 30-line function that is self-contained.

### 3. Unknown Unknowns

**Definition:** It is not obvious which pieces of code must be changed, or what information is needed to make a change. This is the worst symptom because you don't even know what you don't know.

**How to recognize it:**
- A change seems to work in testing but breaks something unrelated in production
- A developer makes a reasonable change but violates an undocumented assumption
- The only way to learn about a constraint is to break it
- Knowledge exists only in one developer's head

**Examples:**

| Symptom | Root Cause | Better Design |
|---------|-----------|---------------|
| Changing module A breaks module C through a hidden dependency via B | Implicit dependency chain | Make dependencies explicit through interfaces and type systems |
| A race condition only surfaces under load | Concurrency assumptions are undocumented | Document threading model; use constructs that make concurrency visible |
| Reordering initialization steps causes silent data corruption | Initialization order dependency is implicit | Make ordering explicit through dependency injection or builder patterns |
| Modifying a "private" helper breaks an external system that depends on its behavior | Internal implementation has undocumented external consumers | Define clear public APIs; use access control to enforce boundaries |

**The test:** Ask "Can a new developer make changes to this module confidently without talking to someone?" If the answer is no, you have unknown unknowns.

## The Two Causes of Complexity

### Dependencies

A dependency exists when code cannot be understood or modified in isolation -- the code relates to other code in some way.

**Types of dependencies:**

| Type | Description | Example |
|------|-------------|---------|
| **Syntactic** | Compiler/linter will catch if broken | Function signature changes; import errors |
| **Semantic** | Compiler cannot catch; behavior depends on understanding | Two modules must agree on a data format not enforced by types |
| **Temporal** | Code must execute in a specific order | Init must happen before use; close must happen after all writes |
| **Hidden** | No visible indication of the relationship | Module A's behavior depends on global state set by module B |

**Goal:** You cannot eliminate dependencies entirely (software is interconnected), but you can:
1. Minimize the number of dependencies
2. Make remaining dependencies obvious and simple
3. Prefer syntactic dependencies over semantic ones (the compiler helps you)

### Obscurity

Obscurity occurs when important information is not obvious.

**Common sources:**

- Generic variable names: `data`, `temp`, `result`, `info`, `manager`
- Inconsistent naming: the same concept called `user` in one module and `account` in another
- Missing documentation: no explanation of why a design decision was made
- Non-obvious side effects: a function named `getUser()` that also updates a cache
- Magic numbers: `if retries > 3` without explaining why 3
- Implicit conventions: "All timestamps are UTC" but it is never stated

**The fix:** Make things obvious through:
1. Precise naming that conveys meaning
2. Comments that explain why, not what
3. Consistent conventions applied everywhere
4. Type systems that encode constraints
5. Explicit rather than implicit behavior

## Complexity Is Incremental

This is one of Ousterhout's most important observations: complexity rarely arrives as a single large problem. Instead, it accumulates from hundreds of small decisions.

**The pattern:**
1. A developer takes a small shortcut: "This one special case won't matter"
2. Another developer adds a small workaround: "It's just one extra parameter"
3. A third developer duplicates some logic: "Refactoring would take too long right now"
4. After a year, the system is difficult to work with, but no single change caused it

**Why this matters:**
- There is no single big fix for incremental complexity
- You cannot "refactor away" complexity in a weekend -- it must be managed continuously
- Every small decision matters: each shortcut contributes its small fraction
- The "broken windows" effect applies: once a module is messy, developers stop trying to keep it clean

**The discipline:**
- Adopt a zero-tolerance policy for complexity growth
- Every PR should leave the code at least as clean as it found it
- Small design improvements in every change compound into a great codebase over time
- Think of complexity like financial debt: each shortcut is a small loan with interest

## Measuring Complexity Informally

There is no precise metric for complexity, but you can measure it through proxies:

### Developer Experience Questions

| Question | Good Answer | Bad Answer |
|----------|------------|------------|
| "How long does it take a new team member to make their first meaningful change?" | Days | Weeks or months |
| "When you make a change, how confident are you that nothing else breaks?" | Very confident | Nervous; need extensive testing |
| "How many files do you typically touch for a feature?" | 1-3 | 5+ |
| "Can you explain what module X does in one sentence?" | Yes, clearly | It does... a lot of things |
| "When was the last time a change had unexpected side effects?" | Rarely | Last week |

### Code-Level Signals

| Signal | Low Complexity | High Complexity |
|--------|---------------|-----------------|
| Interface size (parameters, methods) | Few, cohesive | Many, unrelated |
| Module size | Varies (depth matters more) | Very large with intertwined concerns |
| Change locality | Changes are local to 1-2 modules | Changes ripple across many modules |
| Test fragility | Tests break only when behavior changes | Tests break when implementations change |
| Onboarding time | New developers productive in days | New developers need weeks of mentoring |

### The "What Is the Simplest Interface?" Test

For any module, ask: "What is the simplest interface that would meet all the current use cases?"

Compare the current interface to this ideal:
- If they match, the module is well-designed
- If the current interface is significantly more complex, there is unnecessary complexity
- If you cannot define a simple interface, the module may be doing too much

## Red Flags for Complexity

Ousterhout identifies several "red flags" -- patterns that signal complexity problems:

| Red Flag | What It Signals |
|----------|----------------|
| Shallow module | Interface is not much simpler than implementation |
| Information leakage | Same knowledge in multiple modules |
| Temporal decomposition | Modules split by time rather than knowledge |
| Overexposure | API exposes internal state that callers shouldn't need |
| Pass-through method | Method does nothing except call another method with same arguments |
| Repetition | Same code pattern appears in multiple places |
| Special-general mixture | General-purpose module has special-case code for specific callers |
| Conjoined methods | You can't understand method A without reading method B |
| Comment repeats code | Comment says the same thing as the code, adding no information |
| Vague name | Name does not convey what the thing does |

## Applying the Framework

When designing a new module or reviewing existing code:

1. **Identify the symptoms:** Is there change amplification? Cognitive load? Unknown unknowns?
2. **Trace the causes:** Are there unnecessary dependencies? Is important information obscure?
3. **Apply the simplest interface test:** What is the simplest interface that meets current needs?
4. **Check for red flags:** Does the design exhibit any of the patterns above?
5. **Decide on action:** Does the complexity warrant a redesign, or is it manageable?

The goal is not perfection but continuous improvement. Each design decision that reduces complexity, even slightly, contributes to a system that remains manageable over time.
