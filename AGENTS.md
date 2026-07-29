# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- `configuration.nix` splits both Homebrew `brews` and `casks` into `basicBrews`/`basicCasks` (dev tooling) and `personalBrews`/`personalCasks` (this Mac's GUI apps and personal tools), combined via one shared `includePersonalCasks` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so `flake.nix`'s `specialArgs` must always supply it). One toggle deliberately gates both lists - don't add a separate `includePersonalBrews`.
- `hostLabel` (host name) and `includePersonalCasks` (brews/casks profile) are independent variables in `flake.nix` - keep them that way rather than deriving one from the other.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
