# Bounded Contexts and Context Mapping

A bounded context is the most important strategic pattern in Domain-Driven Design. It defines an explicit boundary within which a particular domain model is defined, consistent, and applicable. Context mapping describes the relationships between bounded contexts and the strategies for translating between them.

## What Is a Bounded Context?

A bounded context is not a module, a microservice, or a deployment unit -- though it may coincide with any of these. It is a linguistic boundary: within this boundary, every term has a single, precise meaning, and the model is internally consistent.

### The Problem It Solves

In any system of sufficient size, the same word means different things to different people:

| Term | In Sales Context | In Shipping Context | In Billing Context |
|------|-----------------|--------------------|--------------------|
| Customer | A prospect or account with contact info and purchase history | A delivery address with receiving instructions | A billing entity with payment methods and credit terms |
| Product | A catalog item with descriptions, images, and pricing tiers | A physical item with weight, dimensions, and handling requirements | A line item with a price, tax category, and discount rules |
| Order | A quote or deal being negotiated | A shipment to be picked, packed, and dispatched | An invoice to be generated and collected |

Trying to create a single `Customer` class that serves all three contexts produces a bloated, contradictory monstrosity with dozens of fields, most of which are irrelevant in any given use case. The bounded context pattern says: stop fighting this. Let each context have its own `Customer` model, optimized for its own needs.

### Identifying Bounded Context Boundaries

Boundaries emerge from several signals:

**Linguistic signals:**
- When the same term means different things to different groups, those groups are in different contexts
- When conversations between groups require "translation" ("when you say X, do you mean Y?"), there is a boundary
- When a concept exists in one group but has no analog in another, the boundary is clear

**Organizational signals:**
- Different teams owning different parts of the system
- Different departments with different processes and vocabulary
- Different regulatory requirements (e.g., PCI compliance for payments vs. HIPAA for patient data)

**Technical signals:**
- Different data storage needs (relational vs. document vs. event store)
- Different consistency requirements (strong consistency for payments vs. eventual consistency for recommendations)
- Different rate of change (billing rules change quarterly; product catalog changes daily)

### Context Size

There is no formula for the right size of a bounded context. However, guidelines help:

- **Too large:** If a single context contains concepts that do not cohesively relate, it is too large. A context that contains both "insurance underwriting" and "marketing campaign management" is probably two contexts.
- **Too small:** If you find yourself creating translation layers between closely related concepts that change together and are owned by the same team, you may have split too aggressively.
- **Rule of thumb:** A bounded context should be ownable by a single team (5-9 people). If a context requires multiple teams to modify, it is either too large or the team boundaries are wrong.

## Context Mapping Patterns

Context mapping describes how bounded contexts relate to each other. Eric Evans and the DDD community have identified nine primary patterns. Each represents a different political and technical relationship.

### 1. Shared Kernel

**What it is:** Two bounded contexts share a small subset of the model, typically a library of common types. Both teams co-own this shared code and must coordinate changes.

**When to use:** When two closely collaborating teams need the same domain concept (e.g., a `Money` value object or a `DateRange` type) and the overhead of translation is not justified.

**Risks:** Coupling. Any change to the shared kernel requires coordination between both teams. If not carefully managed, the shared kernel grows uncontrollably.

**Rules:**
- Keep the shared kernel as small as possible -- value objects and basic types only
- Require explicit agreement (both teams) for any change
- Automated tests in both contexts must pass before any shared kernel change is merged
- Never put entities or aggregates in the shared kernel

**Example:** Two contexts (billing and shipping) share a `Money(amount, currency)` value object and an `Address(street, city, state, zip, country)` value object.

### 2. Customer-Supplier

**What it is:** An upstream context (supplier) provides data or services that a downstream context (customer) depends on. The upstream team plans with the downstream team's needs in mind but has its own priorities.

**When to use:** When one team produces something another team consumes, and there is a reasonable working relationship. The downstream team can influence the upstream team's roadmap but does not control it.

**Example:** The Product Catalog team (upstream) provides product data to the Pricing team (downstream). The Pricing team requests new attributes when needed, and the Catalog team accommodates these requests in their planning.

### 3. Conformist

**What it is:** The downstream context conforms to the upstream context's model without translation. The downstream team accepts the upstream model as-is, even if it is not ideal.

**When to use:** When the upstream team has no incentive or ability to accommodate the downstream team (e.g., a large external service, a legacy system, or a dominant upstream team), and the cost of building a translation layer exceeds the cost of conforming.

**Risks:** Your model is constrained by someone else's design decisions. If the upstream model changes, your context must change too.

**Example:** A startup integrating with a major ERP system may conform to the ERP's data model rather than building translation layers, accepting the ERP's concept of "customer" and "order" even if they do not perfectly fit.

### 4. Anti-Corruption Layer (ACL)

**What it is:** A translation layer that sits between the downstream context and the upstream context, converting the upstream model into the downstream context's own domain language. The ACL protects the downstream model from being polluted by foreign concepts.

**When to use:** When you need to integrate with a system whose model does not fit yours, and you cannot afford to let that foreign model leak into your domain. This is the most important defensive pattern in DDD.

**Structure:**
```
Your Domain Layer  <-->  ACL (Adapters + Translators)  <-->  External System
```

The ACL contains:
- **Adapters** that handle the technical protocol (HTTP, gRPC, message queue)
- **Translators** that convert external model objects into your domain objects
- **Facades** that present a clean interface to your domain layer

