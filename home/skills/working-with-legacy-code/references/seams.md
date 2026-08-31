# Seams: A Field Catalog

A seam is a place where you can alter behavior in your program without editing in that place. Every seam has an **enabling point**: the place where you decide which behavior runs. Getting legacy code under test is mostly a hunt for seams — spots where a test can substitute a slow, global, or external dependency while the production source stays untouched. This file catalogs the seam types with code, then maps them onto modern stacks.

## Table of Contents

- [Why Seams Matter](#why-seams-matter)
- [Object Seams](#object-seams)
- [Link and Import Seams](#link-and-import-seams)
- [Preprocessing Seams](#preprocessing-seams)
- [Enabling Points](#enabling-points)
- [Seams in Modern Stacks](#seams-in-modern-stacks)
- [Choosing the Cheapest Seam](#choosing-the-cheapest-seam)
- [Traps](#traps)

## Why Seams Matter

Characterization is only honest if the code under test is the code that runs in production. The moment you edit logic to make it testable, you are characterizing the edit, not the system. Seams resolve this: the substitution decision happens *somewhere else* — a subclass, a module registry, a build flag — and the function or class under test executes byte-for-byte as deployed. When a class has no seams at all, you don't reach for heavier mocking; you reach for the dependency-breaking catalog, whose whole purpose is to *create* seams with minimal, behavior-preserving edits.

## Object Seams

The default seam in object-oriented code. Any call that can be overridden through polymorphism is an object seam:

```typescript
class InvoiceMailer {
  send(invoice: Invoice): void {
    const body = this.render(invoice);
    this.deliver(invoice.customerEmail, body); // <- object seam
  }

  protected deliver(to: string, body: string): void {
    smtp.send(to, body); // the part we must not run in tests
  }

  protected render(invoice: Invoice): string {
    /* 80 lines of formatting we want to characterize */
  }
}
```

The call to `this.deliver(...)` is a seam because a subclass can change what it does without touching `send()` or `render()`:

```typescript
class TestableInvoiceMailer extends InvoiceMailer {
  sent: Array<[string, string]> = [];
  protected override deliver(to: string, body: string): void {
    this.sent.push([to, body]); // record instead of sending
  }
}

test("renders overdue invoices with a late banner", () => {
  const mailer = new TestableInvoiceMailer();
  mailer.send(overdueInvoice());
  expect(mailer.sent[0][1]).toContain("OVERDUE");
});
```

Constructor injection is the same seam moved to the object's boundary — `new InvoiceMailer(transport)` makes the substitution explicit and reusable rather than requiring a subclass per test.

The crucial negative: a call to `new StripeGateway()` or to a static method is **not** an object seam. There is no polymorphism to exploit; nothing a test can vary. Hard-wired construction, statics, and globals are precisely the places where object seams are missing, and techniques like Parameterize Constructor and Extract and Override Factory Method exist to install them.

## Link and Import Seams

A link seam swaps an implementation at build, link, or load time, with zero edits to the code under test. The classic forms are linker substitution in C and classpath ordering in Java: point the build at a different object file or jar containing a fake, and every caller gets the fake.

The modern, everyday form is module interception. In Jest, the module registry is the enabling point:

```typescript
// billing.ts
import { sendEmail } from "./mailer";

export function closeAccount(id: string): void {
  const owner = repo.ownerOf(id);
  // ... teardown logic ...
  sendEmail(owner, "Your account is closed");
}
```

```typescript
// billing.test.ts
jest.mock("./mailer"); // link seam: replaces the module before import resolution
import { sendEmail } from "./mailer";
import { closeAccount } from "./billing";

test("closing an account notifies the owner", () => {
  closeAccount("a1");
  expect(sendEmail).toHaveBeenCalledWith("o1", "Your account is closed");
});
```

In Python the same seam is `unittest.mock.patch` (or pytest's `mocker` / `monkeypatch`), and the classic trap is patching the wrong name. Patch where the name is *used*, not where it is defined:

```python
# billing.py
from mailer import send_email

def close_account(account_id):
    owner = repo.owner_of(account_id)
    send_email(owner, "Your account is closed")
```

```python
def test_close_account_notifies_owner(mocker):
    fake = mocker.patch("billing.send_email")  # NOT "mailer.send_email"
    close_account("a1")
    fake.assert_called_once_with("o1", "Your account is closed")
```

`billing.py` bound the name `send_email` into its own namespace at import time; patching `mailer.send_email` after that rebinding changes nothing the function will ever see.

Link seams are wonderful for characterization because the production file is untouched. Their cost is coupling: the test now encodes the module layout (`"./mailer"`, `"billing.send_email"`), so file moves and renames break tests even when behavior is identical.

## Preprocessing Seams

In C and C++, the preprocessor runs before the compiler, so macros can redirect behavior before the code ever compiles:

```c
/* db_access.c */
#ifdef TESTING
  #define db_write(table, rec) fake_db_write(table, rec)
#endif
```

The enabling point is the preprocessor definition (`-DTESTING` in the build). Include-path substitution works the same way: the test build resolves `#include "db_access.h"` to a header full of fakes.

Preprocessing seams are powerful and unsubtle: the code under test is *literally different code* in the test build. Reserve them for environments with no better option — embedded targets, vendor headers, code where even adding an interface is too invasive. Languages outside the C family effectively don't have this seam, and don't miss it.

## Enabling Points

For every seam, ask: *where is the decision made?* That place is the enabling point, and it must be reachable from your test.

- Object seam → the place the object is created or passed in. If construction happens inside a private method of the class under test, the seam exists but you can't reach its enabling point — you need a factory method to extract and override, or a parameter.
- Link/import seam → the module registry or patch target, reachable from the test file by name.
- Preprocessing seam → the build configuration.

"Seam without a reachable enabling point" is the diagnosis behind most "this class is untestable" complaints. The fix is never to test through the UI or the database out of resignation; it is to install a reachable enabling point with the smallest dependency-breaking move available.

## Seams in Modern Stacks

**DI containers (NestJS, Spring, .NET).** The container's wiring configuration is one giant enabling point. Override a provider in a testing module and every consumer gets the fake — no patching, no subclasses:

```typescript
const moduleRef = await Test.createTestingModule({
  providers: [
    BillingService,
    { provide: PaymentGateway, useValue: fakeGateway }, // enabling point
  ],
}).compile();
```

If the codebase already has a container, prefer this seam — it is designed for exactly this substitution and survives refactors that break import-path mocks.

**Config and environment seams.** Scattered `process.env.FEATURE_X` / `os.environ[...]` reads are hidden global inputs. Funneling them through one config object turns configuration into an injectable seam (`new App(config)`), and incidentally documents every knob the system has. Until then, `monkeypatch.setenv("FEATURE_X", "1")` is the import-seam equivalent — workable, global, and easy to leak between tests.

**Clock seams.** Hard-wired `Date.now()` / `datetime.now()` makes time-dependent behavior untestable and flaky. Either install an object seam (inject a `Clock` or a `now()` function with a production default) or use the runtime's link seam: `jest.useFakeTimers()`, Python's `freezegun`, or `time-machine`. For characterization, freezing time is fine; for code you own long-term, the injected clock reads better and works in every runtime.

**Network boundary seams.** Tools like `nock`, MSW, and Python's `responses` fake at the HTTP layer — a link seam at the socket. They shine when characterizing code whose main job is *building requests*: the assertion is the captured request itself. For everything else, faking your own gateway interface is cheaper and less brittle than replaying wire formats.

## Choosing the Cheapest Seam

Order of preference when you need a seam *now*:

1. **An object seam that already exists** — a constructor or method parameter someone had the sense to add. Zero edits; just pass the fake.
2. **An import/link seam** — zero production edits, full speed for characterization. Accept the test-to-layout coupling consciously.
3. **Create an object seam** with Parameterize Constructor, Extract and Override Factory Method, or Adapt Parameter — a small, signature-preserving production edit that pays rent forever after.
4. **Preprocessing seam** — C/C++ last resort.

The split to internalize: options 1-2 are for *getting tests in place today*; option 3 is the investment that makes the next person's options 1 obvious. A reasonable team policy is "characterize through link seams freely, but any file you change substantively leaves with at least one real object seam."

## Traps

- **Patch-everything tests.** Ten `mocker.patch` lines before one assertion means the test pins the file layout and call graph, not behavior. Each refactor breaks the test while the system still works — the inverse of what tests are for. Prefer one fake at a real boundary.
- **Drifting fakes.** Import-seam mocks don't fail when the real signature changes. Use `autospec=True` in Python and typed helpers like `jest.mocked(...)` in TypeScript so fakes break loudly when reality moves.
- **Seam at the wrong layer.** Faking the ORM's query builder to test pricing logic means asserting SQL strings forever. Move up: fake the repository the pricing code actually talks to. If no such boundary exists, that is the missing seam to install.
- **Editing while characterizing.** If your "seam" required rewriting the logic you are trying to pin down, you no longer have a characterization — you have a guess wearing one. Back out, pick a seam at a distance, and keep the code under test identical to production.
- **Singleton state bleeding between tests.** Any seam that mutates global state (static setters, env patches, module mocks) needs a guaranteed reset — an autouse fixture or `afterEach` — or test order starts mattering, which is its own kind of legacy.
