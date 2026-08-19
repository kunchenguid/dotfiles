# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- `tools.nix` is the single source of truth for every managed CLI tool and GUI app (`scope`, `platform`, `updatePolicy`, optional `isCask`/`brewName`/`nixName` - field semantics and two-stage selection logic documented in README.md under "Package metadata"). `tool-selection.nix` holds the shared `isEnabled`/`isForCurrentPlatform`/`useNix`/`useHomebrew`/`useNative` predicates, parameterized by `currentPlatform`; don't hand-maintain separate brew/cask/Linux package lists. `configuration.nix` (macOS) hardcodes `currentPlatform = "macos"`; `home.nix` (macOS + Ubuntu, via `flake.nix`'s `darwinConfigurations.mac` and `homeConfigurations."<user>@<system>"` outputs) derives it per-output from `pkgs.stdenv.isDarwin`/`isLinux` instead, since a single file-level constant can't be right for both targets at once. `scope = "personal"` entries are gated by one shared `usePersonalSetup` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so both `specialArgs` and the Linux outputs' `extraSpecialArgs` in `flake.nix` must always supply it). Any `home.nix` line shared between the macOS and Ubuntu branches (a path, an OS-specific alias) must be explicitly gated per platform - an ungated edit that looks harmless on macOS still changes `darwinConfigurations.mac`'s evaluated derivation; `tests/ubuntu-support.test.sh` pins that drvPath and fails if it moves. `useNative` (fast-moving `platform=all` tools on Ubuntu: claude-code/codex/herdr/skills/pi-coding-agent) is correctly selected but has no actual installer wired up yet.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
