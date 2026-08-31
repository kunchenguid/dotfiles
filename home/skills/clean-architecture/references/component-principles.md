# Component Principles

Components are the units of deployment -- the smallest entities that can be independently deployed. In Java they are jar files, in Ruby they are gems, in .NET they are DLLs, in JavaScript they are npm packages or bundled modules. Robert C. Martin defines six principles that govern how classes should be grouped into components (cohesion) and how components should relate to each other (coupling).

This reference covers the three cohesion principles (REP, CCP, CRP), the three coupling principles (ADP, SDP, SAP), practical application of stability and abstractness metrics, and strategies for managing component dependencies.

## Component Cohesion: What Goes Inside a Component

### REP: The Reuse/Release Equivalence Principle

**"The granule of reuse is the granule of release."**

Classes and modules that are grouped into a component should be releasable together. If you version and release a component, every class in it should make sense as part of that release. A component should have a cohesive theme -- a reason for being grouped.

**Why it matters:**
- Users of a component expect that when they upgrade to a new version, all classes in the component have been updated coherently
- If a component contains unrelated classes, users are forced to upgrade for changes they don't care about
- A component without a coherent theme is difficult to document, understand, and maintain

**Practical implications:**
- A component named `order-domain` should contain `Order`, `OrderItem`, `OrderStatus`, `OrderPolicy` -- all cohesively related to order business rules
- It should NOT also contain `UserPreferences` or `EmailTemplate` just because they happen to be used nearby
- When you can't write a one-sentence description of what the component does, it probably violates REP

### CCP: The Common Closure Principle

**"Gather into components those classes that change for the same reasons and at the same times. Separate into different components those classes that change at different times and for different reasons."**

This is the Single Responsibility Principle applied at the component level. A component should not have multiple reasons to change.

**Why it matters:**
- When a change in business requirements affects multiple classes, ideally all those classes are in the same component
- This means only one component needs to be redeployed rather than many
- Minimizes the ripple effect of changes across the deployment landscape

**Practical application:**

| Change Reason | Group Together | Separate From |
|---------------|---------------|---------------|
| Order pricing rules change | `OrderCalculator`, `DiscountPolicy`, `TaxCalculator` | `OrderController`, `OrderRepository` |
| Database schema changes | `OrderMapper`, `OrderRepository`, `OrderMigration` | `Order`, `OrderCalculator` |
| API response format changes | `OrderPresenter`, `OrderSerializer`, `OrderViewModel` | `Order`, `OrderService` |
| Authentication rules change | `AuthPolicy`, `TokenValidator`, `SessionManager` | `OrderService`, `PaymentService` |

**The key question:** "When this business rule changes, which classes will I need to modify?" Group those classes together.

### CRP: The Common Reuse Principle

**"Don't force users of a component to depend on things they don't need."**

Classes in a component should be tightly related. If you depend on one class in a component, you should depend on most (ideally all) classes in that component. If you only use one class out of twenty, the component is too broad.

**Why it matters:**
- When a component changes, all components that depend on it must be revalidated and potentially redeployed
- If Component A depends on Component B but only uses one class, changes to unrelated classes in B still force A to be revalidated
- Fat components create unnecessary coupling

**Practical test:** For each class in a component, ask: "If I remove this class, would users of this component notice?" If they wouldn't, the class may belong elsewhere.

### The Tension Triangle

REP, CCP, and CRP are in tension with each other:

```
         REP
        /    \
      /        \
    CCP ------- CRP
```

- **REP + CCP** push toward larger components (group things that are released and changed together)
- **CRP** pushes toward smaller components (don't include things that aren't used together)
- **Early in development:** Favor CCP (minimize redeployment cost as code churns)
- **As the system matures:** Shift toward CRP (minimize unnecessary coupling as the system stabilizes)

A component's composition typically evolves over time, starting broad (CCP-oriented) and narrowing (CRP-oriented) as the system matures.

## Component Coupling: Relationships Between Components

### ADP: The Acyclic Dependencies Principle

**"Allow no cycles in the component dependency graph."**

The dependency graph of components must be a Directed Acyclic Graph (DAG). If Component A depends on B, and B depends on C, and C depends on A, you have a cycle -- and the three components are effectively one undivisible monolith.

**Why cycles are destructive:**
- Cycles make independent release impossible -- you can't release A without releasing B and C
- Changes in any component in the cycle potentially affect all others
- Build order becomes ambiguous or impossible
- Testing requires all components in the cycle to be present

**Detecting cycles:**

```
A --> B --> C --> A    (CYCLE: A, B, C are effectively one component)

A --> B --> C          (NO CYCLE: DAG)
      |         ^
      v         |
      D --------/
```

**Breaking cycles -- two strategies:**

**Strategy 1: Apply the Dependency Inversion Principle**

If B depends on A and A depends on B (cycle), extract an interface:

```
Before (cycle):
  A <--> B

After (no cycle):
  A --> InterfaceX <-- B
```

A defines `InterfaceX`. B implements it. Now A depends on nothing new; B depends on `InterfaceX` (which lives with A). The cycle is broken.

**Strategy 2: Extract a new component**

Move the shared dependency into a new component that both A and B depend on:

```
Before (cycle):
  A <--> B

After (no cycle):
  A --> C <-- B
```

C contains the shared classes. Both A and B depend on C. Neither depends on the other.

### SDP: The Stable Dependencies Principle

**"Depend in the direction of stability."**

A component should only depend on components that are more stable than it is. Stability here means "difficulty of change" -- a component is stable if many other components depend on it (making it hard to change without breaking things).

**Measuring stability:**

