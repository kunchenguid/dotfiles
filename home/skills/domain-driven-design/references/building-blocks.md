# Building Blocks: Entities, Value Objects, and Aggregates

The tactical building blocks of Domain-Driven Design provide a vocabulary for structuring domain models. Entities, Value Objects, and Aggregates are the three most critical patterns. Getting them right determines whether a domain model is expressive and maintainable or bloated and fragile.

## Entities

An Entity is a domain object defined by its identity rather than its attributes. An entity persists across time and state changes -- it is the "same thing" even when everything about it changes.

### The Identity Test

Ask: "If all the attributes change, is it still the same thing?"

- A **person** changes name, address, phone number, job, and appearance -- still the same person. **Entity.**
- A **bank account** changes its balance daily -- still the same account. **Entity.**
- A **$10 bill** is interchangeable with any other $10 bill. **Not an entity -- Value Object.**

### Identity Strategies

| Strategy | How It Works | When to Use |
|----------|-------------|-------------|
| Natural key | Use a real-world identifier (SSN, ISBN, VIN) | When a stable, unique external identifier exists |
| Surrogate key | Generate a synthetic ID (UUID, auto-increment) | When no natural key exists or the natural key can change |
| Composite key | Combine multiple attributes | When identity is defined by a relationship (e.g., student + course = enrollment) |

**Prefer UUIDs over auto-increment** for distributed systems. UUIDs can be generated anywhere without coordination; auto-increment requires a central authority.

### Entity Design Rules

1. **Identity is immutable.** Once assigned, an entity's identity never changes. If the "identity" can change, it is not really the identity.
2. **Entities are mutable.** Unlike Value Objects, entities change state over time. An `Order` moves from `Pending` to `Confirmed` to `Shipped`.
3. **Equality is based on identity.** Two `Order` objects with the same `orderId` are the same order, regardless of other attribute differences.
4. **Entities have a lifecycle.** They are created, go through state transitions, and may eventually be archived or deleted.
5. **Put behavior on entities.** An entity is not a data container. `order.addItem(product, quantity)` belongs on the `Order` entity, not in an `OrderService`.

### Common Entity Pitfalls

- **Over-identification.** Making everything an entity when most things should be Value Objects. Ask the identity test for every class.
- **Anemic entities.** Entities with only getters and setters. If all behavior is in services, the entity is a data bag.
- **Identity leakage.** Exposing database primary keys as domain identity. Use domain-meaningful identifiers (`orderNumber`) rather than technical ones (`id: 42`).

## Value Objects

A Value Object is a domain object defined entirely by its attributes. It has no identity -- two Value Objects with the same attributes are interchangeable. Value Objects are immutable: you do not change a Value Object; you replace it.

### The Attribute Test

Ask: "Is it defined by what it is, not which one it is?"

