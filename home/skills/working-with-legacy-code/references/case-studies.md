# Case Studies: Legacy Code Techniques in Practice

## Table of Contents

- [Case Study 1: Adding a Feature to an Untested 800-Line Service Class](#case-study-1-adding-a-feature-to-an-untested-800-line-service-class)
- [Case Study 2: Getting a Singleton-Ridden Module Under Test](#case-study-2-getting-a-singleton-ridden-module-under-test)
- [Case Study 3: Taming a Monster Method Before a Bug Fix](#case-study-3-taming-a-monster-method-before-a-bug-fix)
- [Key Takeaways](#key-takeaways)

## Case Study 1: Adding a Feature to an Untested 800-Line Service Class

### Context

A six-year-old e-commerce backend in TypeScript. `OrderService` is 800 lines and handles order creation, payment capture, stock reservation, confirmation emails, and refunds. It has zero tests. The new requirement: a loyalty points program — one point per 10 EUR on paid orders, points redeemable as a discount at checkout.

The team's previous attempt to "just add" a small feature to this class caused a refund regression that took down order processing for an afternoon. Since then, nobody volunteers to touch the file.

### The Problems

- The constructor connects to Postgres and Redis and instantiates a `StripeClient` — `new OrderService()` in a test harness opens real connections or crashes
- `placeOrder()` is 190 lines and is the change point; its effects scatter across DB writes, a stock decrement, an email, and the returned `OrderResult`
- Emails go through `Mailer.getInstance()`, a singleton that talks to SMTP from anywhere

### Step by Step

**1. Identify change points.** Points are awarded when an order transitions to `paid` — inside `placeOrder()`, after payment capture. Redemption applies in `applyDiscounts()`. Two change points, both inside the scary file.

**2. Find test points.** `placeOrder()` returns an `OrderResult` and calls the gateway and repositories — sensing is possible if those collaborators can be substituted. It is also a pinch point: payment, stock, and email logic all funnel through it, so tests here cover wide behavior cheaply.

**3. Break dependencies — three commits, each provably behavior-free.**

Commit 1, Parameterize Constructor with production defaults so no caller changes:

```typescript
constructor(
  private db: OrderRepo = new PgOrderRepo(pool),
  private stock: StockRepo = new RedisStockRepo(redis),
  private gateway: PaymentGateway = new StripeClient(env.STRIPE_KEY),
  private mailer: ReceiptSender = Mailer.getInstance(),
) {}
```

Commit 2, Extract Interface on the gateway — `PaymentGateway` declares the three methods `OrderService` actually calls, not Stripe's full surface.

Commit 3, replace direct `Mailer.getInstance()` calls inside methods with the injected `this.mailer`. A grep confirms every send site routes through the field.

**4. Write characterization tests.** Nine pin tests against `placeOrder()`: happy path, declined card, out-of-stock, coupon applied, free order, three quantity boundaries, malformed address. One genuine surprise: on a declined card, stock is decremented and *never restored*. The team pins it as-is with a `BUG?` comment and files a ticket — fixing it now would be an unreviewed behavior change hiding inside the safety-net step.

**5. Make the change.** The loyalty logic is not woven into `placeOrder()`'s 190 lines. It is a Sprout Class — `LoyaltyLedger`, written test-first in isolation with seven specification tests — and the legacy file gains exactly two lines:

```typescript
// in placeOrder(), after capture succeeds:
await this.loyalty.award(order.customerId, pointsFor(order.totalCents));

// in applyDiscounts():
discount += await this.loyalty.redeem(order.customerId, requestedPoints);
```

### Outcome

| Measure | Before | After |
|---------|--------|-------|
| Tests touching `OrderService` paths | 0 | 16 (9 pins + 7 loyalty specs) |
| Time spent | — | 2.5 days (vs. 1 day estimated for "just add it") |
| Regressions shipped | the historical norm | 0 |
| Known stock bug | invisible | pinned, ticketed, fixed deliberately the next sprint |
| Next feature in the same area | feared | shipped in half a day on top of the pins |

### Lessons Learned

1. **The fear was a dependency problem, not a complexity problem.** Three mechanical commits made an "untouchable" class testable; the 800 lines were never the real obstacle.
2. **The sprout kept the new logic clean.** `LoyaltyLedger` was born fully tested and never inherited the host's mess; the host gained call lines, not branches.
3. **The pinned bug paid for the whole exercise.** Edit-and-pray would have either shipped past the stock bug again or "fixed" it silently and broken the warehouse reconciliation that had quietly compensated for it.

## Case Study 2: Getting a Singleton-Ridden Module Under Test

### Context

A Python/Flask pricing service, eight years old. `pricing.py` computes quotes and is due for a VAT rule change with a legal deadline. Functions reach for `Config.instance()` and `FeatureFlags.instance()` at call time, and the module constructs its database client at import time:

```python
# pricing.py (top of file)
db = Database(Config.instance().dsn)   # runs on import

def quote_price(items, country):
    cfg = Config.instance()
    flags = FeatureFlags.instance()
    rate = db.vat_rate(country)
    ...
```

Importing `pricing` in a test process connects to the production replica. There are no tests, and the team has been verifying pricing changes by deploying to staging and eyeballing quotes.

### The Problems

- Import-time side effects: the module cannot even be loaded in a harness safely
- Singletons are read deep inside functions — no parameters to substitute, no visible seams
- Quote logic branches on feature flags, dates, and country tables, so manual verification misses combinations

### Step by Step

**1. Kill the import-time work first.** Wrap the module-level client in a lazy accessor — a mechanical, signature-shaped change:

```python
_db = None

def get_db():
    global _db
    if _db is None:
        _db = Database(Config.instance().dsn)
    return _db
```

Every `db.` becomes `get_db().` — a find-and-replace verified by grep, committed as "no behavior change." The module now imports cleanly; nothing connects until first use.

**2. Introduce Static Setter on the singletons** for test control, with hygiene built in:

```python
class Config:
    _instance = None

    @classmethod
    def instance(cls):
        if cls._instance is None:
            cls._instance = cls._load()
        return cls._instance

    @classmethod
    def set_instance(cls, fake):
        cls._instance = fake
```

```python
# conftest.py
@pytest.fixture(autouse=True)
def reset_singletons():
    yield
    Config.set_instance(None)
    FeatureFlags.set_instance(None)
```

The autouse reset matters as much as the setter: without it, one test's fake config bleeds into the next, and test order starts to matter.

**3. Parameterize the function under change.** The VAT work lands in `quote_price`, so that function gets real seams while the rest of the module keeps its singletons for now:

```python
def quote_price(items, country, *, config=None, flags=None, db=None):
    config = config or Config.instance()
    flags = flags or FeatureFlags.instance()
    db = db or get_db()
    ...
```

Production callers are untouched; tests pass plain fakes with no patching.

**4. Characterize.** Fourteen pin tests across countries, flag combinations, and date boundaries, with `freezegun` freezing the clock for date-dependent rates. One surprise pinned: an obsolete flag still silently zeroes VAT for one legacy country path — ticketed, not fixed.

**5. Make the VAT change** as a behavior-only commit: two new assertions flipped from observed-old to specified-new values, implementation follows, everything else stays green.

### Outcome

| Measure | Before | After |
|---------|--------|-------|
| Tests on `pricing.py` | 0 | 14 pins + 5 VAT specs |
| Importing the module in tests | connects to prod replica | side-effect free |
| `mock.patch` lines per test | n/a (no tests) | 0 — fakes passed as parameters |
| VAT change verification | deploy to staging and eyeball | red-green on the pinned suite |
| Regression from the VAT change | historically likely | none |

### Lessons Learned

1. **In Python legacy, import-time side effects are the first enemy.** Nothing else is fixable until the module loads cleanly; the lazy accessor is a five-minute cure.
2. **The static setter is scaffolding, not the destination.** It bought testability in an hour; the parameterized `quote_price` is the pattern the module migrates toward function by function.
3. **Autouse resets make global-state seams survivable.** The fixture cost two lines and prevented the flaky, order-dependent suite that usually follows singleton setters.

## Case Study 3: Taming a Monster Method Before a Bug Fix

### Context

A Java billing system generates customer statements. `generateStatement()` is roughly 700 lines: balance forward, payments, late-payment interest, taxes, formatting — about forty local variables, nesting nine levels deep. A confirmed bug: when a partial payment lands inside the grace period, late interest is applied twice. Finance wants the fix this week. The fix "looks like one line," but everyone who has touched this method has broken a different statement scenario.

### Step by Step

**1. Find the test point — the method's return value is a gift.** `generateStatement()` returns the full statement as a `String`: ideal golden-master material. The team builds twelve input fixtures from anonymized production accounts covering the payment patterns that matter (on-time, late, partial-in-grace, multiple partials, zero balance, credit balance), captures the outputs, reviews them line by line, and checks them in as masters. Dates and statement IDs are normalized before comparison.

**2. Break Out Method Object.** Extracting pieces directly from the method is hopeless — every fragment touches a dozen locals. Instead, the whole body moves verbatim into a new class where locals become fields:

```java
class StatementRun {
    private final Account account;
    private final LocalDate asOf;
    private BigDecimal balance;      // was a local
    private BigDecimal interest;     // was a local
    // ... the other forty, now fields

    StatementRun(Account account, LocalDate asOf) { ... }

    String run() {
        // 700 lines moved verbatim
    }
}

String generateStatement(Account account, LocalDate asOf) {
    return new StatementRun(account, asOf).run();
}
```

Masters rerun: all green. The move was pure structure.

**3. Extract inside the new class, masters after every step.** With locals as fields, extraction is suddenly mechanical: `applyPayments()`, `interestFor(Period p)`, `renderLines()` — signatures copied exactly, one extraction per commit, golden masters green after each. Twenty minutes per move because verification is a test run, not an afternoon of manual statement-reading.

**4. Reproduce the bug as a unit test.** `interestFor()` is now directly callable. The failing test takes ten minutes to write and fails for exactly the reported reason: the grace-period branch adds interest that the partial-payment branch has already accrued.

**5. Fix the bug as a deliberate behavior change.** The fix is two lines, not one — the same double-application exists in a second branch for multi-payment months, which the unit test's sibling case exposes. Exactly one golden master diffs: the partial-in-grace fixture. The team reviews the diff hunk by hunk with finance, accepts the new master, and commits fix, flipped unit test, and regenerated master together.

### Outcome

| Measure | Before | After |
|---------|--------|-------|
| Tests on statement generation | 0 | 12 golden masters + 6 unit tests on interest |
| The "one-line" fix | one line, fingers crossed | two lines, second site caught by tests |
| Verification of a statement change | manual reading of samples | seconds: rerun the masters |
| `generateStatement()` | 700-line monolith | thin delegate over a structured `StatementRun` |
| Time spent | — | 1.5 days, deadline met |

### Lessons Learned

1. **Golden masters made a 700-line method testable in hours, without understanding all of it.** Comprehension followed coverage, not the other way around.
2. **Break Out Method Object created the room to work.** The monster wasn't forty unrelated locals; it was three clusters, visible the moment they became fields.
3. **The fix everyone called "one line" was two.** The second site is precisely the kind of thing edit-and-pray misses and a pinned suite catches by construction.

## Key Takeaways

1. **Fear is a dependency problem.** In all three cases the team was afraid of files, but the actual obstacles were constructors, singletons, and missing seams — each removable with a named, mechanical technique.
2. **Pin before you change, even when the pin records a bug.** Two of the three teams found real bugs while characterizing; both pinned first and fixed deliberately later, preserving behaviors other systems had silently grown to depend on.
3. **New logic goes in new, tested code.** Sprouted classes and extracted methods were born clean; the legacy hosts gained call lines, not branches.
4. **Scaffolding and destination are different things.** Testing subclasses, static setters, and golden masters bought tests *today*; parameterized constructors and adapted parameters are the design the code migrates toward.
5. **Coverage arrives with change, not with permission.** None of these teams got a "testing sprint." They bought their safety nets inside ordinary feature and bug-fix work — which is the only budget that reliably exists.
