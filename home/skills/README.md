# Agent skills library

Public Agent Skills (`SKILL.md` folders) for this machine's agent setup.
Each subdirectory is one skill: metadata plus instructions, sometimes with `scripts/`, `references/`, or `assets/`.

This tree is the source. Compatible agents load a skill when the task matches its `name` and `description`. The public Nix config in this repo does not auto-link these into every IDE; copy or install the folders you want.

## Layout

```
home/skills/<skill-name>/SKILL.md
home/skills/<skill-name>/scripts/      # optional
home/skills/<skill-name>/references/   # optional
home/skills/<skill-name>/assets/       # optional
```

Frontmatter follows the [Agent Skills spec](https://agentskills.io/specification): required `name` and `description`.

## Install / use

From a clone of this repo, point an agent at `home/skills/<name>/`, or install with the skills CLI (it walks this tree):

```sh
npx skills add kunchenguid/dotfiles --list
npx skills add kunchenguid/dotfiles --skill axi -g -a claude-code -y
```

To use one skill without installing the whole library, copy that directory into the agent's skills folder (for example `~/.claude/skills/axi`).

## What is not here

Some live-machine skills stay unpublished (private product shots, unpublished install internals, or a downloaded binary). See `docs/skills-library.md`.
`home/skills/x402/scripts/x402curl` is gitignored; it is a downloaded binary, not source.
