# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- `tools.nix` is the single source of truth for every managed CLI tool and GUI app (`scope`, `platform`, `updatePolicy`, optional `isCask`/`brewName`/`nixName` - field semantics and two-stage selection logic documented in README.md under "Package metadata"). `configuration.nix` derives the Nix package list, `homebrew.brews`, and `homebrew.casks` from it via `currentPlatform`-gated selection (`isEnabled`/`isForCurrentPlatform`/`useNix`/`useHomebrew`/`useNative`); don't hand-maintain separate brew/cask lists again. `scope = "personal"` entries are gated by one shared `usePersonalSetup` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so `flake.nix`'s `specialArgs` must always supply it). `currentPlatform` is hardcoded to `"macos"`; `platform = "macos"` marks entries that should be skipped by any future Linux/Ubuntu support, `platform = "all"` entries are shared across platforms, and `platform = "ubuntu"` is reserved for future use.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
