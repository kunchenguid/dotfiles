# Dependency-Breaking Techniques

These techniques exist for one uncomfortable moment: you need to change code that has no tests, and the dependencies that block testing must be cut *before* the safety net exists. That constraint shapes everything. Every move here is mechanical and conservative: preserve signatures exactly (cut and paste, never retype), lean on the compiler to enumerate affected sites, apply one technique per commit, and prefer the least invasive option that unblocks a test. The goal is not good design — it is *tests*. Good design comes afterwards, under green.

## Table of Contents

- [Decision Table](#decision-table)
- [Extract Interface](#extract-interface)
- [Parameterize Constructor](#parameterize-constructor)
- [Parameterize Method](#parameterize-method)
- [Extract and Override Factory Method](#extract-and-override-factory-method)
- [Extract and Override Getter](#extract-and-override-getter)
- [Subclass and Override Method](#subclass-and-override-method)
- [Introduce Instance Delegator](#introduce-instance-delegator)
- [Adapt Parameter](#adapt-parameter)
- [Break Out Method Object](#break-out-method-object)
- [Singletons: Introduce Static Setter](#singletons-introduce-static-setter)
- [Language Notes](#language-notes)

## Decision Table

| Blocker | Technique |
|---------|-----------|
| Constructor does real work (opens connections, reads files) | Parameterize Constructor |
| Collaborator's type is concrete and heavy to instantiate | Extract Interface |
| Method reads a clock, random source, or global inside its body | Parameterize Method |
| Object creation buried inside a method you must test | Extract and Override Factory Method |
| A field's value blocks testing but is used in many methods | Extract and Override Getter |
| One dangerous call needs neutralizing in a test | Subclass and Override Method |
| Static method or singleton called from everywhere | Introduce Instance Delegator / Introduce Static Setter |
| Parameter type is impossible or painful to construct (framework object) | Adapt Parameter |
| Method is hundreds of lines with tangled local variables | Break Out Method Object |

## Extract Interface

The safest technique in the catalog: introducing an interface cannot change behavior — it only loosens a type so tests can substitute a fake.

Before:

```typescript
class ReportSender {
  constructor(private gateway: SmtpGateway) {}   // concrete, opens sockets
  sendDaily(report: Report): void {
    this.gateway.send(report.recipients, render(report));
  }
}
```

After:

```typescript
interface MessageGateway {
  send(to: string[], body: string): void;        // only what ReportSender uses
}

class SmtpGateway implements MessageGateway { /* unchanged */ }

class ReportSender {
  constructor(private gateway: MessageGateway) {}
  sendDaily(report: Report): void { /* unchanged */ }
}
```

Keep the interface exactly as wide as the class under test needs — one method extracted from SMTP's forty. A narrow interface is easy to fake, documents the real dependency, and avoids a maintenance contract with methods nobody calls. In TypeScript and Go, structural typing means existing fakes often satisfy the interface with no declaration at all; in Java and C#, your IDE's "extract interface" refactoring does this mechanically and safely.

## Parameterize Constructor

The workhorse. The constructor builds its own dependencies; let callers supply them instead, with the old construction as a default so no caller changes.

Before (Python):

```python
class InvoiceSync:
    def __init__(self):
        self.db = PgConnection(os.environ["DSN"])   # connects on construction
        self.api = ErpClient(api_key=load_key())
```

After:

```python
class InvoiceSync:
    def __init__(self, db=None, api=None):
        self.db = db if db is not None else PgConnection(os.environ["DSN"])
        self.api = api if api is not None else ErpClient(api_key=load_key())
```

Production call sites (`InvoiceSync()`) are untouched; tests write `InvoiceSync(db=FakeDb(), api=FakeErp())`. Use `None`-coalescing, not mutable defaults, and beware defaults that *evaluate* eagerly in languages where default expressions run at call time anyway (Python is fine; in TypeScript `constructor(db: Db = new ProdDb())` only constructs when the argument is omitted, which is the behavior you want). If the default construction is itself expensive to import, fall back to two constructors (Java overloads) or a static `create()` for production wiring.

## Parameterize Method

Same move, method-scope. Hidden inputs read inside the body — the clock is the classic — become parameters with production defaults.

Before:

```python
def is_expired(self, token):
    return token.issued_at + self.ttl < datetime.now(timezone.utc)
```

After:

```python
def is_expired(self, token, now=None):
    now = now or datetime.now(timezone.utc)
    return token.issued_at + self.ttl < now
```

Existing callers compile and behave identically; tests pass a fixed `now` and the time-boundary behavior becomes a plain assertion instead of a flake. The same pattern covers random seeds, environment lookups, and "who is the current user" reads.

## Extract and Override Factory Method

When object creation is buried inside a method or constructor, move the `new` into a protected factory method, then override it in a testing subclass. Idiomatic in Java:

```java
class TransactionLog {
    private final Db db;

    TransactionLog() {
        this.db = createDb();              // was: new OracleDb(Config.dsn())
    }

    protected Db createDb() {              // extracted factory method
        return new OracleDb(Config.dsn());
    }
}

class TestingTransactionLog extends TransactionLog {
    @Override
    protected Db createDb() {
        return new InMemoryDb();
    }
}
```

The body of the original method is unchanged except that `new` became `createDb()` — a signature-preserving, compiler-checked move. Cautions: calling overridable methods from constructors is fine in Java but a trap in C# and C++ (virtual dispatch during construction differs); in TypeScript, field initializers run before the subclass body, so prefer doing the creation lazily or passing through the constructor instead.

## Extract and Override Getter

The same idea when a problematic field is used across many methods: route all access through a protected getter (often lazy), and override just the getter in tests.

```typescript
class StatementJob {
  private _warehouse: WarehouseClient | null = null;

  protected warehouse(): WarehouseClient {
    if (!this._warehouse) this._warehouse = WarehouseClient.connect(env.WAREHOUSE_URL);
    return this._warehouse;
  }

  run(month: string): Summary {
    const rows = this.warehouse().query(monthQuery(month));  // every use goes through the getter
    return summarize(rows);
  }
}

class TestingStatementJob extends StatementJob {
  protected override warehouse(): WarehouseClient {
    return fakeWarehouse(rowsFixture());
  }
}
```

One override neutralizes every use of the dependency at once, and the lazy getter also stops construction-time side effects.

## Subclass and Override Method

The umbrella move underneath both Extract-and-Override techniques: subclass the class under test and stub the dangerous parts.

```typescript
class TestablePayrollRun extends PayrollRun {
  protected override postToLedger(entry: LedgerEntry): void {
    this.posted.push(entry);   // record instead of hitting the ledger service
  }
  posted: LedgerEntry[] = [];
}
```

A testing subclass is a legitimate tool, not a hack — it lives in the test tree, changes no production code, and is often the very first step that gets a class into a harness at all. Two rules of hygiene: override the *minimum* needed to separate and sense, and watch what the overrides are telling you. If the testing subclass stubs half the class, the class has at least two responsibilities and is asking to be split — under tests, later.

## Introduce Instance Delegator

Static calls offer no seam: there is no instance to swap. Add instance methods that delegate to the static, then hand callers an instance they can replace.

Before (Java):

```java
class Billing {
    static Receipt charge(CustomerId id, Money amount) { /* talks to payment processor */ }
}

// caller, untestable:
Receipt r = Billing.charge(order.customer(), total);
```

After:

```java
class Billing {
    static Receipt charge(CustomerId id, Money amount) { /* unchanged */ }

    Receipt chargeInstance(CustomerId id, Money amount) {   // delegator
        return charge(id, amount);
    }
}

// caller now holds a Billing instance (constructor-injected with a production default):
Receipt r = billing.chargeInstance(order.customer(), total);
```

Tests subclass `Billing` and override `chargeInstance`. Migrate callers gradually — each one you convert gains a seam; the rest keep working through the static. Once the static has no direct callers left, fold it into the instance method and retire the awkward name. The TypeScript equivalent is wrapping module-level functions in an injectable object: `const billing = { charge }` passed as a dependency.

## Adapt Parameter

When the blocker is a *parameter type* you can't sensibly construct — framework request objects are the canonical case — don't fight the framework. Narrow the parameter to an interface you own.

Before:

```typescript
export function buildQuote(req: Request): Quote {       // Express Request: huge, stateful
  const age = Number(req.query.age);
  const zip = String(req.query.zip);
  /* 60 lines of actual pricing logic */
}
```

After:

```typescript
export interface QuoteParams { age: number; zip: string }

export function buildQuote(params: QuoteParams): Quote {
  /* the same 60 lines, now framework-free */
}

export const quoteHandler = (req: Request) =>
  buildQuote({ age: Number(req.query.age), zip: String(req.query.zip) });
```

The logic is now testable with a plain object literal, and the adapter (`quoteHandler`) is so thin it barely needs testing. This is the Java `HttpServletRequest` cure as well: define the two-method interface your code actually reads, write one adapter, and stop faking forty-method servlet objects. Adapt Parameter is also the rare technique that *improves* the design on the spot — the new signature documents what the function really consumes.

## Break Out Method Object

For monster methods: hundreds of lines, dozens of locals, impossible to extract from because every candidate fragment touches ten variables. Move the whole method into a new class where the locals become fields; then extraction becomes easy.

Before (Python, abbreviated):

```python
class Tariff:
    def rate_for(self, order, tariffs, today):
        # 400 lines: base rate, seasonal adjustments, surcharges,
        # caps, currency handling — all sharing ~20 locals
        ...
```

After:

```python
class RateCalculation:
    def __init__(self, order, tariffs, today):
        self.order = order
        self.tariffs = tariffs
        self.today = today
        self.base = 0
        self.surcharge = 0

    def run(self):
        self._base_rate()        # the 400 lines, moved verbatim,
        self._seasonal()         # then split into private methods —
        self._caps()             # trivial now that locals are fields
        return self._total()

class Tariff:
    def rate_for(self, order, tariffs, today):
        return RateCalculation(order, tariffs, today).run()
```

The initial move is verbatim — same statements, locals promoted to `self.` fields, signatures preserved. Run your golden master after the move, then again after each split. The new class is independently constructible, its pieces individually testable, and the hidden structure of the monster (those weren't twenty locals; they were three clusters) becomes visible in the field groupings.

## Singletons: Introduce Static Setter

When `Config.instance()` is read deep inside everything, the fastest seam is a setter that supersedes the instance, plus a reset for test hygiene:

```python
class Config:
    _instance = None

    @classmethod
    def instance(cls):
        if cls._instance is None:
            cls._instance = cls._load_from_disk()
        return cls._instance

    @classmethod
    def set_instance(cls, fake):   # test-only seam
        cls._instance = fake
```

Pair it with an autouse fixture that calls `Config.set_instance(None)` after each test, or state leaks between tests and order starts to matter. Be clear-eyed: the static setter is scaffolding. It admits global state rather than removing it. The destination is parameterized code that receives its config; the setter exists so you can write the tests that make that migration safe.

## Language Notes

- **Java / C#:** the catalog as written. Lean hard on the compiler — every technique here is designed so that type errors enumerate the affected sites. Sealed/final classes and statics are the usual obstacles; `Introduce Instance Delegator` and wrapper interfaces handle most of them without bytecode-level mocking tools.
- **TypeScript:** structural typing makes Extract Interface nearly free — any object with the right shape satisfies the type, so fakes need no declarations. Module mocking (`jest.mock`) can substitute for several techniques during characterization, but it couples tests to file paths; for code you will keep changing, parameterize anyway.
- **Python:** `unittest.mock.patch` and monkeypatching can reach almost anything, which is exactly why restraint pays. Patching is fine for getting the first tests in place; parameterized seams (`def __init__(self, db=None)`) survive renames, document dependencies, and don't depend on import-order subtleties. Watch for import-time side effects — module-level construction defeats every technique here until you wrap it in a function.
- **The general rule:** techniques that improve the design as a side effect (Parameterize Constructor, Adapt Parameter, Extract Interface) are permanent wins — leave them in. Techniques that merely enable tests (Subclass and Override, static setters, module patches) are scaffolding — schedule their retirement once real seams exist.
