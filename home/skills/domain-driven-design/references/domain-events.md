# Domain Events

A domain event represents something that happened in the domain that domain experts care about. Events are named in past tense, are immutable facts, and serve as the primary mechanism for decoupling bounded contexts and achieving eventual consistency across aggregate boundaries.

## What Domain Events Are

A domain event captures a meaningful occurrence in the business domain. "Meaningful" means that a domain expert would recognize it as significant -- not just a technical state change.

### Domain Events vs. Technical Events

| Domain Event | Technical Event | Why It Matters |
|-------------|----------------|----------------|
| `OrderPlaced` | `RowInserted` | The domain expert cares about orders being placed; they do not care about database rows |
| `PaymentReceived` | `WebhookProcessed` | The business reacts to payments; the webhook is an implementation detail |
| `ClaimDenied` | `StatusUpdated` | Denial triggers business processes (appeals, notifications); a status update triggers nothing meaningful |
| `InventoryDepleted` | `CountReachedZero` | The business has specific procedures for depleted inventory; zero is just a number |

### The Litmus Test

Ask a domain expert: "Would you care if this happened?" If yes, it is a domain event. If they shrug, it is a technical event that belongs in infrastructure, not in the domain model.

## Naming Domain Events

### The Past-Tense Rule

Domain events are always named in past tense because they represent facts that have already occurred. By the time anyone processes the event, the thing has already happened.

**Correct naming:**
- `OrderPlaced` -- an order was placed
- `PaymentReceived` -- a payment was received
- `ShipmentDispatched` -- a shipment was dispatched
- `AccountSuspended` -- an account was suspended
- `PolicyRenewed` -- a policy was renewed

**Incorrect naming:**
- `PlaceOrder` -- this is a command, not an event
- `OrderPlacing` -- this implies the action is in progress
- `OrderEvent` -- too generic; what happened?
- `OrderUpdate` -- "update" is not a domain concept; what specifically changed?

### Naming Specificity

Be specific about what happened. Vague event names create the same problems as vague method names -- consumers cannot understand what occurred without reading the payload.

| Vague | Specific | Why Specific Is Better |
|-------|----------|----------------------|
| `OrderChanged` | `OrderItemAdded`, `OrderItemRemoved`, `OrderAddressChanged` | Different changes trigger different business reactions |
| `UserUpdated` | `UserEmailVerified`, `UserPasswordChanged`, `UserProfileCompleted` | A password change requires a security audit; a profile completion triggers onboarding flow |
| `PaymentProcessed` | `PaymentAuthorized`, `PaymentCaptured`, `PaymentRefunded` | Authorization and capture are distinct business steps with different downstream effects |

### Event Naming Conventions

Adopt a consistent naming pattern across the codebase:

```
{AggregateType}{DomainAction}
```

Examples:
- `OrderPlaced`, `OrderCancelled`, `OrderFulfilled`
- `InvoiceSent`, `InvoicePaid`, `InvoiceOverdue`
- `MemberRegistered`, `MemberSuspended`, `MemberReinstated`

## Event Structure

A well-designed domain event contains:

| Field | Purpose | Example |
|-------|---------|---------|
| `eventId` | Unique identifier for this specific event occurrence | `uuid("a1b2c3d4...")` |
| `eventType` | The name of the event | `"OrderPlaced"` |
| `occurredAt` | When the event happened | `"2024-03-15T14:30:00Z"` |
| `aggregateId` | The ID of the aggregate that produced the event | `orderId: "ORD-12345"` |
| `aggregateType` | The type of aggregate | `"Order"` |
| `payload` | The domain-relevant data | `{ customerId, items, total, shippingAddress }` |
| `metadata` | Technical metadata (correlation ID, causation ID, user ID) | `{ correlationId, userId }` |

### What Goes in the Payload

Include enough data for consumers to react without calling back to the producer:

**Too little:**
```json
{ "orderId": "ORD-12345" }
```
Every consumer must call back to the Order service to get details. This creates coupling and latency.

**Too much:**
```json
{ "order": { /* entire order aggregate serialized */ } }
```
This bloats messages, exposes internal model details, and creates tight coupling to the aggregate structure.

**Just right:**
```json
{
  "orderId": "ORD-12345",
  "customerId": "CUST-789",
  "items": [
    { "productId": "PROD-1", "quantity": 2, "unitPrice": 29.99 }
  ],
  "totalAmount": 59.98,
  "currency": "USD",
  "shippingAddress": { "city": "Springfield", "state": "IL" }
}
```
Enough for most consumers to react; detailed enough to avoid callbacks for common cases.

## Publishing Domain Events

### Where Events Are Raised

Domain events are raised within the aggregate, as part of the domain operation that caused them:

```
class Order:
    def place(self):
        self._validate_can_be_placed()
        self.status = OrderStatus.PLACED
        self._raise_event(OrderPlaced(
            order_id=self.id,
            customer_id=self.customer_id,
            items=self.items,
            total=self.total
        ))
```

The aggregate records the event internally. An infrastructure mechanism (event dispatcher, outbox pattern) publishes it after the aggregate is persisted.

### The Outbox Pattern

The most reliable way to publish domain events is the transactional outbox:

1. Within the same database transaction that persists the aggregate, insert the event into an `outbox` table
2. A separate process (poller or CDC -- Change Data Capture) reads from the outbox and publishes to the message broker
3. After successful publication, mark the outbox entry as published