- **Fan-in (Ca):** Number of classes outside the component that depend on classes inside the component (incoming dependencies)
- **Fan-out (Ce):** Number of classes inside the component that depend on classes outside the component (outgoing dependencies)
- **Instability (I):** I = Ce / (Ca + Ce), where I ranges from 0 (maximally stable) to 1 (maximally unstable)

| Metric Value | Meaning | Implication |
|-------------|---------|-------------|
| I = 0 | Maximally stable (many dependents, no dependencies) | Hard to change; should be abstract |
| I = 1 | Maximally unstable (no dependents, many dependencies) | Easy to change; should be concrete |
| I = 0.5 | Balanced | Moderate change risk |

**The SDP rule:** If Component A depends on Component B, then I(B) should be less than or equal to I(A). You should depend on things that are harder to change than you are.

**Violation example:**
If a highly stable component (I=0.1, many dependents) depends on a highly unstable component (I=0.9, few dependents), the unstable component's frequent changes will destabilize all the stable component's dependents.

### SAP: The Stable Abstractions Principle

**"A component should be as abstract as it is stable."**

Stable components (hard to change) should be abstract (contain mostly interfaces and abstract classes). This way, their stability does not prevent them from being extended. Unstable components (easy to change) should be concrete, containing the implementations that change frequently.

**Measuring abstractness:**

- **Nc:** Number of classes in the component
- **Na:** Number of abstract classes and interfaces in the component
- **Abstractness (A):** A = Na / Nc, where A ranges from 0 (fully concrete) to 1 (fully abstract)

### The Main Sequence

Plot each component on a graph with Instability (I) on the x-axis and Abstractness (A) on the y-axis. The ideal line runs from (0,1) to (1,0) -- the "Main Sequence."

```
A (Abstractness)
1 |  * Zone of Uselessness
  |    \
  |      \  <-- Main Sequence
  |        \
  |          \
0 |____________* Zone of Pain
  0          1
    I (Instability)
```

**Zone of Pain (I=0, A=0):** Maximally stable AND maximally concrete. Very hard to change but contains no abstractions for extension. Examples: database schemas, concrete utility libraries that everyone depends on. Painful to modify.

**Zone of Uselessness (I=1, A=1):** Maximally unstable AND maximally abstract. No one depends on these abstract interfaces. They serve no purpose. Dead code.

**The Main Sequence:** Components should fall near the line from (0,1) to (1,0). Stable components should be abstract. Unstable components should be concrete.

**Distance from the Main Sequence:**
D = |A + I - 1|, where D ranges from 0 (on the line) to ~0.7 (in a zone).

Components with high D values warrant investigation.

## Practical Component Design

### Component Mapping to Clean Architecture

| Clean Architecture Circle | Stability | Abstractness | Character |
|--------------------------|-----------|-------------|-----------|
| **Entities** | Very stable (I near 0) | Abstract (interfaces, domain types) | Core business rules; many dependents |
| **Use Cases** | Stable (I = 0.2-0.4) | Moderately abstract (ports, interactors) | Application rules; depend on entities |
| **Adapters** | Unstable (I = 0.5-0.7) | Concrete (controllers, gateways) | Translation layer; depend on use cases |
| **Frameworks** | Very unstable (I near 1) | Concrete (configuration, wiring) | Glue code; depend on everything |

### Versioning Components Independently

When components are properly decoupled:
- Each can have its own version number
- Each can be released on its own schedule
- Teams can own components independently
- Breaking changes in one component can be managed through interface versioning

### Component Design Workflow

1. **Start with CCP:** Group classes by reason for change. Don't worry about component size.
2. **Apply CRP:** Remove classes that aren't used together. Split components that force unnecessary dependencies.
3. **Check REP:** Ensure each component has a coherent theme and can be meaningfully versioned.
4. **Graph dependencies:** Draw the component dependency graph. Look for cycles.
5. **Break cycles (ADP):** Use DIP or extraction to eliminate every cycle.
6. **Check stability direction (SDP):** Ensure dependencies flow toward stability.
7. **Balance abstraction (SAP):** Make stable components abstract; make unstable components concrete.
8. **Measure D:** Plot components on the I/A graph. Investigate those far from the Main Sequence.

### Common Component Anti-Patterns

| Anti-Pattern | Symptom | Fix |
|-------------|---------|-----|
| **God component** | One component contains everything | Split by CCP: group by reason for change |
| **Circular dependencies** | Can't release or build independently | Apply ADP: DIP or extraction |
| **Concrete stable component** | Many dependents, no abstractions, painful to change | Apply SAP: extract interfaces, move implementations to unstable components |
| **Unstable abstractions** | Abstract component with no dependents | Remove dead abstractions or rethink dependency structure |
| **Shotgun releases** | Changing one feature requires releasing five components | Apply CCP: group co-changing classes together |
| **Dependency magnet** | One utility component everyone depends on | Split into focused components; apply CRP |

### Dependency Analysis Tools

| Language | Tool | Purpose |
|----------|------|---------|
| Java | JDepend, ArchUnit | Measure component metrics, enforce dependency rules |
| JavaScript/TypeScript | Dependency Cruiser, Madge | Visualize and validate module dependencies |
| Python | import-linter, pydeps | Enforce import rules, visualize package dependencies |
| .NET | NDepend | Component metrics, dependency analysis |
| Go | `go vet`, custom linters | Package dependency validation |
| General | SonarQube | Cross-language dependency and quality analysis |

These tools automate the detection of cycles, stability violations, and components in the Zone of Pain or Zone of Uselessness. Integrate them into CI/CD pipelines to prevent architectural drift.
