---
name: oss-contribute
description: >
  Turn usage friction into upstream OSS contributions for any dependency (skills,
  CLIs, libraries, agent tools). Use when something is broken, missing, outdated,
  or worth improving in a third-party project; when the user wants to fork, file
  or join an issue, open a PR, or follow CONTRIBUTING.md; when contributing to
  kunchenguid tools (axi, gh-axi, lavish-axi, no-mistakes, firstmate) or any
  future OSS. Issue-first: search duplicates, fork early for a local workspace,
  write a detailed contribution brief for reproduction and tests, then branch and
  implement only after guidelines and existing issues are checked.
---

# OSS contribute from usage

Convert real usage problems and feature ideas into correct upstream contributions.
Works for any project, not only the AXI / firstmate stack.

## Defaults (locked)

1. **Issue-first** - search existing issues/PRs before writing code for upstream.
2. **Fork early** - ensure a personal fork + local clone exists so work can start with full context.
3. **Brief before code** - produce a contribution brief the agent (and you) can use to reproduce, test, and implement.
4. **Guidelines win** - find and follow `CONTRIBUTING*`, PR templates, CODEOWNERS, DCO/CLA, lint/test commands.
5. **Personal rules stay local** - do not dump private agent rules into upstream; only upstream-appropriate fixes/docs/features.

## Workflow

### 1. Identify the upstream

Resolve owner/repo from what you were using:

- Skill folder → `SKILL.md` author/url, nearby README, or git remote of the vendor tree
- npm/Homebrew/cargo package → registry homepage / repository field
- Error stack / binary → `gh search`, package metadata, or project docs

If ambiguous, ask which upstream to target. Prefer the canonical GitHub (or GitLab) source of truth.

Record: `owner/repo`, default branch, license, clone path.

### 2. Load contribution rules

In the clone (or via `gh`/raw URLs), locate and read in order:

1. `CONTRIBUTING.md` / `.github/CONTRIBUTING.md` / docs "Contributing"
2. PR / issue templates under `.github/`
3. `CODE_OF_CONDUCT.md` (behavior expectations)
4. README sections on setup, tests, releasing
5. `CODEOWNERS`, DCO/CLA bots, required checks if mentioned

Summarize for the user: how to propose changes, required tests, commit/PR style, whether issues are required before PRs.

If no CONTRIBUTING file exists, fall back to: small focused PR, include repro + tests, match existing code style, link related issues.

### 3. Search before inventing

```bash
# examples - adapt query to the bug/feature
gh issue list -R owner/repo --state open --search "KEYWORDS"
gh issue list -R owner/repo --state all --search "KEYWORDS"
gh pr list -R owner/repo --state open --search "KEYWORDS"
```

Outcomes:

| Finding | Action |
|---------|--------|
| Open issue matches | Comment with your repro/environment; fork + brief still prepared; implement only if maintainers want a PR or CONTRIBUTING allows drive-by fixes |
| Closed as fixed | Verify on latest; if still broken, open a new issue referencing the old one |
| No match | Prepare to open an issue (unless CONTRIBUTING says "PR without issue is fine" for tiny fixes) |

### 4. Fork + local workspace

Run (or adapt) the helper:

```bash
scripts/prepare-contribution.sh owner/repo --slug short-topic
```

This should:

- `gh repo fork owner/repo --clone=false` (noop if already forked)
- Clone to `~/src/oss/owner/repo` (or `$OSS_CONTRIB_ROOT`) with `upstream` + `origin` remotes
- Fetch latest default branch from upstream
- Print paths and remotes for the brief

Do **not** push drive-by commits to `upstream`. All branches go to `origin` (your fork).

### 5. Write the contribution brief (required)

Before implementation, create:

`~/src/oss/owner/repo/.contribution-brief.md`

Use the template in [references/brief-template.md](references/brief-template.md).

The brief must include enough detail that another agent session can:

- Reproduce the bug or demonstrate the missing feature
- Know expected vs actual behavior
- Run the project's install/test commands from CONTRIBUTING
- Know branch name, related issue URL (or "none - will open"), and acceptance criteria

Show the brief to the user and confirm before large changes.

### 6. Issue, then branch

**If a matching issue exists:** link it in the brief; add repro details on the issue when useful; create branch `fix/<slug>` or `feat/<slug>` from updated upstream default branch.

**If none exists:**

1. Open an issue with the brief's "Problem" + "Reproduction" sections (unless guidelines forbid issues for tiny docs/typo PRs).
2. Create the same style of branch from updated upstream default branch.
3. Put the issue URL into the brief.

```bash
git fetch upstream
git checkout -b fix/<slug> upstream/main   # or upstream/master / default
```

### 7. Implement and verify

- Minimal, on-topic diff; no drive-by refactors
- Follow project test/lint commands from CONTRIBUTING
- Add/adjust tests when the project expects them
- Keep secrets and personal AGENTS.md out of the PR

### 8. Open the PR

Follow the project's PR template. Include:

- Summary + motivation from real usage
- Link to issue (`Fixes #N` when appropriate)
- Repro / test plan from the brief
- Notes on docs updates if needed

Prefer `gh pr create` from the fork against `upstream` default branch.

### 9. Capture locally useful leftovers

If something is useful for you but not appropriate upstream (personal workflows, machine-specific paths):

- Put it in dotfiles (`home/AGENTS.md` or a personal skill), not in the PR
- Optionally note "kept local" in the brief

## Triggers (examples)

- "lavish-axi fails when …"
- "no-mistakes should support …"
- "this skill's instructions are wrong"
- "fork this and let's contribute a fix"
- "find contributing guide and open a PR"

## Helper scripts

- [scripts/prepare-contribution.sh](scripts/prepare-contribution.sh) - fork, clone, remotes, branch stub, brief stub
- [scripts/find-contributing.sh](scripts/find-contributing.sh) - locate contributing/docs paths in a checkout

## References

- [references/brief-template.md](references/brief-template.md) - required brief sections
- [references/discovery.md](references/discovery.md) - resolving upstream from skills/packages
