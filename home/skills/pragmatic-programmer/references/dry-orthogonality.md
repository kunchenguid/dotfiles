# DRY and Orthogonality

Deep reference for the two most foundational principles of pragmatic programming. Load when deeper guidance is needed on eliminating duplication and designing decoupled systems.

## Table of Contents
1. [DRY: Knowledge, Not Code](#dry-knowledge-not-code)
2. [The Four Types of Duplication](#the-four-types-of-duplication)
3. [Detecting DRY Violations](#detecting-dry-violations)
4. [Orthogonality Defined](#orthogonality-defined)
5. [Orthogonality in Design](#orthogonality-in-design)
6. [Orthogonality in Coding](#orthogonality-in-coding)
7. [Measuring Orthogonality](#measuring-orthogonality)
8. [Benefits of Orthogonal Systems](#benefits-of-orthogonal-systems)

---

## DRY: Knowledge, Not Code

The most common misunderstanding of DRY is treating it as "don't have similar-looking code." DRY is about **knowledge** -- every piece of knowledge must have a single, unambiguous, authoritative representation in the system.

### What Counts as Knowledge?

- **Business rules**: "Users get 3 free trials" should exist in one place
- **Data schemas**: The shape of a user record should be defined once
- **Algorithms**: A discount calculation should have one implementation
- **Configuration**: Database connection strings should come from one source
- **API contracts**: The interface between systems should be defined once

### What Does NOT Count as Duplication?

Two pieces of code may look identical but represent different knowledge:

```python
# These are NOT DRY violations -- they serve different business rules

def validate_billing_address(address):
    return len(address.zip_code) == 5

def validate_shipping_address(address):
    return len(address.zip_code) == 5
```

Today these look the same, but billing validation and shipping validation are governed by different business rules. When shipping starts supporting international addresses, they'll diverge. Merging them would create coupling between unrelated concepts.

**The test:** If one changes, must the other change? If yes, it's duplication. If they could diverge independently, it's coincidence.

---

## The Four Types of Duplication

### 1. Imposed Duplication

The environment or tooling forces duplication.

**Examples:**
- Language requires header files that repeat function signatures
- Multiple platforms need the same validation (iOS, Android, web)
- API documentation must match the implementation

**Mitigations:**
- Generate code from a single source (OpenAPI -> client + server + docs)
- Use code generation for cross-platform shared logic
- Keep documentation in code (docstrings, annotations) and generate external docs
- Use database migrations as the single source of schema truth

### 2. Inadvertent Duplication

Developers don't realize they're duplicating knowledge.

**Examples:**
- A `Line` class stores `start`, `end`, AND `length` -- length is derivable
- The same business rule exists in the frontend form validation and the backend API
- Configuration defaults are hard-coded in multiple services

**Mitigations:**
- Derive values instead of storing them: `@property def length(self): return self.end - self.start`
- Share validation schemas between frontend and backend (e.g., Zod, JSON Schema)
- Centralize configuration with a config service or shared env files

### 3. Impatient Duplication

"I'll clean it up later." Developers know they're duplicating but choose speed.

**Examples:**
- Copy-pasting a utility function into a new service instead of extracting a shared library
- Duplicating a SQL query with slight modifications instead of parameterizing
- Hardcoding a value that already exists in a config file

**Mitigations:**
- Make the right thing easy: invest in shared libraries, package registries, and templates
- Time-box the "right way" -- often it takes only 10 minutes more than copy-paste
- Code review: flag copy-paste duplication as a blocker, not a nit

### 4. Inter-Developer Duplication

Multiple developers or teams unknowingly build the same thing.

**Examples:**
- Two teams build their own date-formatting utility
- Three microservices each implement user authentication logic
- Frontend and backend teams both build a currency formatter

**Mitigations:**
- Establish shared libraries and make them discoverable (internal package registry)
- Regular cross-team architecture reviews
- Appoint a "librarian" or use a tech radar to track shared concerns
- Use a monorepo or shared packages to make duplication visible

---

## Detecting DRY Violations

### Code-Level Signals

| Signal | What It Suggests |
|--------|-----------------|
| Shotgun surgery (changing one thing requires touching 5+ files) | Knowledge is scattered |
| "Find and replace" is your refactoring strategy | Same knowledge in multiple places |
| Bug fix in one place doesn't fix it everywhere | Duplicated logic |
| New developer asks "which one is the real one?" | Multiple sources of truth |
| Enum values are defined in both code and database | Schema duplication |

### Architecture-Level Signals

| Signal | What It Suggests |
|--------|-----------------|
| Multiple services validate the same business rule differently | Inter-service duplication |
| Config values are hard-coded in multiple deployment scripts | Imposed duplication |
| API documentation regularly drifts from implementation | Docs/code duplication |
| "We need to update this in 3 places" | Knowledge not centralized |

---

## Orthogonality Defined

In geometry, orthogonal lines meet at right angles -- moving along one axis doesn't affect your position on the other. In software, two components are orthogonal if changes in one have no effect on the other.

**The helicopter analogy:** A traditional helicopter has four controls, all coupled -- changing collective pitch affects yaw, which requires compensating with the tail rotor, which changes roll. Flying a helicopter is hard because nothing is orthogonal. Good software should be the opposite: each control affects exactly one thing.

---

## Orthogonality in Design

### Layered Architecture

The most common way to achieve orthogonality is through layers:

```
┌─────────────────────┐
│   Presentation      │  (UI, API endpoints, CLI)
├─────────────────────┤
│   Application       │  (Use cases, workflows)
├─────────────────────┤
│   Domain            │  (Business rules, entities)
├─────────────────────┤
│   Infrastructure    │  (DB, external APIs, filesystem)
└─────────────────────┘
```

**Test:** If you dramatically change the UI framework, how many layers need to change? Ideally, only the presentation layer. If domain logic lives in UI components, you have a coupling problem.

### Component Independence Checklist

| Question | Good Answer |
|----------|-------------|
| Can I test this component in isolation? | Yes, with mocked dependencies |
| If I remove this component, what breaks? | Only things that directly depend on it |
| Does this component know about the deployment environment? | No, it receives config via injection |
| Can two developers work on separate components without conflicts? | Yes, interfaces are stable |
| Does this component import from more than one architectural layer? | No, it depends only on the layer below |

---

## Orthogonality in Coding

### Strategies for Keeping Code Orthogonal

**1. Avoid global state.** Every piece of global state is a coupling point. Every module that reads or writes it is coupled to every other module that does the same.

```python
# Bad: global coupling
CURRENT_USER = None  # every module reads/writes this

# Good: explicit parameter
def process_order(order, user):
    ...
```

**2. Avoid similar functions.** If two functions share significant structure, extract the commonality into a third function and have both call it.

**3. Use the Shy Code rule.** Modules should not reveal anything unnecessary about themselves and should not rely on the implementation details of other modules.

```python
# Bad: reaching through objects (Law of Demeter violation)
user.address.city.zip_code

# Good: ask, don't tell
user.shipping_zip_code()
```

**4. Prefer composition over inheritance.** Inheritance creates tight coupling between parent and child. Composition (using interfaces and delegation) keeps components independent.

```python
# Inheritance: tightly coupled
class AdminUser(User):
    def can_delete(self): return True

# Composition: loosely coupled
class User:
    def __init__(self, permissions: Permissions):
        self.permissions = permissions
    def can_delete(self):
        return self.permissions.allows("delete")
```

---

## Measuring Orthogonality

### The Change Impact Test

For any proposed change, count the number of modules affected:

| Change Scope | Modules Affected | Assessment |
|-------------|------------------|------------|
| Fix a bug in tax calculation | 1 (tax module) | Excellent orthogonality |
| Change database from Postgres to MySQL | 1-2 (data layer) | Good orthogonality |
| Add a new field to user profile | 3-5 (model, API, UI, migration, tests) | Acceptable (vertical feature) |
| Change the logging library | 15+ modules | Poor orthogonality -- logging is coupled everywhere |

### The "Stranger" Test

Could a developer unfamiliar with the codebase change one component without breaking others? If yes, your system is orthogonal. If they need to understand the full system to make any change, it is not.

---

## Benefits of Orthogonal Systems

### Productivity Gains

- **Changes are localized:** fixing a bug in one component doesn't cause regressions elsewhere
- **Reuse is easier:** self-contained components can be extracted and used in other projects
- **Parallel development:** teams can work independently on different components
- **Testing is simpler:** unit tests cover isolated components without elaborate setup

### Risk Reduction

- **Diseased sections are isolated:** a poorly-written module doesn't infect neighboring code
- **Less fragile:** the system doesn't shatter when one thing changes
- **Better tested:** orthogonal components are inherently easier to test, so they get tested more
- **Not tied to a vendor:** when the database is behind an interface, switching vendors is a bounded task

### The Compound Effect

Orthogonality and DRY are multiplicative. A system that is both DRY and orthogonal sees dramatic improvements:

| Property | Without DRY/Orthogonality | With Both |
|----------|--------------------------|-----------|
| Bug fix time | Hours (find all duplicates, test all couplings) | Minutes (one change, one test) |
| Feature addition | High risk of regressions | Localized, predictable impact |
| Onboarding time | Weeks to understand dependencies | Days to become productive |
| Deployment confidence | "Deploy and pray" | "Deploy and verify" |

The pragmatic programmer pursues both relentlessly -- not for theoretical purity, but because the compound effect saves enormous amounts of time and pain over the life of a project.
