# Scope: which tree owns the name

Names are never global. Pick a **naming scope** before surveying.

## Scope order (highest wins)

1. **Immediate siblings** - same directory as the new file/folder
2. **Package / app root** - nearest `package.json`, `Cargo.toml`, `pyproject.toml`, or module root
3. **Git repository root** - this checkout's conventions only
4. **Sibling projects on disk** - other repos next to this one (same parent folder)
5. **House defaults** - [defaults.md](defaults.md) when greenfield

Do not copy `PascalCase` from repo A into kebab-only repo B. Survey **each**
target repo separately when naming across multiple projects.

## Multi-repo / local drive

When naming a **new project** or choosing a stem used in several places:

```bash
scripts/survey-names.sh /path/to/target-repo
scripts/survey-names.sh --siblings /path/to/parent-of-projects
```

Look at sibling folder names under common roots (`~/`, `~/src`, `~/Projects`,
`~/code`, `~/dotfiles`) and match that neighborhood. A name that fits
`quota-axi` / `lavish-axi` peers should not look like `MyCoolThing`.

If the user points at a specific drive path, survey that path - do not assume
the current workspace style applies everywhere.

## Files (yes, including ordinary source files)

Every new file name must match **sibling basenames + extension** in that folder.

| Situation | Do |
|-----------|----|
| New util next to `rate-limit.ts` | `foo-bar.ts` |
| New util next to `rateLimit.ts` | `fooBar.ts` |
| New component next to `QuotaCard.tsx` | `ThingCard.tsx` |
| New Python next to `rate_limit.py` | `foo_bar.py` |
| New test | mirror source + local suffix (`.test.ts`, `_test.go`) |

File names are first-class; never invent a random basename because "it's just a file."

## System / config / tooling files

Prefer **exact tool idioms** over creative spelling. Match what already exists
in the repo, then OS/tool norms:

| Kind | Prefer | Avoid inventing |
|------|--------|-----------------|
| Env templates | `.env.example`, `.env.sample` | `.environment`, `env.local.backup` |
| Compose | `docker-compose.yml`, `compose.yaml` | `DockerCompose.yaml` if peers use compose |
| CI | `.github/workflows/<kebab>.yml` | spaces, Title Case |
| Nix | `flake.nix`, `home.nix`, `configuration.nix` | random `.nix` stems |
| Agent docs | `AGENTS.md`, `CLAUDE.md`, `CODEX.md` | `agents-readme.md` beside those |
| Git | `.gitignore`, `.gitattributes` | custom variants unless required |
| Package manifests | `package.json`, `Cargo.toml`, `pyproject.toml` | renamed manifests |
| Make/Task | `Makefile`, `Justfile`, `Taskfile.yml` | match existing |
| Dotfiles / XDG | follow existing `~/.config/<tool>/` layout | new top-level clutter |

If a tool requires a fixed filename, use that name. Do not "improve" it.

## Cross-cutting stems

When one stem produces many artifacts (repo, skill, env prefix, branch):

1. Lock the **kebab stem** in the owning scope (`read-me-launcher`)
2. Derive the rest with [rules.md](rules.md) (`READ_ME_LAUNCHER` for env, etc.)
3. Re-survey each destination if those destinations live in different repos
