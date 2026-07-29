# Project notes for agents

Deliberate decisions in this repo - do NOT silently revert them:

- `homebrew.onActivation.cleanup = "zap"` in `configuration.nix` is intentional. It forces the good habit of declaring every Homebrew package in the Nix config instead of installing things ad-hoc, which keeps the machine reproducible. Do not soften it to `uninstall` or `none`. Users are warned about its effect in README.md; this note is for anyone tempted to change the setting itself.
- Never commit `.no-mistakes/` validation evidence to this public repo. `.no-mistakes/` is gitignored; if a validation pipeline stages evidence into a branch, drop it before merging.
- `configuration.nix` splits Homebrew casks into `basicCasks` (dev tooling, reusable on any future machine) and `personalCasks` (this Mac's GUI apps), gated by the `includePersonalCasks` module argument (required, no default - nix-darwin doesn't honor plain Nix argument defaults for custom module args, so `flake.nix`'s `specialArgs` must always set it explicitly). Keep new personal-only tooling behind that flag rather than hardcoding it into the shared `casks` list.
- `hostLabel` in `flake.nix` does double duty: it's both the host's display name (its original purpose, from an earlier PR) and the personal-vs-basic profile switch - `includePersonalCasks = hostLabel != "basic"`, so `"basic"` is a reserved value, not just an example rename. There's deliberately no separate `activeProfile` variable or CLI flag; an earlier iteration tried both an `activeProfile` variable and a `--basic` flag with an interactive confirmation prompt, but the user specifically wanted `hostLabel` itself to be the switch. Don't split this back into two variables/a flag without checking with the user first - it's been through several rounds of iteration on this exact point.
- Only one `darwinConfigurations` output exists (`darwinConfigurations.${hostLabel}`) - there is no separate, always-present `"basic"` output. This was a deliberate simplification: an earlier version kept both a `${hostLabel}` and a fixed `"basic"` output side by side, which let someone break flake evaluation by renaming `hostLabel` to `"basic"` (`error: dynamic attribute "basic" already defined`, confirmed via a scratch-copy repro). Collapsing to a single dynamically-keyed output removes that collision by construction - don't reintroduce a second, fixed-name host alongside `${hostLabel}`.

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
