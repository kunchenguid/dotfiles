---
name: quota-axi
description: "Report local Claude, Codex, Cursor, GitHub Copilot, Grok, Kimi, Z.AI, and Antigravity quota windows via the quota-axi CLI - remaining effective usable runway, percentages, reset times, cycle-average pace vs the reset clock, a per-scope selection signal, and provider status read from local auth sources, with no routing, provider mutation, or default ordering preference. Use before deciding whether it is safe to keep spending a provider's quota, when the user asks about usage, rate limits, pace, or remaining quota, or when comparing local provider headroom."
user-invocable: false
author: Kun Chen (kunchenguid)
metadata:
  hermes:
    tags:
      - quota
      - rate-limits
      - pace
      - claude
      - codex
      - cursor
      - copilot
      - grok
      - kimi
      - zai
      - agy
      - antigravity
      - cli
    category: observability
---

# quota-axi

Report local agent-provider quota windows and model quota evidence.

You do not need quota-axi installed globally - invoke it with `npx -y quota-axi`.

quota-axi is data only: it never routes, recommends a provider, model, harness, credential, or
route, proxies, intercepts, logs in, imports browser cookies, or mutates provider state. Default
output has no ordering preference. The explicit `models --sort runway` comparator only orders
quota evidence, preserves ties, and is never a recommendation. quota-axi additionally publishes one
derived per-scope comparative selection signal, `effectiveAvailability[].selection`, as data
computed from figures it already reports; it still ranks nothing and routes nowhere, and the
consumer decides what to do with it. It reads local provider auth sources and calls
first-party provider quota, usage, billing, entitlement, local loopback, or read-only credential-liveness endpoints; it never launches the
Claude, Cursor, Grok, Pi, Kimi, opencode, or Antigravity/agy CLIs, so it cannot spend the quota it measures.

## When to use

Use quota-axi whenever you need local quota headroom before deciding whether it is safe to
keep working on a provider, when the user asks about usage, rate limits, or remaining quota,
or when comparing supported local provider headroom side by side.

## Workflow

1. Run `npx -y quota-axi` for compact TOON output covering supported providers' quota windows.
   Default TOON has three decision-shaped blocks. `quota[]` has one fully populated row per
   measurable scope: `provider`, `scope`, `effectivePercentRemaining`, `spendPriority`,
   `runway`, `confidence`, `limitedBy`, and the binding window's `resetsAt`. Sparse
   `exhaustion[]` adds `usableRunwaySeconds`, `projectedExhaustedAt`, and `limitingWindowId`
   for the scopes with a finite exhaustion point only, joined back on `provider` + `scope`;
   `exhaustion[0]:` means nothing is projected to run out. Sparse `attention[]` carries every
   non-nominal fact as `provider,scope,kind,detail,remedy` - auth, staleness, state reasons,
   rate limits, unresolved or untrusted windows, and unmeasurable bounds. Every requested provider
   appears in `quota[]` or `attention[]` or both, never silently absent, and `quota[]` rows
   are in provider-declaration order, never sorted by any metric: it is not a ranking. A scope with
   unknown or stale headroom gets no `quota[]` row at all - read its `attention[]` row instead
   of inferring a number. If that scope has finite runway, the attention detail preserves the
   runway verdict and limiting window without creating an orphan `exhaustion[]` row.
