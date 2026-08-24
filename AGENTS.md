# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- Private-file pattern: for any per-machine secret (Hetzner host, SSH private hosts), keep a gitignored real file (`home/.config/zsh/private-env.zsh`, `home/.ssh/dotfiles.config.private`) alongside a committed `.example` template, and have the relevant `home.nix` module read/Include it by path so Nix never embeds the content in the store. Follow this same shape for the next private value instead of inventing a new mechanism.
- SSH config is fragment-managed, not whole-file-managed: `~/.ssh/config` itself is never a home-manager-generated file (Colima and other tools must be free to rewrite it). `home.nix` only symlinks `home/.ssh/dotfiles.config.public.{darwin,linux}` and `dotfiles.config.private` into `~/.ssh/`, then an activation script idempotently prepends `Include` lines for them. Do not reintroduce a `programs.ssh`-style whole-config approach.
- `tools.nix` is the single source of truth for every managed CLI tool and GUI app; README.md's "Package metadata" section owns the field semantics and selection logic. `tool-selection.nix` holds the shared predicates parameterized by `currentPlatform`; don't hand-maintain separate brew/cask/Linux package lists. `configuration.nix` hardcodes macOS selection, while `home.nix` derives the platform per macOS/Ubuntu output, since a single file-level constant can't be right for both targets at once. `scope = "personal"` entries are gated by one shared `usePersonalSetup` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so both `specialArgs` and the Linux outputs' `extraSpecialArgs` in `flake.nix` must always supply it). Any `home.nix` line shared between the macOS and Ubuntu branches must be explicitly gated per platform; `tests/ubuntu-support.test.sh` pins the macOS drvPath and fails if Linux-only work leaks into the macOS derivation.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