**Why this matters:** If you publish the event and then save the aggregate, the save might fail -- you published a lie. If you save the aggregate and then publish, the publish might fail -- the event is lost. The outbox pattern ties both operations to the same database transaction.

### Delivery Guarantees

| Guarantee | Meaning | Implementation |
|-----------|---------|----------------|
| At-most-once | Events may be lost but never duplicated | Fire-and-forget; no outbox; acceptable for non-critical events |
| At-least-once | Events are never lost but may be duplicated | Outbox pattern with retry; consumers must be idempotent |
| Exactly-once | Events are delivered exactly once | Practically impossible in distributed systems; achieve via at-least-once + idempotent consumers |

**At-least-once with idempotent consumers** is the standard approach. Design every event handler to be safe to run multiple times with the same event.

## Domain Events for Cross-Context Integration

### Internal vs. Integration Events

| Aspect | Domain Event (Internal) | Integration Event (External) |
|--------|------------------------|------------------------------|
| Scope | Within a bounded context | Across bounded contexts |
| Audience | Event handlers in the same context | Other teams' services |
| Schema | Can change freely with the model | Must be versioned and backward-compatible |
| Naming | Uses internal ubiquitous language | Uses published language (shared schema) |
| Transport | In-process event bus or same database | Message broker (Kafka, RabbitMQ, SNS) |

### Translation at the Boundary

When a domain event crosses a bounded context boundary, it should be translated into an integration event that uses the published language:

1. **Order context** raises `OrderPlaced` (domain event, internal language)
2. **Anti-corruption layer** translates to `PurchaseCompleted` (integration event, published language)
3. **Shipping context** receives `PurchaseCompleted` and translates to `ShipmentRequested` (domain event, shipping language)

This translation prevents internal model changes from breaking external consumers.

### Event-Driven Architecture Patterns

#### Event Notification

The event carries minimal data ("something happened") and consumers call back for details. Simplest pattern but creates temporal coupling.

#### Event-Carried State Transfer

The event carries all the data consumers need. Consumers maintain their own local copy of relevant data, reducing coupling but increasing event size and requiring consumers to maintain projections.

#### Event Sourcing

Events are the source of truth. Current state is derived by replaying events. This is the most powerful and most complex pattern.

## Event Sourcing

Event sourcing stores the complete history of state changes as an ordered sequence of events. Instead of storing only the current state ("account balance is $1,000"), the system stores every event that led to that state ("deposited $500, deposited $800, withdrew $300").

### When to Use Event Sourcing

| Good Fit | Poor Fit |
|----------|----------|
| Audit requirements (financial, medical, legal) | Simple CRUD with no audit needs |
| Complex domain with many state transitions | Domains with few state changes |
| Need to answer "how did we get here?" | Only need current state |
| Need to rebuild state at any point in time | No temporal query requirements |
| High-value domain events that are worth preserving | High-volume, low-value data (telemetry) |

### Event Sourcing Mechanics

**Storing events:**
```
Stream: Order-12345
  1: OrderCreated { customerId, items }
  2: PaymentAuthorized { paymentId, amount }
  3: OrderConfirmed { confirmedAt }
  4: ItemShipped { trackingNumber, items }
  5: OrderDelivered { deliveredAt, signedBy }
```

**Rebuilding state:**
```
currentState = OrderCreated.apply(emptyOrder)
currentState = PaymentAuthorized.apply(currentState)
currentState = OrderConfirmed.apply(currentState)
currentState = ItemShipped.apply(currentState)
currentState = OrderDelivered.apply(currentState)
```

**Snapshots** optimize performance: periodically save the current state so you do not need to replay from the beginning every time.

### Event Sourcing Challenges

| Challenge | Solution |
|-----------|----------|
| Event schema evolution | Use upcasters to transform old events into the current schema; never delete old events |
| Performance with long event streams | Snapshots at regular intervals; read models for queries |
| Complexity | Only use event sourcing for aggregates where it provides clear value; not everything needs to be event-sourced |
| Debugging | Event logs provide excellent debugging and auditing; invest in tooling to browse and replay events |

## Patterns for Event Handling

### Idempotent Handlers

Every event handler must be safe to execute multiple times with the same event. Strategies:

- **Idempotency key:** Store processed event IDs; skip duplicates
- **Idempotent operations:** Design the operation itself to be naturally idempotent (e.g., "set balance to X" instead of "add Y to balance")
- **Conditional writes:** Use optimistic concurrency (version checks) to prevent double-application

### Ordering Guarantees

Events from the same aggregate should be processed in order. Events from different aggregates have no ordering guarantees. Design consumers accordingly:

- Partition by aggregate ID in the message broker (Kafka partition key = aggregate ID)
- Handle out-of-order events gracefully (check event version, buffer and reorder if needed)

### Dead Letter Handling

Events that repeatedly fail to process should be routed to a dead letter queue for investigation. Never silently drop failed events. Monitor dead letter queues actively.

### Sagas and Process Managers

Long-running business processes that span multiple aggregates or bounded contexts can be coordinated using sagas:

1. `OrderPlaced` triggers the saga
2. Saga sends `ReserveInventory` command
3. `InventoryReserved` event continues the saga
4. Saga sends `AuthorizePayment` command
5. `PaymentAuthorized` event continues the saga
6. If any step fails, the saga sends compensating commands (`ReleaseInventory`, `RefundPayment`)

Sagas maintain their own state and react to events. They do not hold locks -- they coordinate through events and compensating actions.
