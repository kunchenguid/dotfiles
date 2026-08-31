# Audience + evidence mode

The reader is a busy developer deciding in ~5 seconds. Visuals and copy exist to
**prove value**, not decorate. See also [taxonomy.md](taxonomy.md).

## Modes (legacy shorthand)

Keep these names for compatibility, but resolve them from taxonomy axes:

| Mode | Composition | Visual intensity |
|------|-------------|------------------|
| **Launch** | Public + (GUI/CLI/Agent skill) + needs memorable first screen | Medium-high, still minimum-proof |
| **Proof** | GUI / visual product | High (real screenshot) |
| **Library** | Library interface | Low (code is the hero) |
| **Infra** | Service / architecture-heavy | Low-medium (diagram only if clarifying) |
| **Internal** | Internal audience | Low (runbook) |
| **Docs-only** | Docs interface | Minimal |

## Evidence-first decision tree

```
Public + shareable?
  └─ What is PRIMARY_PROOF?
       ├─ code          → Library shape (no forced hero art)
       ├─ visual        → one real screenshot / outcome PNG
       ├─ behavioral    → terminal/workflow proof (optional one PNG)
       ├─ performance   → benchmark table/chart
       ├─ architectural → small diagram + run path
       └─ operational   → Internal runbook shape
```

Do **not** auto-expand to banner + preview + showcase.
Add each asset only when it proves something the text cannot.

## Proof, not perfume

Every image must answer one of:

1. What does success look like?
2. What does the tool produce?
3. What changed (before → after)?

## Share channels vs product interface

Twitter / Show HN can motivate polish. They must not override GitHub usefulness.
Optimize for:

- “I get it in five seconds”
- “Commands match the repo”
- “I can install this now”

Not for maximum screenshot theater.
