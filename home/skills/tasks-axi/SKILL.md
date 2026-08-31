---
name: tasks-axi
description: "Manage a task backlog through the tasks-axi CLI - add, list, show, start, and complete tasks; track blocked-by dependencies, structured holds, and a ready queue; prune and normalize a hand-editable backlog.md. Use whenever a task touches backlog or task state: filing or dispatching work, recording a PR or report on completion, finding dispatchable or held work, or trimming the Done list."
user-invocable: false
author: Kun Chen (kunchenguid)
metadata:
  hermes:
    tags: [tasks, backlog, planning, dependencies]
    category: productivity
---

# tasks-axi

Agent ergonomic task & backlog manager for the current workspace. Prefer this over hand-editing backlog.md for task state, dependency, or hold changes.

You do not need tasks-axi installed globally - invoke it with `npx -y tasks-axi <command>`.
If tasks-axi output shows a follow-up command starting with `tasks-axi`, run it as `npx -y tasks-axi ...` instead.

tasks-axi operates on a hand-editable `backlog.md` in the current workspace (or the path set in `.tasks.toml`). It edits the file in place with a byte-exact round-trip, so the human-readable backlog stays the source of truth.

## When to use

Use tasks-axi whenever a task touches the backlog: filing or dispatching work, moving a task through queued -> in flight -> done, recording a PR url or report path on completion, tracking blocked-by dependencies, pausing dispatch with structured holds, finding dispatchable ready work or intentionally held work, or trimming the Done list.

## Workflow

1. Run `npx -y tasks-axi` with no arguments for a dashboard of the current backlog - in flight work, queued work with blockers, and suggested next commands.
2. Drill in verb-first: `list`, `show <id>`, `ready`, then mutate with `add`, `start`, `done`, `block`/`unblock`, `hold`/`unhold`, `update`.
3. The long notes never appear in `list`; run `show <id> --full` to read a task's complete body before replacing it.
4. `add` takes a caller-supplied id (the join key), e.g. `tasks-axi add fm-x "title" --kind ship --repo firstmate --start`; or pass `--mint` to generate a slug-xx id from the title.
5. `done <id> --pr <url>` (or `--report <path>`) closes a task, records the link, and prunes the Done list (archived, never deleted). Then `ready` shows work it unblocked.
6. `hold <id> --reason "<text>"` pauses dispatch without prose parsing; `ready` excludes active holds by default, and `ready --include-held` shows a separate held group.
   Use `--until YYYY-MM-DD` for a date gate that becomes inactive on and after that date.
7. Human-readable responses include contextual next-step hints under `help:` when there is a useful follow-up - follow them.
8. `--json` mutation responses skip `help:` and return the deterministic result object instead.

## Commands

```
commands[19]:
  (none)=dashboard, add, list, show, start, done, reopen, update, rm, block, unblock, hold, unhold, ready, public-followup, mv, prune, render, setup
```

Run `npx -y tasks-axi --help` for global flags, or `npx -y tasks-axi <command> --help` for per-command usage.

## Tips

- Output is TOON-encoded and token-efficient; the long task body is truncated by default - the whole point is that `list` stays cheap.
  Use `--full` only when you need the complete notes.
- Every write leads with an `ok:` line confirming the write result, including the resulting task state when the command changes one (e.g. `ok: start <id> -> In flight`, `ok: done <id> -> Done (pr <url>)`, `ok: render -> normalized <n>`), then state-aware next-step hints.
  Mutations are idempotent and add `already: true` on a no-op; re-running is safe.
- Pass `--json` to any mutation (`add`, `start`, `done`, `reopen`, `update`, `rm`, `block`, `unblock`, `hold`, `unhold`, `mv`, `prune`, `render`) for a machine-readable result object (`{ "ok": true, "action": ..., "task": { ... } }` or operation-specific result fields) instead of TOON - confirm a write deterministically without a follow-up read.
- `block <id> --by <other>` and `unblock` manage the dependency graph; `hold <id> --reason "<text>" [--until YYYY-MM-DD]` and `unhold` manage structured dispatch pauses; `ready` lists only queued work with no unresolved blocker and no active hold.
- Filter `list` with `--state`, `--repo`, `--kind`, `--blocked`, `--limit`, and add columns with `--fields a,b,c`.
  Use `list --state held` or `--fields held,hold_reason,hold_kind,hold_until` when scanning active hold state.
- Existing prose markers such as `HELD`, `PARKED`, `DEFERRED`, `CAPTAIN-DECISION`, and `do not dispatch` stay prose until intentionally migrated.
  Preserve the original prose as the hold reason, then choose `captain`, `parked`, `future`, `load`, or `external` only when the text supports that bucket.
- Note writes are inspect-then-update: run `show <id> --full`, then replace the curated current body with `update <id> --body "<text>"` or `--body-file <path>`.
  Add `--archive-body` to preserve the superseded body in `note-archive.md`; `--title "<text>"` replaces the title; `render` normalizes the file; `mv <id> [<id>...] --to <path>` moves one or more tasks to another backlog in one atomic transaction - pass a whole connected set (a blocker and its dependents) to move it together and preserve its `blocked-by` links and reason strings; moves that would strand an endpoint are refused.
- Free-form (no-id) backlog lines are preserved verbatim and are never modified.