2. Scope to one provider with `--provider claude` or to a subset with `--provider cursor,copilot,grok,kimi,zai,agy`.
3. Pass `--json` for the normalized machine-readable model instead of TOON. Read
   `quotaSemantics.effectiveAvailability` rather than treating a model window in isolation:
   account windows can bound every model, and `boundedBy` names every window included in the
   effective percentage. Read `effectiveAvailability[].runway` first for completion-risk evidence
   across every authoritative bound: `projected_exhaustion` supplies the earliest finite
   `usableRunwaySeconds`, `projectedExhaustedAt`, limiting window, and confidence; `through_reset`
   deliberately has no synthetic deadline; `exhausted_now` is zero runway; and `unknown` names
   unmeasurable bounds instead of inventing a conclusion. Read each window's `pace` (and the
   effective scope's pace summary) for diagnostics. Each scope also carries `selection`: when its
   `status` is `known`, `spendPriority` is a signed, cycle-weighted scalar clamped to
   [-100, 100] where positive means that scope's paid allowance is on track to reach reset unused,
   `0` is exact utilization, and negative means it is overdrawn against the reset clock. It is
   comparable across scopes, providers, and accounts, and it is advisory data only: it never
   overrides `runway`, and quota-axi does not rank or route with it. When any bounding window has
   no usable pace, the whole scope is `status: "unknown"` with `unmeasurableWindowIds` and no
   scalar, and its TOON cell reads the literal `unknown` - never read an absent or `unknown`
   scalar as healthy, and never read it as `0`, which means exact utilization. Default TOON omits
   raw numeric reserve; `--json` and `--full` retain it. Every projection is cycle-average, so
   there is no `projectionBasis` field: its absence means `cycle_average`. If relationship status
   is `partial` or `unknown`, do not infer
   one. Stale reports keep raw windows for diagnostics, but effective availability, pace, runway,
   and selection are always unknown; never route from a stale raw percentage as though it were current
   headroom. Default output has no ordering preference. For a provider-native model evidence join,
   use `npx -y quota-axi models --intelligence high --json`. This catalog covers Claude, Codex,
   Grok, and Kimi only; its buckets are coarse editorial classifications, not scores. Its response
   includes catalog provenance and unmatched model windows. `--sort runway` is an explicit,
   documented quota-evidence comparator, not a provider, model, harness, credential, or route
   recommendation; inspect `sort.tieGroups` rather than treating equal evidence as a preference.
4. Pass `--full` to include account identity, per-source attempts, raw reserve diagnostics, and
   the derivation inputs default `--json` demotes. `--full` only ever adds, with no renames and
   no re-nesting: a demoted field is simply absent until `--full`, in the same position under the
   same name. Demoted are provider `label`/`source`, `state.refreshedAt`/`sourcesTried`,
   window `percentUsed`/`startsAt`/`windowSeconds`, the window pace cycle-progress inputs
   (`timeRemainingPercent`, `elapsedPercent`, `cycleBasis`, `cycleSeconds`,
   `projectedExhaustedAt`, `projectionConfidence`), `quotaSemantics.description`, and scope
   pace `behindWindowIds`/`onPaceWindowIds`. Everything you branch on stays in default
   `--json`: state status/auth/reason/remedy fields, window `pace.status`, `reason`,
   `reservePercentPoints` and `burnMultiple`, `quotaSemantics.status` and
   `unresolvedWindowIds`, every scope's `runway` and `selection`, scope pace
   `aheadWindowIds`/`unknownWindowIds`, and `credits` (never read `credits` as exhaustion).
5. Run `npx -y quota-axi auth` to check local auth-source availability without printing
   secret values.
6. On macOS, Claude and Cursor CLI Keychain value reads are skipped by default until the user
   grants access once. If quota output reports `reason: keychain_access_required`, tell your user
   to run `quota-axi --allow-keychain-prompt` once and approve Keychain access ("Always Allow").
   Plain calls then reuse the corresponding account-scoped access marker. Claude's marker is also
   profile-scoped and its Keychain lookup is pinned to Claude Code's validated current-user
   account. Cursor's `cli-keychain` source is used only when its non-prompting editor source has no
   usable token. On Linux, Cursor's `cli-authfile` source reads only `accessToken` from
   `${CURSOR_CLI_CONFIG}` or the XDG `cursor/auth.json` path. quota-axi never reads a Cursor
   refresh token, so an expired CLI access token requires `cursor-agent login`. Legacy Claude
   markers are not reused.
7. For Grok, read `state.authStatus` before any logout wording. `expired_refreshable` means a
   local session still looks signed in but short-lived access expired and a bounded read-only
   liveness attempt could not validate it (an empirically live stored-expired bearer reports
   fresh quota or `usable` instead). Only when quota-axi also
   emits `reason: credentials_expired` / `remedyCommand: grok` should you tell your user to
   open the Grok CLI once; Pi-only expiry has no Grok remedy because Grok cannot refresh Pi-owned
   credentials. Do not treat soft expiry as full sign-out, and do not ask quota-axi to refresh
   credentials - it never launches Grok or Pi or writes auth files. `authStatus: usable` with
   empty windows means model auth is present (Grok CLI and/or Pi `xai`) while consumer credit
   windows are unknown - not logged out. Reserve true sign-in recovery for
   `authStatus: unusable` / `Grok sign-in required`.
