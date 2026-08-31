# The Legacy Code Change Algorithm

The change algorithm is the spine of *Working Effectively with Legacy Code*: a fixed, repeatable procedure for changing code that has no tests. Improvisation is how the codebase got into this state; the algorithm replaces improvisation with five steps that are individually small, individually checkable, and always done in order:

1. Identify change points
2. Find test points
3. Break dependencies
4. Write tests
5. Make changes and refactor

## Table of Contents

- [The Dilemma](#the-dilemma)
- [Edit and Pray vs. Cover and Modify](#edit-and-pray-vs-cover-and-modify)
- [Two Kinds of Change, Never Mixed](#two-kinds-of-change-never-mixed)
- [The Five Steps on a Running Example](#the-five-steps-on-a-running-example)
- [The Safety Checklist](#the-safety-checklist)
- [Triage: "I Don't Have Much Time and I Have to Change It"](#triage-i-dont-have-much-time-and-i-have-to-change-it)

## The Dilemma

To change code safely, we need tests around it. To get tests around it, we usually have to change it — extract a parameter, loosen a type, route around a singleton. The legacy code dilemma is that the safety net requires the very kind of edit it is supposed to protect.

The resolution is asymmetry. The edits you make *before* tests exist belong to a restricted class: mechanical, conservative, signature-preserving moves chosen from a known catalog (see the dependency-breaking reference). The edits you make *after* tests exist can be ambitious. You earn the right to interesting changes by making boring ones first.

Two disciplines keep the pre-test edits safe:

- **Preserve signatures.** When moving or extracting code without tests, copy method signatures exactly — cut and paste, never retype. Every keystroke you don't make is a bug you can't introduce.
- **Lean on the compiler.** In typed languages, make a deliberate change (rename a variable, alter a constructor) and let the type errors enumerate every site that needs attention. The compiler becomes a crude but exhaustive impact analysis. In dynamic languages, lean on the import system and a fast grep instead — and trust them less.

## Edit and Pray vs. Cover and Modify

*Edit and pray* is the industry default: study the code, make the change very carefully, click around the app, deploy, hope. The praying isn't a joke — it is the actual verification strategy. Care is a real input to quality, but care without feedback is just slower gambling: nothing in the process *tells you* whether the change preserved behavior.

*Cover and modify* works with a net. Tests around the code act as a software vise: they clamp existing behavior in place so that when your change wiggles something you didn't intend, a test fails now, on your machine, pointing at the exact behavior that moved. The two styles also compound differently. Every edit-and-pray session leaves the code exactly as scary as it was. Every cover-and-modify session leaves a few tests behind, so the next change in that area starts cheaper.

## Two Kinds of Change, Never Mixed

There are four reasons to change software — add a feature, fix a bug, improve the design, optimize resource usage — and they collapse into two categories:

| Kind of change | What may change | What must be preserved |
|----------------|-----------------|------------------------|
| Behavior change (feature, bug fix) | One named, intended behavior | Every *other* behavior |
| Structure change (refactoring, optimization) | Code structure, resource usage | *All* functional behavior |

The discipline: never do both in the same step. A structure change starts green and ends green with no assertion edited. A behavior change updates or adds specific, named tests — and touches nothing else. When a mixed commit breaks something, you cannot tell whether the refactoring or the feature did it; when the steps are separate, the failing test plus the last commit is the whole diagnosis.

Practically this means alternating commits: `refactor: extract PriceCalculator (no behavior change)` then `feat: prorate first-cycle charges`. Reviewers can hold the first kind to "tests unchanged and green" and the second to "exactly these assertions changed."

## The Five Steps on a Running Example

The code below is typical legacy: useful, load-bearing, and hostile to tests.

```typescript
// billing/subscription-biller.ts
export class SubscriptionBiller {
  charge(sub: Subscription): Receipt {
    const gateway = new StripeGateway(process.env.STRIPE_KEY!);
    let amount = sub.plan.priceCents;
    if (sub.plan.interval === "year") {
      amount = Math.round(amount * (1 - sub.plan.annualDiscount));
    }
    if (sub.coupon) {
      amount -= this.couponValue(sub.coupon, amount);
    }
    amount += Math.round(amount * taxRateFor(sub.country));
    const result = gateway.charge(sub.customerId, amount);
    Mailer.getInstance().sendReceipt(sub.email, result);
    AuditLog.write(`charged ${sub.id}: ${amount}`);
    return new Receipt(sub.id, amount, result.transactionId);
  }
}
```

The task: subscriptions started mid-cycle must be prorated for their first charge.

### Step 1: Identify change points

Where, exactly, will the edit live? Read until you can point at lines, not files. Here, proration affects the computation of `amount`, before tax — so the change point is the pricing block inside `charge()`. Identifying change points precisely matters because it determines *which behavior needs pinning*: everything that block currently does for existing subscriptions.

If you can't locate the change point — the feature seems to live "everywhere" — stop and use the comprehension tools from the untangling section (effect sketches, scratch refactoring) before going further.

### Step 2: Find test points

A test point is a place where you can write a test that detects the effects of your change. Change points and test points often differ: a private helper may be the change point while the public method that calls it is the only place its effects surface.

List the effects of `charge()`: the returned `Receipt`, the call to the gateway, the email, the audit line. The return value and the gateway call are the high-value sensing targets. `charge()` itself is the natural test point — *if* we can construct a `SubscriptionBiller` and substitute the gateway.

When many methods funnel through one place, that place is a **pinch point**: a narrowing in the effect graph where a few tests cover a lot of upstream behavior. Prefer pinch points when you must cover a wide area with a small test budget.

### Step 3: Break dependencies

Three blockers stand between `charge()` and a harness: the hard-wired `StripeGateway` (network), the `Mailer` singleton (SMTP), and the static `AuditLog` (filesystem). The least invasive fix for the first two is Parameterize Constructor with production defaults:

```typescript
export class SubscriptionBiller {
  constructor(
    private gateway: PaymentGateway = new StripeGateway(process.env.STRIPE_KEY!),
    private mailer: ReceiptSender = Mailer.getInstance(),
  ) {}

  charge(sub: Subscription): Receipt {
    let amount = sub.plan.priceCents;
    // ... pricing block unchanged ...
    const result = this.gateway.charge(sub.customerId, amount);
    this.mailer.sendReceipt(sub.email, result);
    AuditLog.write(`charged ${sub.id}: ${amount}`);
    return new Receipt(sub.id, amount, result.transactionId);
  }
}
```

Notes on conservatism: production call sites compile untouched because of the defaults; `PaymentGateway` is an interface extracted only as wide as this class needs (one method, not Stripe's forty); `AuditLog` is left alone for now — if it writes synchronously to disk, a test-side temp directory may be cheaper than more surgery. One technique, one commit, build green, move on.

### Step 4: Write tests

Now pin current behavior with characterization tests (full procedure in the characterization reference). Cover the branches the change will touch — monthly, annual, coupon, a couple of tax countries:

```typescript
test("monthly DE subscription pins at plan price plus 19% tax", () => {
  const gateway = new FakeGateway();
  const biller = new SubscriptionBiller(gateway, new NullMailer());
  const receipt = biller.charge(monthly({ priceCents: 3000, country: "DE" }));
  expect(receipt.amountCents).toBe(3570); // observed, not designed
  expect(gateway.charges).toEqual([{ customerId: "c_1", amountCents: 3570 }]);
});
```

The assertion records what the code *does*. If an observed value looks wrong, pin it anyway with a comment and a ticket — silently "fixing" it here would smuggle a behavior change into the safety-net step. Stop adding tests when every path through the pricing block is clamped.

### Step 5: Make changes and refactor

With the vise closed, work normally. Test-drive the new behavior: write the failing proration test, implement minimally, go green. Then — as a separate, structure-only step — clean up: the pricing block now has three tangled rules, so extract a `PriceCalculator` while the characterization tests stay green. Two commits, two kinds of change, each verifiable on its own.

## The Safety Checklist

**Before starting:**
- Working tree clean; you can revert any single step
- You can state in one sentence which behavior you intend to change — everything else must stay
- You know which kind of change each upcoming step is (behavior or structure)

**Before each dependency-breaking edit:**
- Is this the least invasive technique that unblocks a test?
- Are signatures preserved exactly — cut and paste, not retyped?
- Can the compiler or type-checker enumerate every affected site for you?

**After each dependency-breaking edit:**
- Build green; any existing tests green
- Production wiring provably unchanged (defaults still construct the real collaborators)
- Committed separately with a message that says "no behavior change"

**Before the behavior change:**
- Characterization tests pin every branch the change touches
- Each test would fail with a message that names the behavior that moved

**After the behavior change:**
- New behavior has its own intention-revealing tests
- Structure cleanups follow as separate green-to-green commits
- Any pinned bugs you decided to fix were flipped deliberately, assertion and fix in the same commit

## Triage: "I Don't Have Much Time and I Have to Change It"

The honest answer from the book: getting code under test pays back sooner than you fear — often the same afternoon, when your first regression is caught before commit. But sometimes the deadline is real and the class needs a day of dependency-breaking you do not have. Choose deliberately rather than guiltily:

| Situation | Move |
|-----------|------|
| Change is additive and plugs in at one point | Sprout Method: test-drive the new code, add one call line to the host |
| Host class won't instantiate at all | Sprout Class: new behavior in a new, fully tested class |
| Behavior surrounds the old code (logging, retry, notify) | Wrap Method or Wrap Class around the untouched original |
| A test point is reachable with minutes of work | Write the one pin test anyway — cheaper than the postmortem |
| No seams, no time, change forced inline | Pair on it, preserve signatures, single-goal editing — and file the debt ticket before you push |

Two rules make triage safe instead of corrosive:

1. **The second visit pays.** A spot that changes once can carry a sprout. The same spot changing again is the codebase telling you it is a hot path — get it under test on this visit, because you will be back.
2. **Sprout debt is visible debt.** Mark every untested host you sprouted into with a grep-able comment (`// SPROUTED: host untested — TICKET-512`) and an actual ticket. Unmarked shortcuts read as endorsed style to the next developer; marked ones read as a queue.

The algorithm looks slow on paper. In practice it is the fast path: the time sunk into dependency-breaking and pinning is bounded and front-loaded, while the time sunk into production regressions from edit-and-pray is unbounded and arrives at the worst moment. Teams that run the five steps stop being afraid of their own code — and fear, not the code, was the real bottleneck.
