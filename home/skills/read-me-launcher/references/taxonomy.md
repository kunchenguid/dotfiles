# Multi-dimensional taxonomy

Do not collapse everything into one label like “app/API/service.”
Compose the README from three axes.

## INTERFACE

| Value | Typical proof |
|-------|----------------|
| GUI | Screenshot / short demo GIF |
| CLI | Terminal output or command walkthrough |
| API | Request/response example |
| Library | Copy-paste code sample |
| Agent skill | Install + example prompt + outcome preview |
| Service / worker | Architecture + run commands |
| Docs | How to read / contribute |

## AUDIENCE

| Value | Tone |
|-------|------|
| Public developer | Outsider-first, installable |
| Public end user | Product language, less toolchain jargon |
| Internal teammate | Runbook, ownership, no marketing |

## PRIMARY PROOF

Pick **one** primary proof, then add secondary only if needed:

| Value | Use when |
|-------|----------|
| Visual | UI or visual outcome is the product |
| Code | Library / SDK / API client |
| Behavioral | CLI workflow, agent workflow |
| Performance | Benchmarks are the reason to adopt |
| Architectural | Infra where topology matters |
| Operational | Internal tools / deploy runbooks |

## Composition rule

```
README shape = INTERFACE × AUDIENCE × PRIMARY_PROOF
```

Examples:

- CLI × public developer × behavioral → pitch + install + terminal proof
- Library × public developer × code → pitch + install + working snippet
- GUI × public end user × visual → pitch + screenshot + install
- Service × internal × operational → purpose + runbook + ownership
- Agent skill × public developer × behavioral → pitch + install + example ask (+ visual only if it proves output)

## Minimum proof necessary

Public + shareable does **not** automatically mean three PNGs.

Ask: what is the cheapest honest proof that makes a stranger trust the claim?

- If code proves it → code
- If a terminal line proves it → one terminal block / one PNG of that terminal
- If UI proves it → one screenshot
- Only add banner/showcase when they carry product signal, not vibes
