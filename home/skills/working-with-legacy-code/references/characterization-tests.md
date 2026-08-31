# Characterization Tests

A characterization test documents what the code actually does right now — not what the spec says, not what the comments claim, not what anyone remembers intending. On legacy code this is the only kind of test you can write honestly, because the actual behavior is the de facto specification: callers, cron jobs, spreadsheets, and customers may depend on it, quirks included. This file is the step-by-step practice: the first failing probe, choosing inputs, golden masters, snapshots, and a worked before/after refactor.

## Table of Contents

- [What They Are (and Are Not)](#what-they-are-and-are-not)
- [The Recipe](#the-recipe)
- [Choosing Inputs](#choosing-inputs)
- [Sensing and Separation](#sensing-and-separation)
- [Golden Master Testing](#golden-master-testing)
- [Snapshot Tests Done Right](#snapshot-tests-done-right)
- [When the Current Behavior Is a Bug](#when-the-current-behavior-is-a-bug)
- [Worked Example: Covering a Function Before Refactoring](#worked-example-covering-a-function-before-refactoring)

## What They Are (and Are Not)

A specification test says *"this is what the code should do"* and fails when the implementation is wrong. A characterization test says *"this is what the code does"* and fails when the behavior *changes*. The distinction sounds philosophical and is intensely practical: writing "should" tests against legacy code produces a wall of red that tells you nothing except that your imagination and the codebase disagree — and worse, tempts you to "fix" discrepancies mid-characterization, silently changing behavior that something downstream relies on.

Characterization tests have one job: clamp current behavior so you can refactor or extend with the vise closed. Some later get promoted into real specification tests with intention-revealing names; some get deleted once better tests exist. They are scaffolding, and scaffolding is allowed to be ugly as long as it holds.

## The Recipe

1. Get the code into a harness (that is the separation problem — see the seams and dependency-breaking references).
2. Write an assertion you *know* is wrong.
3. Run it. Let the failure message tell you what the code actually does.
4. Change the assertion to expect the observed value.
5. Repeat until every behavior you are about to disturb is pinned.

Step 2 is the part that feels illegal and isn't. You are not guessing the answer; you are asking the code a question, and the test runner is the conversation:

```python
def test_probe_shipping_cost():
    cost = shipping_cost(weight_kg=0, country="PL")
    assert cost == -999  # absurd on purpose
```

```text
E  assert 1500 == -999
```

So a zero-weight parcel costs 15.00 — apparently there is a minimum fee. Now pin it, and let the test name record what you learned:

```python
def test_zero_weight_parcel_charges_minimum_fee():
    assert shipping_cost(weight_kg=0, country="PL") == 1500  # observed minimum fee
```

If you can't yet explain the observed value, pin it anyway under a neutral name (`test_characterize_shipping_zero_weight`) and a comment. An unexplained pinned value is still a tripwire; an unpinned one is a future regression.

## Choosing Inputs

You are not characterizing the whole system — you are clamping the region your change will disturb. Heuristics, in order:

- **Start from the change.** Read the code path your edit will touch and write one probe per branch on that path. The point of these tests is to detect *your* mistakes, so concentrate them where you are about to make some.
- **Probe the boundaries.** Zero, negative, empty list, `None`/`null`, missing keys, maximum sizes, the day the clocks change. Legacy branches live at boundaries, and so do the bugs you must not silently fix.
- **Use coverage as a flashlight, not a target.** Run the pinned suite under `coverage.py` or `jest --coverage` and look at what is still unexecuted *in the region you'll change*. A red line next to your change point is an unpinned behavior.
- **Steal production values.** A handful of anonymized real records make better probes than invented ones — real data finds the branch you didn't see in the code.
- **Stop at the vise.** When every branch you intend to disturb has a tripwire, stop. More pins now is procrastination with a green progress bar.

## Sensing and Separation

We break dependencies for two reasons. **Separation**: we can't even get the code into a harness. **Sensing**: we can run it, but we can't see what it computed — results vanish into a database, a socket, a void return.

Sensing options, from best to last resort:

1. **Return values.** Free when they exist.
2. **A recording fake.** Inject a collaborator that remembers calls:

   ```typescript
   class FakeGateway implements PaymentGateway {
     charges: Array<{ customerId: string; amountCents: number }> = [];
     charge(customerId: string, amountCents: number): ChargeResult {
       this.charges.push({ customerId, amountCents });
       return { transactionId: "t_1", ok: true };
     }
   }
   ```

   The test asserts on `gateway.charges` — the fake is both the separation and the sensor.
3. **Extract and Override a getter** so a testing subclass can expose an intermediate value.
4. **A sensing variable**: a temporary field that records an intermediate result inside a monster method (`this.lastComputedFee = fee`). Deliberately crude — add it, characterize, refactor, delete it.

## Golden Master Testing

When output is large and structured — a rendered statement, generated XML, a 400-line report — per-value assertions are hopeless. Capture the entire output once, store it as the *golden master*, and diff against it forever:

```python
from pathlib import Path

def test_statement_matches_golden_master():
    out = generate_statement(load_fixture("acct_2231"))
    golden = Path("tests/golden/acct_2231.txt")
    if not golden.exists():
        golden.write_text(out)      # first run records the master
        raise AssertionError("Golden master recorded — review it, then rerun")
    assert out == golden.read_text()
```

Rules that keep golden masters honest:

- **Review the first capture like a code review.** Recording the master is the moment you sign off that *this* is the behavior to preserve. Read it line by line; you will usually find at least one surprise worth a ticket.
- **Normalize volatility before comparing.** Timestamps, generated IDs, hostnames, float jitter — scrub them or every run cries wolf:

  ```python
  out = re.sub(r"\d{4}-\d{2}-\d{2}", "<DATE>", out)
  out = re.sub(r"stmt_[0-9a-f]{12}", "<STMT_ID>", out)
  ```

- **Many small masters beat one big one.** One master per interesting input class (empty account, overdrawn, foreign currency) localizes failures; a single giant blob just says "something changed."
- **Regenerating the master is a behavior change.** When a deliberate change diffs the master, review the diff hunk by hunk and commit the new master *with* the change that caused it. An auto-accepted master is no master at all.

## Snapshot Tests Done Right

Jest-style snapshots are golden masters with tooling, and they fail in the same ways when treated casually:

```typescript
test("invoice email renders for an overdue account", () => {
  expect(renderInvoiceEmail(overdueAccount())).toMatchSnapshot();
});
```

- Review the first snapshot as carefully as the code that produced it — committing an unread snapshot pins garbage with confidence.
- Keep snapshots small and focused: one logical region per snapshot. Use `toMatchInlineSnapshot()` for short output so the expectation lives in the test, visible during review.
- Normalize volatile fields with property matchers: `expect(obj).toMatchSnapshot({ createdAt: expect.any(Date) })`.
- Treat `jest -u` as a behavior-change tool, not a "make CI green" button. A snapshot update in a PR deserves the same scrutiny as an assertion edit, because that is exactly what it is.

## When the Current Behavior Is a Bug

You will find bugs while characterizing — it is one of the technique's reliable side effects. The discipline: **do not silently fix them.** That report someone reconciles monthly may compensate for the wrong number; that off-by-one may be cancelled by another off-by-one downstream. A silent fix during characterization is an unreviewed behavior change hiding inside a "no behavior change" step.

The protocol:

1. Pin the wrong behavior, loudly:

   ```python
   def test_grace_period_interest_currently_double_applied():
       total = late_interest(payments_fixture("partial_in_grace"))
       assert total == 2184  # BUG? interest applied twice — TICKET-482
   ```

2. File the ticket with the failing scenario attached — the probe is a ready-made reproduction.
3. Fix it later as a deliberate behavior change: flip the assertion and the code in the same commit, so the diff documents exactly which behavior moved and why.

## Worked Example: Covering a Function Before Refactoring

The target — a pricing function with three tangled policies that we want to restructure:

```python
def price_order(order, customer, today):
    total = 0
    for line in order.lines:
        price = line.qty * line.unit_cents
        if line.qty >= 10:
            price = int(price * 0.95)        # bulk discount
        total += price
    if customer.tier == "gold" or (
        customer.since and (today - customer.since).days > 730
    ):
        total = int(total * 0.97)            # loyalty discount
    if order.coupon == "WELCOME" and not customer.orders:
        total -= 500                          # first-order coupon
    return max(total, 0)
```

**Probe round.** Five probes, each asserting an absurd value, each failure recorded as a pin. Two surprises surface: the loyalty discount applies to customers with `since` exactly 731 days ago (boundary lives at `> 730`, not `>= 730`), and `WELCOME` plus loyalty *stack*, which the product owner thought was impossible. The second gets a ticket and a loud pin.

**The pinned suite:**

```python
def test_plain_order_sums_line_prices():
    assert price(order_of(qty=2, unit=1000)) == 2000

def test_bulk_line_gets_five_percent_off_at_qty_10():
    assert price(order_of(qty=10, unit=1000)) == 9500

def test_qty_9_gets_no_bulk_discount():
    assert price(order_of(qty=9, unit=1000)) == 9000

def test_gold_customer_gets_three_percent_off_total():
    assert price(order_of(qty=2, unit=1000), customer=gold()) == 1940

def test_loyalty_kicks_in_at_731_days_not_730():
    assert price(order_of(qty=2, unit=1000), customer=since_days(731)) == 1940
    assert price(order_of(qty=2, unit=1000), customer=since_days(730)) == 2000

def test_welcome_coupon_stacks_with_loyalty():
    # BUG? stacking probably unintended — TICKET-519
    assert price(order_of(qty=2, unit=1000), customer=new_gold(), coupon="WELCOME") == 1440

def test_total_clamps_at_zero():
    assert price(order_of(qty=1, unit=100), customer=new_customer(), coupon="WELCOME") == 0
```

**The refactor, under green.** Now restructure with the vise closed:

```python
def price_order(order, customer, today):
    subtotal = sum(line_price(line) for line in order.lines)
    discounted = loyalty_adjusted(subtotal, customer, today)
    return max(discounted - welcome_credit(order, customer), 0)

def line_price(line):
    price = line.qty * line.unit_cents
    return int(price * 0.95) if line.qty >= 10 else price
```

Run the suite after each extraction. Every test stays green, so behavior — including the stacking bug and the 731-day boundary — is preserved exactly. The structure change ships as its own commit. Next sprint, TICKET-519 flips one assertion and removes the stacking in a one-line behavior change that reviews in seconds, because the characterization suite proves nothing else moved.

That is the rhythm to internalize: probe, pin, refactor under green, change behavior deliberately. The tests start as scaffolding around code nobody trusted; by the end, `line_price` and `loyalty_adjusted` are small enough to earn real specification tests, and the scaffolding can come down.
