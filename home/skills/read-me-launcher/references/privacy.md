# Privacy and visibility

## Detect visibility

Prefer `scripts/inspect-repo.sh` output (`visibility: public|private|unknown`).

Fallback:

```bash
gh repo view --json isPrivate,visibility,url,nameWithOwner
```

If `gh` fails or there is no remote, treat as **private-safe**: publish only what
a new teammate needs to run locally, nothing that assumes the world is watching.

## Public repos

Safe and expected:

- Purpose, features, install, run, test, contribute, license
- Architecture overview at a high level
- Public docs URLs, Discord/Slack invite if intentional
- Example config with **fake** values clearly marked as examples

Avoid:

- Staging/production hostnames that are not meant to be public
- Customer names, deal details, or unreleased product codenames
- Exact internal org chart / on-call rotation unless already public

## Private repos

Optimize for teammates and agents:

- Why the repo exists and who owns it (team name, not personal phones)
- Exact local run path used in this monorepo/org
- Pointers to internal docs (Notion/Confluence) by title/URL if those links are
  already shared with the team
- Less marketing language; more runbook clarity

Still never put secrets in the README. Private does not mean "safe to paste `.env`".

## Deny-list (never write these into README)

- API keys, tokens, passwords, private keys, session cookies
- Connection strings with credentials (`postgres://user:pass@...`)
- Contents of `.env`, `ai-keys.env`, `credentials.json`, `auth.json`
- AWS access key IDs / secret keys, GitHub PATs, Stripe live keys
- Auth headers, Bearer tokens, webhook signing secrets
- Machine-local absolute paths that embed usernames **when avoidable**
  (prefer `$HOME`, `~/src/...`, or repo-relative paths)
- Screenshots that show secrets, private dashboards, or PII

## Env var documentation pattern

Document **names and purpose**, not values:

```markdown
| Variable | Required | Purpose |
|----------|----------|---------|
| `DATABASE_URL` | yes | Postgres connection URL |
| `OPENAI_API_KEY` | yes | Model provider auth |
```

For examples use obviously fake values:

```bash
export OPENAI_API_KEY=sk-example-not-a-real-key
```

## Automated scan (partial)

`scripts/check-readme.sh` fails on common credential shapes in the README text:

- GitHub PATs (`ghp_` / `gho_` / …)
- AWS access key IDs (`AKIA…`)
- OpenAI-like `sk-…` keys (skips obvious fakes like `sk-example`)
- Stripe `sk_live_…`, Slack `xox…`, Bearer tokens
- DB URLs with embedded passwords
- PEM private key blocks

This is **pattern scanning**, not a full secret-management system. Residual risk
remains (novel formats, secrets in images). Prefer wording “scans for common
secret patterns” over absolute “secret-proof.”

## Pre-flight checklist

Before finishing a README:

- [ ] `check-readme.sh` passes (includes secret pattern scan)
- [ ] Visibility mode matches public vs private guidance
- [ ] Install/run commands match the repo's real toolchain
- [ ] `.env.example` referenced if it exists; never paste live `.env`
- [ ] Screenshots do not show private dashboards or tokens
