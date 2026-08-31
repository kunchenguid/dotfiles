# Skills library publish notes

Catalog of what was published from the live `home/skills/` tree into this public repo, what was left out, and how listing on agentskills.io actually works.

Queried 2026-08-30 via the Agent Skills docs MCP at `https://agentskills.io/mcp` (Streamable HTTP). That server is read-only search over the public docs site, plus `submit_feedback` for documentation issues. It does not upload, register, or list skills.

## Published

- Path: `home/skills/<name>/`
- Count: 238 skill directories, each with a valid `SKILL.md` (`name` + `description` frontmatter)
- Content: byte-for-byte from the live tree, except excluded skills and the gitignored `x402curl` binary
- Install: `npx skills add kunchenguid/dotfiles` (the CLI recursive-discovers `home/skills/`). See `home/skills/README.md`.

## Exclusions

One line each. Borderline cases were excluded rather than sanitized.

- `add-skills-repo` - documents the live machine's unpublished Home Manager vendor layout (`cyber-skills`, `aas-skills`, `skills-by-agent`, `link-agent-skills.sh`), which is not in this public repo
- `baby-menu-design` - private product screenshots under `scraps/` and `uploads/`, plus live Baby Menu UI internals
- `bootstrap-agent-tooling` - documents unpublished `~/.dotfiles/scripts/repo-bootstrap` and `~/.local/state/repo-bootstrap` internals
- `browser-e2e-testing` - documents unpublished live-machine `chromium-cli` install paths (`~/.dotfiles/scripts/install-playwright-cli.sh`, `installPlaywrightCli` in home.nix)
- `home/skills/x402/scripts/x402curl` (file only; skill published) - gitignored downloaded binary, not source

Skills with example emails (`john@company.com`, `your.email@institution.edu`), fake test secrets (`read-me-launcher/tests/fixtures/bad-secret`), or namespaced directory names (`mengto-*` dirs whose `name:` omits the prefix) were kept. Those are not live secrets or personal data.

## agentskills.io listing

Source: [CONTRIBUTING.md](https://github.com/agentskills/agentskills/blob/main/CONTRIBUTING.md) and the MCP docs tree (`/home.mdx`, `/clients.mdx`, `/specification.mdx`).

**There is no skill directory on agentskills.io.** Explicit: "Skill submissions - We don't maintain a directory of community skills." The site is the spec, authoring guides, and a Client Showcase of *agent products* that can load `SKILL.md`.

What this MCP session can do:

- Search and read the published docs (done)
- `submit_feedback` for docs bugs (not used; no docs defect to report)
- Not: upload a skill, open a listing, or mutate anything else

How the skills become usable after this PR merges:

1. They live at `https://github.com/kunchenguid/dotfiles/tree/main/home/skills`
2. Agents and the [skills CLI](https://github.com/vercel-labs/skills) install them with `npx skills add kunchenguid/dotfiles`
3. [skills.sh](https://skills.sh) ranks public GitHub skill repos from anonymous CLI install telemetry. No account and no paid listing. Appearance on the leaderboard is a side effect of public installs, not a form on agentskills.io.
4. Optional later: add `skills.sh.json` at the repo root to group the skills.sh repo page ([customize docs](https://www.skills.sh/docs/customize)). Not required for install.

### Client Showcase (agent products, not this skill tree)

To list a *product* on https://agentskills.io/clients, the product must already discover and execute skills in public. Then, as a GitHub user with a fork of [agentskills/agentskills](https://github.com/agentskills/agentskills):

1. Add light and dark logos under `docs/images/logos/` (SVG preferred; PNG min 200x200)
2. Add a client object to `docs/snippets/clients.jsx`
3. In the PR description: product name, product URL, and a docs URL that shows the Skills implementation
4. Disclose any AI assistance in that PR
5. Anthropic may ask for a demo or screenshot

This is GitHub-account-gated (fork + PR). It is free. Do not file it for the dotfiles skill library; the showcase is not a skill catalog.

## firstmate public `skills/`

[kunchenguid/firstmate](https://github.com/kunchenguid/firstmate) already publishes installer-facing skills under `skills/` (currently `stow`). Internal firstmate-only skills live in `.agents/skills/` with `metadata.internal: true` and are hidden from default `npx skills` discovery.

Same listing path as this repo:

- Install: `npx skills add kunchenguid/firstmate` (discovers `skills/` natively)
- agentskills.io still has no skill upload
- Listing firstmate itself on the Client Showcase is a separate product PR (logos + skills-implementation docs), to be filed by the captain from an account that can open PRs on `agentskills/agentskills`
