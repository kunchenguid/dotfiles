# Naming rules by kind

Infer the dominant pattern from neighbors. These are defaults when mixed.

## Projects / repos

- Prefer **kebab-case** product names: `beatforge-axi`, `quota-axi`, `baby-menu`
- One concept per token; avoid `my-app-final`
- Mirror org style when cloning into `~/src/<org>/`

## Packages / workspace members

- Match existing workspace names (`frontend`, `backend`, `docs`, `scripts`,
  `infrastructure`)
- npm package names: follow `package.json` `name` scope already used
  (`@org/foo` vs bare `foo`)

## Directories

- **kebab-case** for new dirs (`user-settings`, `grok-quota`)
- Plural only when the existing tree plurals (`scripts/`, `tasks/`)
- Do not introduce spaces or PascalCase folders next to kebab siblings

## Source files (TS/JS/Python)

- Always survey the **target directory** first; file names follow siblings
- TS/JS modules: match folder (often **kebab-case** `rate-limit.ts` or
  **camelCase** `rateLimit.ts` - copy siblings)
- Python: **snake_case** `rate_limit.py`
- Extensions stay conventional for the language (`.tsx` for React components
  if peers use `.tsx`)

## System / config / tooling files

- Prefer fixed idiomatic names the toolchain expects
- Env templates: `.env.example` / `.env.sample` (match peers)
- Compose: match existing (`docker-compose.yml` vs `compose.yaml`)
- CI: `.github/workflows/<kebab>.yml`
- Agent/docs: keep `AGENTS.md`, `CLAUDE.md`, `README.md` spelling exact
- Nix: keep `flake.nix`, `home.nix`, `configuration.nix` when those exist
- See [scope.md](scope.md) before inventing a clever config basename

## Components (React / UI)

- **PascalCase** files and exports: `QuotaCard.tsx`, `BabyMenuLayout.tsx`
- Colocate tests as siblings prefer: `QuotaCard.test.tsx` if that is the local
  pattern; otherwise `__tests__/QuotaCard.test.tsx`

## Tests

- Mirror source name + suffix used nearby: `.test.ts`, `.spec.ts`, `_test.go`

## Env vars / Automic Vault keys

- Env: `SCREAMING_SNAKE_CASE`
- When Automic / project index conventions exist:
  - Providers: `PROVIDER_<VENDOR>_<KEY>` (e.g. `PROVIDER_ANTHROPIC_API_KEY`)
  - Projects: `PROJECT_<SLUG>_<KEY>` (e.g. `PROJECT_5432WIRE_BACKEND_GROK_API_KEY`)
- Never invent lowercase env keys beside existing screaming-snake keys

## Git branches

- Match repo default: often `feat/...`, `fix/...`, kebab after slash
- Examples to prefer if present: `feat/quota-widget`, not `FeatureQuotaWidget`

## Skills / agent packs

- **kebab-case** skill folders: `read-me-launcher`, `consistent-naming`,
  `baby-menu-design`
- Optional org prefix already in use: `aas-*`, `cyber-*`, `*-axi`

## CLI commands / flags

- Commands: kebab or single word matching existing CLIs (`av`, `gm-cli`,
  `buzz`)
- Flags: `--kebab-case`

## API routes / DB

- Routes: match framework style already in repo (`/api/v1/users` vs
  `/users`)
- Tables: snake_case unless ORM models are PascalCase elsewhere - stay
  aligned with migrations