- A **mailing address** (123 Main St, Springfield, IL 62704) -- defined by its attributes. Two objects with the same street, city, state, zip are the same address. **Value Object.**
- A **money amount** ($49.99 USD) -- defined by amount and currency. **Value Object.**
- A **date range** (Jan 1 - Dec 31) -- defined by start and end. **Value Object.**
- A **color** (#FF5733) -- defined by its hex value. **Value Object.**

### Why Value Objects Matter

Value Objects are the unsung heroes of domain models. Most developers default to entities for everything, but **the majority of concepts in a well-designed domain model should be Value Objects.**

**Benefits of Value Objects:**

| Benefit | Explanation |
|---------|-------------|
| Immutability | No shared mutable state; safe to pass around, cache, and use in concurrent code |
| Side-effect-free behavior | Methods return new Value Objects rather than mutating state; easy to reason about |
| Self-validation | A Value Object validates itself on creation; an invalid Value Object can never exist |
| Equality by value | `Money(100, "USD") == Money(100, "USD")` regardless of object reference |
| Expressiveness | `Money` instead of `BigDecimal`; `EmailAddress` instead of `String`; domain meaning is encoded in the type |

### Value Object Design Rules

1. **Immutable.** All fields are set at construction and never change. No setters.
2. **Self-validating.** A `Money` object with a negative amount or null currency should throw on construction. If it exists, it is valid.
3. **Equality by attributes.** Override `equals()` and `hashCode()` to compare all attributes.
4. **Side-effect-free methods.** `money.add(other)` returns a new `Money`; it does not mutate the original.
5. **Replace, don't modify.** To change an address, create a new `Address` and assign it. `customer.changeAddress(newAddress)`.

### Common Value Objects

| Value Object | Replaces | Why It Is Better |
|-------------|---------|------------------|
| `Money(amount, currency)` | `BigDecimal` | Prevents currency mismatch errors; encapsulates rounding rules |
| `EmailAddress(value)` | `String` | Validates format on construction; impossible to have invalid email in the system |
| `DateRange(start, end)` | Two `Date` fields | Enforces `start <= end`; contains overlap/contains logic |
| `Address(street, city, state, zip)` | Multiple String fields | Groups related data; validates as a unit |
| `Quantity(value, unit)` | `int` or `double` | Prevents unit mismatch (adding kilograms to liters) |
| `PhoneNumber(countryCode, number)` | `String` | Validates format; normalizes representation |

### When to Use Value Objects vs. Entities

| Signal | Entity | Value Object |
|--------|--------|-------------|
| Needs to be tracked over time | Yes | No |
| Has a lifecycle (created, modified, archived) | Yes | No -- replaced, not modified |
| Two instances with same attributes are different things | Yes | No -- they are the same thing |
| Immutability is natural | No | Yes |
| Appears in the model as a measurement, description, or attribute | No | Yes |

**Rule of thumb:** If in doubt, make it a Value Object. You can always promote it to an Entity later if identity becomes important. Going the other direction (demoting an Entity to a Value Object) is much harder.

## Aggregates

An Aggregate is a cluster of domain objects (entities and value objects) treated as a single unit for data changes. Every aggregate has a single root entity -- the Aggregate Root -- through which all external access occurs.

### Why Aggregates Exist

Without aggregates, any object in the system can hold a reference to any other object and modify it directly. This creates an impossibly tangled web of dependencies where enforcing business invariants (rules that must always be true) becomes a nightmare.

Aggregates solve this by drawing a boundary:
- **Inside the boundary:** Strong consistency. All invariants are enforced within a single transaction.
- **Outside the boundary:** Eventual consistency. Changes propagate via domain events or polling.

### Aggregate Design Rules

Eric Evans and Vaughn Vernon established these rules, refined by the DDD community:

#### Rule 1: Protect Business Invariants Inside the Aggregate

An invariant is a rule that must always be true. Example: "An order's total must equal the sum of its line items." This invariant involves `Order` and `OrderLineItem`. Both belong in the same aggregate because the invariant spans both.

| If the invariant spans... | Then... |
|--------------------------|---------|
| A single entity | That entity is its own aggregate |
| An entity and its closely related objects | They form one aggregate |
| Two independently identifiable things | They are separate aggregates; enforce the rule via eventual consistency or a domain event |

#### Rule 2: Small Aggregates

Large aggregates cause:
- **Concurrency conflicts.** Two users editing different parts of the same large aggregate will conflict.
- **Performance problems.** Loading a large aggregate means loading everything it contains.
- **Transaction scope bloat.** Larger transaction scope means longer locks and more contention.

**Ideal aggregate size:** One root entity, a small set of value objects, and occasionally a small collection of child entities (e.g., `Order` with `OrderLineItems`).

**Anti-pattern:** An `Organization` aggregate that contains `Departments` which contain `Employees` which contain `Assignments`. This is too large. `Employee` should be its own aggregate, referencing `Organization` and `Department` by ID.

#### Rule 3: Reference Other Aggregates by ID Only

Do not hold direct object references to other aggregates. Instead, store only the identifier:

**Wrong:**
```
class Order {
  Customer customer;  // Direct reference to another aggregate
}
```

**Right:**
```
class Order {
  CustomerId customerId;  // Reference by ID only
}
```

**Why:** Direct references create tight coupling, prevent independent scaling, and make it impossible to enforce aggregate boundaries. With ID references, each aggregate can be loaded, stored, and cached independently.

#### Rule 4: Use Eventual Consistency Across Aggregate Boundaries

When one aggregate's action should trigger a change in another aggregate, do not try to update both in the same transaction. Instead:

1. The first aggregate performs its action and publishes a domain event
2. An event handler picks up the event and modifies the second aggregate in a separate transaction

**Example:**
- `Order.place()` publishes `OrderPlaced` event
- `InventoryHandler` receives `OrderPlaced` and calls `inventory.reserve(items)`
- These are two separate transactions

### Choosing Aggregate Boundaries

#### Start with the Invariant

Identify every business invariant. Group objects that participate in the same invariant into the same aggregate.

**Example invariants:**
| Invariant | Objects Involved | Aggregate |
|-----------|-----------------|-----------|
| "An order total must equal the sum of its lines" | Order, OrderLineItem | Order aggregate |
| "A product must have at least one category" | Product, Category | Product aggregate (Category is a value object or ID reference) |
| "An account balance must never go below the overdraft limit" | Account | Account aggregate (single entity) |
| "A reservation cannot overlap with another for the same room" | Reservation | Reservation aggregate (overlap check is a domain service or repository query, not a cross-aggregate invariant) |

#### The Transaction Boundary Test

Ask: "Must these two changes happen atomically, or can they happen with a small delay?"

- If **atomically**: same aggregate
- If **small delay is acceptable**: separate aggregates with eventual consistency

Most of the time, a small delay is acceptable. Humans rarely need true atomicity outside of financial transactions.

### Aggregate Root Pattern

The Aggregate Root is the single entity through which all external interaction with the aggregate occurs:

**Rules for the root:**
1. External objects may only hold references to the root, never to internal entities
2. All changes to the aggregate go through the root's methods
3. The root enforces all aggregate invariants
4. The root controls the lifecycle of all internal objects
5. Delete the root and everything inside the aggregate is deleted

**Example:**
```
// External code interacts only with Order (the root)
order.addLineItem(product, quantity, price)
order.removeLineItem(lineItemId)
order.calculateTotal()

// LineItems are never accessed directly from outside
// WRONG: lineItem.changeQuantity(5)
// RIGHT: order.changeLineItemQuantity(lineItemId, 5)
```

### Common Aggregate Mistakes

| Mistake | Consequence | Fix |
|---------|------------|-----|
| Making the entire object graph one aggregate | Concurrency nightmares, slow loading | Split into multiple aggregates; reference by ID |
| Holding direct references to other aggregates | Tight coupling; cannot enforce boundaries | Replace with ID references |
| Updating multiple aggregates in one transaction | Distributed lock contention; scaling bottleneck | Use domain events for cross-aggregate consistency |
| Putting all logic in services instead of the aggregate root | Anemic aggregate; invariants not enforced | Move invariant-enforcing logic into the aggregate root |
| Creating aggregates based on database tables | Data model drives domain model (backward) | Design aggregates from domain invariants, then map to persistence |

## Putting It All Together

A well-designed domain model has this structure:

1. **Value Objects** form the majority of types -- measurements, descriptions, identifiers, small composites
2. **Entities** represent things with identity and lifecycle -- fewer than you think
3. **Aggregates** cluster related entities and value objects behind a root -- enforcing consistency boundaries
4. **References between aggregates** are by ID only -- enabling independent evolution
5. **Cross-aggregate consistency** is achieved through domain events -- eventual consistency is the default

The result is a model that is expressive (reads like the business), consistent (invariants are enforced), and scalable (aggregates are independent units of consistency, persistence, and caching).