**Example:** Integrating with a legacy mainframe that represents customers as `CUST_REC` with fields like `CUST_NM`, `CUST_ADDR1`. The ACL translates this into your domain's `Customer(name: PersonName, address: Address)` value objects.

### 5. Open Host Service (OHS)

**What it is:** An upstream context exposes a well-defined, documented protocol (API, message format) that downstream contexts can integrate with. The upstream team provides a stable, versioned interface designed for general consumption.

**When to use:** When an upstream context serves multiple downstream consumers and cannot tailor its interface to each one. The OHS provides a standard integration point.

**Characteristics:**
- Versioned API with backward compatibility guarantees
- Documentation and contracts (OpenAPI, protobuf schemas, JSON Schema)
- The interface is deliberately designed for external consumption, not a direct exposure of the internal model

**Example:** An Identity Provider exposes an OAuth 2.0 / OpenID Connect API. Any downstream context can integrate using the standard protocol without knowing the internal user model.

### 6. Published Language

**What it is:** A well-documented, shared language (schema, format, protocol) used for communication between contexts. Often paired with Open Host Service.

**When to use:** When multiple contexts need to exchange data and a standard format prevents each integration from inventing its own.

**Examples:**
- Industry-standard formats: HL7 for healthcare, SWIFT for banking, EDI for supply chain
- Internal schemas: a company-wide JSON schema for events published on a shared message bus
- Protocol Buffers or Avro schemas for service-to-service communication

### 7. Separate Ways

**What it is:** Two contexts decide not to integrate at all. Each builds its own solution independently, even if there is some overlap.

**When to use:** When the cost of integration (coordination, translation, coupling) exceeds the cost of duplication. Sometimes it is cheaper and simpler for two teams to build their own `Address` validation than to share one.

**Signals that Separate Ways is appropriate:**
- The integration would be trivial functionality on both sides
- The teams are in different organizations with different release cycles
- The shared functionality is not core to either context

### 8. Big Ball of Mud

**What it is:** A system with no clear boundaries, where models are entangled and concepts leak everywhere. This is not a recommended pattern -- it is a recognition of reality. Many existing systems are Big Balls of Mud.

**When to use (as a label):** When mapping an existing landscape, some systems simply are Big Balls of Mud. Acknowledging this is the first step toward improvement. Drawing a boundary around the mud and treating it as a single (messy) context allows you to build clean contexts alongside it, protected by an ACL.

**Migration strategy:**
1. Draw a boundary around the entire mudball
2. Build new functionality in a clean bounded context
3. Protect the new context with an ACL against the mudball
4. Gradually extract functionality from the mud into clean contexts

### 9. Partnership

**What it is:** Two contexts evolve together with mutual coordination. Both teams jointly plan features and synchronize releases. Neither dominates.

**When to use:** When two contexts are tightly coupled in the domain and both teams are committed to evolving together. More intimate than Customer-Supplier; both teams have equal say.

**Risks:** Requires strong coordination discipline. If one team slips, both are affected.

**Example:** A checkout context and a payment processing context that must evolve in lockstep when payment methods change.

## Team Relationships and Context Boundaries

### Conway's Law in Practice

Conway's Law states that systems mirror the communication structures of the organizations that build them. In DDD, this is not a warning -- it is a design tool:

- **Align context boundaries with team boundaries.** If one team owns billing and another owns shipping, these should be separate bounded contexts.
- **If two teams must share a context, expect friction.** Either split the context or merge the teams.
- **Cross-team integration should happen at context boundaries,** using well-defined mapping patterns, not through shared code or databases.

### Choosing the Right Pattern

| Situation | Recommended Pattern |
|-----------|-------------------|
| Two teams with a good relationship and shared concepts | Shared Kernel (kept small) or Customer-Supplier |
| Integrating with a system you do not control | Anti-Corruption Layer |
| Exposing your context to many consumers | Open Host Service + Published Language |
| Integrating with a hostile or unresponsive upstream | Conformist (if cost is low) or Separate Ways |
| Legacy system with no clear model | Big Ball of Mud (label it) + ACL around it |
| Two teams that must evolve in lockstep | Partnership |
| Integration cost exceeds duplication cost | Separate Ways |

### Drawing a Context Map

A context map is a visual representation of all bounded contexts and their relationships. It should include:

1. **Every bounded context** drawn as a labeled box
2. **The relationships between them** using the patterns above (arrows show upstream/downstream)
3. **The translation mechanism** (ACL, OHS, Shared Kernel)
4. **Team ownership** for each context
5. **The Big Balls of Mud** explicitly labeled

The context map is a communication tool. It should be understandable by both developers and non-technical stakeholders. Keep it on a whiteboard or in a shared diagram that the team references and updates regularly.

### When Boundaries Change

Context boundaries are not permanent. They evolve as the business and team structure change:

- **Splitting:** A context grows too large for one team; split it along natural seams and introduce a mapping pattern between the new contexts.
- **Merging:** Two small contexts owned by the same team with heavy inter-communication; merge them and eliminate the translation overhead.
- **Reclassifying:** A context that was Generic Subdomain becomes Core Domain as business strategy shifts; increase investment and modeling rigor.

The key is to make boundaries explicit and intentional, so that when they need to change, the change is a deliberate design decision rather than an accidental drift.
