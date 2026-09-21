# Kunchen reproducible macOS environment

Nix-Darwin + Home Manager flake for a rebuildable agentic engineering setup (WezTerm, Neovim, herdr, Claude Code).

Based on [The Reproducible Mac Agentic Engineering Cookbook](https://youtu.be/5N-okeDdIuI).

## Layout

| Path | Role |
|------|------|
| `~/.dotfiles` | Symlink to this repo (stable path; no `~/files`) |
| `flake.nix` | System entry (`darwinConfigurations.Mac`) |
| `configuration.nix` | macOS defaults + Homebrew packages |
| `home.nix` | User packages, zsh, config symlinks |
| `rebuild.sh` | `sudo darwin-rebuild switch` helper |
| `home-agents.md` | Agent SSOT (also `~/Documents/claude.md`) |

## Bootstrap (fresh Mac)

1. Install Git + SSH keys.
2. Install [Determinate Nix](https://docs.determinate.systems/determinate-nix/).
3. Install Homebrew (required for the `homebrew` module).
4. Clone this repo somewhere durable (this machine uses `Projects/kunchenguid/dotfiles/Untitled`).
5. `ln -sfn /path/to/this/repo ~/.dotfiles`
6. Build and activate (GUI password prompts if needed):

```sh
cd ~/.dotfiles
nix build .#darwinConfigurations.Mac.system
RESULT=$(readlink -f ./result)
# then as root (Terminal sudo, or admin dialog):
sudo nix-env --profile /nix/var/nix/profiles/system --set "$RESULT"
sudo "$RESULT/activate"
```

Or after `darwin-rebuild` is on PATH: `~/.dotfiles/rebuild.sh`

Open a **new login shell** so PATH includes `/etc/profiles/per-user/$USER/bin` and `/run/current-system/sw/bin`.

## Rebuild

```sh
rebuild   # zsh alias → ~/.dotfiles/rebuild.sh
```

`rebuild.sh` uses `path:$HOME/.dotfiles#Mac` so sudo flake eval does not hit git ownership errors.

## Packages

- Homebrew casks: `wezterm`, `claude-code`
- Homebrew formula: `herdr` (cookbook name “Herder”)
- Nix: `neovim`, Hack Nerd Font, starship
- Homebrew `onActivation.cleanup = "none"` (does not wipe undeclared packages)

## Manual follow-ups

- In Claude Code: `/status-line` for model + context %
- First `herdr` session (agent multiplexer)
- Open WezTerm to confirm Rose Pine Moon + Hack Nerd Font

## Deviations from the PDF

- Pins: nixpkgs / nix-darwin / home-manager **25.05** (24.11 cannot activate on current nix-darwin tooling)
- No `nix-homebrew` module (current nix-homebrew needs `ruby_4_0` missing from 25.05; existing Homebrew is used)
- Repo path: this folder + `~/.dotfiles` (not `~/files`)
- `security.pam.services.sudo_local.enable = false` (SIP on recent macOS)
- Config dirs use out-of-store symlinks so Neovim/Lazy can write `lazy-lock.json`