8. For a managed Codex installation, set `QUOTA_AXI_CODEX_BINARY` to its absolute executable
   path. quota-axi uses that exact executable for auth inspection and the read-only app-server
   fallback, and fails closed if the override is invalid. Codex OAuth availability follows the
   access token, not id_token expiry alone.
9. For Kimi, quota-axi prefers a literal Pi-managed `kimi-coding` API key from
   `$PI_CODING_AGENT_DIR/auth.json` (default `~/.pi/agent/auth.json`). If it is
   unavailable, quota-axi may reuse a fresh official Kimi Code CLI access token from
   `$KIMI_CODE_HOME/credentials/kimi-code.json` (default
   `$HOME/.kimi-code/credentials/kimi-code.json`) without refreshing or writing credentials.
   Grok also reads that same Pi auth file for an independent `xai` OAuth or literal API-key
   entry and treats Grok as usable when either the Grok CLI session or Pi `xai` credential is
   valid.
10. For Z.AI, quota-axi reads the Coding Plan API key from opencode's `auth.json`
    (`zai-coding-plan`, plus `zai`/`zhipu` aliases). It reports the five-hour and weekly token
    windows as one `all_models` bound and the monthly MCP tool window as a separate `tools`
    scope; because the endpoint is undocumented, limits quota-axi cannot identify degrade to
    untrusted `unknown` windows and turn the provider's semantics `partial` instead of
    producing a confident wrong percentage.
11. For Antigravity, quota-axi never launches `agy`. It discovers only the current user's
    already-running Antigravity/`agy` processes and owned loopback ports, then reads vendor
    `remainingFraction`/`resetTime` (or model config fallbacks). Window relationships are
    unknown, so there is no combined remaining percentage. Pace stays unknown because the
    snapshot has no honest burn-rate history.

## Usage

```
usage: quota-axi [quota|auth|models] [flags]
commands[3]:
  (none)=quota, auth, models
output:
  Default TOON reports local quota evidence. models is a deterministic data join; --sort runway is explicit opt-in ordering. --tui renders a live human terminal report instead (q quits).
flags[11]:
  --provider <claude,codex,cursor,copilot,grok,kimi,zai,agy>, --json, --full, --tui, --refresh <30s-24h>, --once, --allow-keychain-prompt, --intelligence <high|medium|low>, --sort <runway>, --help, -v/--version
examples:
  quota-axi
  quota-axi --provider claude
  quota-axi --provider agy
  quota-axi --provider cursor,copilot,grok,kimi,zai
  quota-axi --json
  quota-axi --full
  quota-axi --tui
  quota-axi --tui --refresh 1m
  quota-axi --tui --once
  quota-axi auth
  quota-axi models --intelligence high
  quota-axi models --sort runway
```

## Tips

- Output is TOON-encoded and token-efficient by default; pass `--json` only when you need
  the normalized schema.
- Exit code 0 means at least one provider returned data (fresh or stale); exit code 1 means
  every provider failed; exit code 2 means a usage error.
- Percentages are not comparable across providers - quota-axi never claims one provider's
  percentage equals another's.
- Claude `--full` output exposes the authoritative OAuth profile `account.uuid` as
  `account.accountId` when Anthropic returns one; otherwise the account identity is explicitly
  marked unverified rather than inferred.
- The quota cache at `~/.cache/quota-axi/quotas.json` only ever holds normalized
  non-secret snapshots.
  Fresh provider reports with no windows clear stale provider snapshots instead of caching
  empty quota.
  Claude local expiry metadata is advisory when an access token exists: the existing read-only
  usage request decides validity. Missing or invalid credentials without a usable token and HTTP
  401/403 retire Claude cache; only transient failures may use bounded, reset-pruned stale data
  from the same selected configuration context. Its cache-only context identifier is opaque, and
  legacy context-less Claude snapshots are not reused.
  Claude and Cursor CLI Keychain access markers live alongside it, use hashed account scope,
  and contain no credential values or raw account identity. The Claude marker is also
  profile-scoped.
