# Contribution brief template

Fill every section before implementing. This file is for local agent use (`.contribution-brief.md`); do not commit it unless the project wants it.

## Problem

- What broke or is missing?
- Where did you hit it (skill name, CLI command, IDE, version)?
- Severity: crash / wrong result / missing feature / docs gap

## Expected

What should happen?

## Actual

What happened instead? Paste errors, exit codes, screenshots paths, or logs.

## Reproduction

Minimal steps from a clean state:

1. …
2. …
3. …

Include OS, tool versions (`cli --version`, commit SHA if known), and relevant env flags.

## Existing issues / PRs

- Search queries used:
- Matches (URLs):
- Decision: comment on #N / open new issue / tiny fix without issue (cite CONTRIBUTING)

## Upstream guidelines summary

From CONTRIBUTING / templates:

- Issue required before PR? yes/no
- Test/lint commands:
- Commit/PR conventions:
- CLA/DCO/other:

## Workspace

- Upstream:
- Fork:
- Local clone:
- Branch:
- Related issue URL:

## Acceptance criteria

- [ ] Repro (or feature demo) documented and verified locally
- [ ] Project tests/lint pass (`…`)
- [ ] Scope limited to this change
- [ ] Docs updated if user-facing
- [ ] PR body links issue and includes test plan

## Out of scope / keep local

Anything useful only for personal agent rules or machine setup (belongs in dotfiles, not upstream).
