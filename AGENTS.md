# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- `configuration.nix` splits Homebrew casks into `basicCasks` (dev tooling, reusable on any future machine) and `personalCasks` (this Mac's GUI apps), gated by the `includePersonalCasks` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so `flake.nix`'s `specialArgs` must always set it explicitly). Keep new personal-only tooling behind that flag rather than hardcoding it into the shared `casks` list.
- `hostLabel` and `includePersonalCasks` in `flake.nix` are deliberately separate variables. `hostLabel` is purely cosmetic (the host's display name) and has zero effect on which casks install; `includePersonalCasks` (plain `true`/`false`) is the only thing that controls the personal-vs-basic cask profile. Don't re-merge these two concerns into one variable/flag without checking with the user first.
- Only one `darwinConfigurations` output exists (`darwinConfigurations.${hostLabel}`). `hostLabel` has no reserved values - don't reintroduce a second, fixed-name host output alongside it.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
