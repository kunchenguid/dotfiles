# Design by Contract and Assertive Programming

Deep reference for making assumptions explicit through contracts and assertions. Load when guidance is needed on defensive programming, crash-early strategies, or formal precondition/postcondition patterns.

## Table of Contents
1. [Design by Contract (DBC)](#design-by-contract-dbc)
2. [Preconditions](#preconditions)
3. [Postconditions](#postconditions)
4. [Class Invariants](#class-invariants)
5. [DBC in Dynamic Languages](#dbc-in-dynamic-languages)
6. [Assertive Programming](#assertive-programming)
7. [Dead Programs Don't Lie](#dead-programs-dont-lie)
8. [Assertions vs. Error Handling](#assertions-vs-error-handling)

---

## Design by Contract (DBC)

Design by Contract was formalized by Bertrand Meyer for the Eiffel programming language, but the principle applies universally. Every function or method has a contract:

- **Preconditions:** What must be true before the routine is called (caller's responsibility)
- **Postconditions:** What the routine guarantees will be true when it finishes (routine's responsibility)
- **Class invariants:** What is always true about the object's state between method calls

### The Contract Metaphor

Think of a function like a business contract:

> "If you provide me with valid input (precondition), I guarantee I'll produce correct output (postcondition) and leave everything in a consistent state (invariant)."

If the caller violates the precondition, the contract is void -- the routine owes nothing. If the routine violates the postcondition, it's a bug in the routine. If an invariant is violated, the system is in an invalid state and should halt.

### Why Contracts Matter

| Without Contracts | With Contracts |
|------------------|---------------|
| Functions silently accept bad input | Bad input is caught immediately at the boundary |
| Bugs propagate far from their source | Bugs are detected at the point of violation |
| Debugging requires tracing through layers | Stack trace points directly to the violated contract |
| Assumptions are implicit and undocumented | Assumptions are explicit and enforced |
| Tests must guess at valid input ranges | Contracts document valid input ranges |

---

## Preconditions

A precondition defines what must be true when a function is called. It is the **caller's responsibility** to satisfy the precondition.

### Examples Across Languages

**Python:**
```python
def transfer_funds(from_account, to_account, amount):
    # Preconditions
    assert amount > 0, f"Transfer amount must be positive, got {amount}"
    assert from_account.balance >= amount, (
        f"Insufficient funds: balance={from_account.balance}, amount={amount}"
    )
    assert from_account.id != to_account.id, "Cannot transfer to same account"

    # Implementation
    from_account.balance -= amount
    to_account.balance += amount
```

**TypeScript:**
```typescript
function transferFunds(from: Account, to: Account, amount: number): void {
  // Preconditions
  if (amount <= 0) throw new PreconditionError(`Amount must be positive: ${amount}`);
  if (from.balance < amount) throw new PreconditionError(`Insufficient funds`);
  if (from.id === to.id) throw new PreconditionError(`Cannot self-transfer`);

  from.balance -= amount;
  to.balance += amount;
}
```

### Precondition Guidelines

| Guideline | Rationale |
|-----------|-----------|
| Check preconditions at the start of the function | Fail fast before any side effects |
| Use descriptive error messages | Include actual values so debugging is immediate |
| Don't correct bad input silently | If amount is negative, don't negate it -- crash |
| Document preconditions in the function's docstring | Callers need to know what's expected |
| Preconditions should be cheap to check | If validation is expensive, it's a design smell |

### What Makes a Good Precondition?

A precondition should be:
- **Verifiable:** Can be checked programmatically
- **Documented:** Callers can read and understand it
- **Minimal:** Only what's truly necessary, not overly restrictive
- **Stable:** Doesn't change between versions (it's part of the contract)

---

## Postconditions

A postcondition defines what the function guarantees upon successful completion. It is the **routine's responsibility** to satisfy the postcondition.

### Examples

**Python:**
```python
def sort_list(items: list) -> list:
    result = sorted(items)

    # Postconditions
    assert len(result) == len(items), "Sort must preserve length"
    assert all(result[i] <= result[i+1] for i in range(len(result)-1)), (
        "Result must be sorted"
    )
    assert set(result) == set(items), "Sort must preserve elements"

    return result
```

**Go:**
```go
func Divide(a, b float64) float64 {
    // Precondition
    if b == 0 {
        panic("division by zero")
    }

    result := a / b

    // Postcondition
    if math.Abs(result*b - a) > 1e-10 {
        panic(fmt.Sprintf("postcondition failed: %f * %f != %f", result, b, a))
    }

    return result
}
```

### Postcondition Patterns

| Pattern | What It Checks | Example |
|---------|---------------|---------|
| **Preservation** | Output preserves a property of input | Sorted list has same length as input |
| **Computation** | Result satisfies a mathematical relationship | `sqrt(x) * sqrt(x) ≈ x` |
| **State change** | Object state changed correctly | Account balance decreased by exact transfer amount |
| **No side effects** | Nothing unexpected changed | Other accounts' balances unchanged after transfer |
| **Return type** | Result has expected structure | API response contains required fields |

---

## Class Invariants

An invariant is a condition that must be true for every instance of a class at all times between method calls (it may temporarily be false during a method's execution).

### Examples

```python
class BankAccount:
    def __init__(self, owner: str, initial_balance: float = 0):
        assert initial_balance >= 0, "Initial balance cannot be negative"
        self.owner = owner
        self._balance = initial_balance
        self._check_invariant()

    def _check_invariant(self):
        """Class invariant: balance is never negative."""
        assert self._balance >= 0, (
            f"Invariant violated: balance={self._balance} for account {self.owner}"
        )

    def deposit(self, amount: float):
        assert amount > 0, f"Deposit must be positive: {amount}"  # precondition
        self._balance += amount
        self._check_invariant()

    def withdraw(self, amount: float):
        assert 0 < amount <= self._balance, (  # precondition
            f"Invalid withdrawal: amount={amount}, balance={self._balance}"
        )
        self._balance -= amount
        self._check_invariant()

    @property
    def balance(self) -> float:
        return self._balance
```

### Common Invariant Patterns

| Domain | Invariant |
|--------|-----------|
| **Financial** | Balance >= 0 (or >= overdraft limit) |
| **Collection** | Size >= 0 and matches actual element count |
| **Connection pool** | Active + idle = total allocated |
| **State machine** | Current state is one of the defined states |
| **Tree structure** | Every child has exactly one parent (except root) |
| **Sorted container** | Elements are in order after every mutation |

---

## DBC in Dynamic Languages

Languages like Python, JavaScript, and Ruby lack built-in contract support but can implement it through patterns:

### Guard Clauses

The most common pattern -- check preconditions at the top of every function:

```python
def process_order(order):
    if not order:
        raise ValueError("Order cannot be None")
    if not order.items:
        raise ValueError("Order must have at least one item")
    if order.total <= 0:
        raise ValueError(f"Order total must be positive: {order.total}")

    # Happy path follows...
```

### Decorator-Based Contracts (Python)

```python
from functools import wraps

def requires(condition_fn, message):
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            if not condition_fn(*args, **kwargs):
                raise PreconditionError(message)
            return fn(*args, **kwargs)
        return wrapper
    return decorator

def ensures(condition_fn, message):
    def decorator(fn):
        @wraps(fn)
        def wrapper(*args, **kwargs):
            result = fn(*args, **kwargs)
            if not condition_fn(result):
                raise PostconditionError(message)
            return result
        return wrapper
    return decorator

@requires(lambda x: x >= 0, "Input must be non-negative")
@ensures(lambda r: r >= 0, "Result must be non-negative")
def sqrt(x):
    return x ** 0.5
```

### TypeScript Runtime Validation

```typescript
import { z } from 'zod';

const TransferInput = z.object({
  fromAccountId: z.string().uuid(),
  toAccountId: z.string().uuid(),
  amount: z.number().positive(),
});

function transferFunds(input: unknown) {
  // Precondition via schema validation
  const { fromAccountId, toAccountId, amount } = TransferInput.parse(input);

  // ...implementation
}
```

---

## Assertive Programming

Assertive programming extends DBC into a general philosophy: **if it can't happen, use assertions to ensure it doesn't.**

### The "It Can't Happen" Principle

Every time you think "this can't happen," add an assertion:

```python
def get_day_name(day_number):
    match day_number:
        case 1: return "Monday"
        case 2: return "Tuesday"
        case 3: return "Wednesday"
        case 4: return "Thursday"
        case 5: return "Friday"
        case 6: return "Saturday"
        case 7: return "Sunday"
        case _:
            assert False, f"Invalid day number: {day_number}"  # "can't happen"
```

### Assertion Placement Guide

| Location | What to Assert |
|----------|---------------|
| **Function entry** | Preconditions on parameters |
| **Function exit** | Postconditions on return value |
| **After external call** | Response is in expected format |
| **Switch/match default** | "Impossible" cases |
| **After complex computation** | Sanity check on intermediate results |
| **After state mutation** | Class invariant still holds |

### Should Assertions Stay in Production?

**Yes, with caveats.** The pragmatic approach:

1. **Keep assertions that catch corruption** -- a negative bank balance, an invalid state transition, data integrity violations
2. **Remove assertions that are performance-critical** -- only after benchmarking proves they matter
3. **Never remove assertions just because "they slow things down"** -- measure first
4. **Replace expensive assertions with cheaper approximations** if performance is genuinely impacted

---

## Dead Programs Don't Lie

One of the most important pragmatic principles: **a program that crashes at the point of failure is far safer than one that limps along in an invalid state.**

### Why Crashing Is Better Than Continuing

| Behavior | Consequence |
|----------|------------|
| Crash on invalid state | Bug found at the source, stack trace points to the problem |
| Log a warning and continue | Invalid state propagates, corrupts data, discovered hours later |
| Silently ignore the error | Data loss, security vulnerabilities, mysterious downstream failures |
| Return a default value | Caller doesn't know something went wrong, makes decisions on bad data |

### Example: The Silent Corruption Problem

```python
# DANGEROUS: silently handles bad data
def get_user_age(user_data):
    try:
        return int(user_data.get("age", 0))
    except (ValueError, TypeError):
        return 0  # Silently returns 0 for invalid data

# BETTER: crashes on bad data
def get_user_age(user_data):
    age = user_data["age"]  # KeyError if missing
    if not isinstance(age, int) or age < 0:
        raise ValueError(f"Invalid age: {age}")
    return age
```

The first version will happily process users with age 0, making them ineligible for age-restricted features, because the data was silently corrupted. The second version surfaces the problem immediately.

---

## Assertions vs. Error Handling

This is a crucial distinction that many developers conflate:

| Aspect | Assertions | Error Handling |
|--------|-----------|---------------|
| **For** | Things that should NEVER happen | Things that MIGHT happen |
| **Examples** | Null pointer in non-nullable field, negative array index | Network timeout, file not found, invalid user input |
| **Response** | Crash immediately | Recover gracefully |
| **In production** | Keep (they indicate bugs) | Required (they handle expected failures) |
| **Message audience** | Developers (debugging) | Users or calling code (error recovery) |

### Decision Guide

```
Can the user cause this condition through normal use?
  → Error handling (validate input, show friendly message)

Is this a bug in the code if it happens?
  → Assertion (crash with developer-friendly message)

Can the system recover meaningfully?
  → Error handling (retry, fallback, degrade)

Is recovery just "pretend it didn't happen"?
  → Assertion (don't hide bugs behind error handling)

Is this an external system failure (network, disk, API)?
  → Error handling (these are expected in production)

Is this a violation of an internal invariant?
  → Assertion (the system is in an invalid state)
```

The pragmatic programmer uses both tools appropriately: assertions for "this should never happen" and error handling for "this might happen." The worst approach is using neither -- silently ignoring problems and hoping for the best.
