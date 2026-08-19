# dotfiles

Watch the walkthrough: https://youtu.be/5N-okeDdIuI

My personal Mac setup, managed with nix-darwin and home-manager.
One repo, one command, and a fresh Mac ends up configured the same way every time.
It also supports a bare Ubuntu 22.04 LTS machine (no desktop environment) via standalone home-manager - see "Ubuntu setup" below.

## Contributing / Using This Repo

These are my personal dotfiles, shared publicly so people can read them, learn from them, and fork them freely.
Feature requests and pull requests are not accepted here, and PRs are auto-closed.
If you find a bug, please open a GitHub Issue using the bug report template.

## What you get

Running the switch builds:

- System settings (dark mode, key repeat, dock, Finder, trackpad)
- Homebrew apps (casks and CLI tools)
- Nix user packages (ripgrep, fd, fzf, jq, lazygit, Neovim, Hack Nerd Font, TeX Live)
- Shell (zsh, aliases, starship prompt)
- Editor (Neovim config with the rose-pine moon theme)
- Terminal (WezTerm config with the rose-pine moon theme and dimmed unfocused windows)
- Agent configs (Claude, Codex, opencode all share one AGENTS.md)
- Optional Pi theme and local extensions, generic UI settings and model overrides, plus two deliberately pinned third-party Pi packages

## Prerequisites

- Apple Silicon Mac, by default.
- Intel Mac: change one line.
  In `configuration.nix`, set `nixpkgs.hostPlatform = "x86_64-darwin";` (the comment right there tells you the same thing).
- Ubuntu 22.04 LTS ("base free" - a plain install, no desktop environment) also works; see "Ubuntu setup" below instead of the macOS steps that follow.

## Fresh-machine setup

On a brand new Mac, from a bare clone of this repo:

```sh
git clone https://github.com/kunchenguid/dotfiles.git
cd dotfiles
```

Before you run it: review "Make it yours" below.
Change the host label or CPU architecture if needed, and read the Homebrew cleanup warning.
`bootstrap.sh` applies the config to your machine, so do this first.

```sh
./bootstrap.sh
```

`bootstrap.sh` does five things, in order:

1. Installs Determinate Nix, if it isn't already installed.
2. Symlinks this repo to `~/.dotfiles`.
   This has to happen before the first build, because `home.nix` points at config files through `~/.dotfiles`.
3. Checks the `user` configured in `flake.nix` against your actual macOS username, and offers to fix it for you if they differ.
4. Trusts this repo for root, via `git config -f /etc/gitconfig --add safe.directory`.
   `darwin-rebuild` always runs via `sudo`, so root evaluates this flake's `git+file://` input; without this, libgit2 refuses to open a repo owned by another user.
5. Runs the first `darwin-rebuild switch`.
   It fetches the `darwin-rebuild` tool from the nix-darwin 26.05 release branch, then applies this repo's locked flake config.

After that, `darwin-rebuild` exists and you're on the normal workflow below.

### Validate without applying

Once Nix is installed (`bootstrap.sh` step 1 handles that), you can check that the config builds without touching your system - handy when you have edited something:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

If you renamed the host label in "Make it yours", substitute your label for `mac` in these commands. On Ubuntu, substitute `.#homeConfigurations."<user>@<system>".activationPackage` (e.g. `thomasharper@x86_64-linux`) for the `darwinConfigurations.mac.system` output.

## Daily use

Edit the config files in place, then apply:

```sh
./rebuild.sh
```

That's it.
No separate build-and-copy step.

## Ubuntu setup

Ubuntu 22.04 LTS ("base free" - a plain install, no desktop environment, nothing pre-configured) is supported through a separate, simpler path: standalone home-manager, not nix-darwin. No root, no sudo, no Homebrew, no system-level config - just your shell, git, starship, zoxide, and the symlinked dotfiles under `home/`.

```sh
git clone https://github.com/kunchenguid/dotfiles.git
cd dotfiles
./bootstrap.sh
```

On Linux, `bootstrap.sh` does four things: installs Determinate Nix (same installer as macOS), symlinks this repo to `~/.dotfiles`, offers to fix the `user` line in `flake.nix` if it doesn't match your Ubuntu username, then runs the first `home-manager switch --flake ~/.dotfiles#<user>@<system>` (pinned to the home-manager `release-26.05` branch, same pattern as the macOS `darwin-rebuild` bootstrap). `<system>` is `x86_64-linux` or `aarch64-linux`, detected from `uname -m`. After that, `./rebuild.sh` works the same way it does on macOS.

What you get is intentionally narrower than the macOS setup: no Homebrew casks/GUI apps (there's no desktop environment to run them), and no macOS-only CLI tools (`thefuck`, `echidna`, `solc-select`, `tenderly`, `postgresql`, `libpq`, `colima` - see `tools.nix`'s `platform = "macos"` entries). Fast-moving `platform = "all"` tools (`claude-code`, `codex`, `herdr`, `skills`, `pi-coding-agent`) are also not yet installed automatically on Ubuntu - `tools.nix`'s `useNative` correctly identifies them as needing a non-Nix installer (see "Package metadata" above), but that installer isn't wired up yet; install them manually per their own docs for now.

## Make it yours

This repo is mine.
If you clone it, review these before you run `bootstrap.sh`:

- **Username**: run `./bootstrap.sh` (it detects your macOS username and offers to set it) OR change the single `user = "kunchen"` line in `flake.nix`.
  Everything else (`configuration.nix`, `home.nix`, home directory paths) is threaded from that one variable.
- **Host label**: change the single `hostLabel = "mac";` line in `flake.nix` (`rebuild.sh`/`bootstrap.sh` read it back out, so nothing else needs editing).
- **CPU architecture**, `hostPlatform` in `configuration.nix` (see Prerequisites above).

**Git identity:** this config deliberately does not set your git name or email.
Git will stop your first commit and tell you to set them (`git config --global user.name "Your Name"` and `git config --global user.email you@example.com`).
If you'd rather manage that declaratively, add this back to `home.nix` with your own identity:

```nix
programs.git = {
  enable = true;
  settings.user = {
    name = "Your Name";
    email = "you@example.com";
  };
};
```

**Homebrew cleanup warning:** `configuration.nix` sets `homebrew.onActivation.cleanup = "zap"`.
That means every time you switch, Homebrew removes any package or cask on your machine that isn't listed in the `brews` and `casks` arrays in `configuration.nix`.
If you already have Homebrew stuff installed that isn't in that list, the first switch will uninstall it.
Read through `brews` and `casks` before you run `bootstrap.sh` or `rebuild.sh` for the first time, and add anything you want to keep.

**Existing Homebrew install:** `configuration.nix` sets `nix-homebrew.autoMigrate = true`, so if `/opt/homebrew` already has a non-Nix Homebrew install on it (common on a Mac you were already using), the first switch migrates it in place under nix-homebrew's management instead of erroring out. Your existing taps and packages are kept; the `zap` cleanup above still applies on top of that.

**Existing dotfiles:** `flake.nix` sets `home-manager.backupFileExtension = "before-home-manager"`.
On a Mac you were already using, files like `~/.zshrc`, `~/.zshenv`, or `~/.claude/settings.json` likely already exist.
Without this setting, home-manager refuses to activate rather than clobber them.
With it, the first switch moves each conflicting file to `<name>.before-home-manager` next to it and links in this repo's version instead - diff the two afterward if you want to carry anything over.

**About `herdr`:** it's a `scope = "basic"` entry in `tools.nix`.
It's a real public Homebrew formula (`brew info herdr` finds it in homebrew-core, no tap needed), so it will install fine.
If you don't use it, just remove its entry from `tools.nix` in your copy.

**Package metadata:** `tools.nix` is the single source of truth for every CLI tool and GUI app. Each entry answers four questions:

| Property       | Question                                        | Values                       |
| -------------- | ------------------------------------------------ | ----------------------------- |
| `scope`        | Do I need this on a minimal dev machine?          | `basic` / `personal`          |
| `platform`     | Where does this tool make sense?                  | `all` / `macos` / `ubuntu`    |
| `updatePolicy` | Do I want the latest upstream version quickly?    | `stable` / `fast`             |
| `isCask`       | If installed through Homebrew, is it a cask?      | `true` / omitted              |

(`brewName`/`nixName` are optional overrides for when the Homebrew or nixpkgs name differs from the tool's `name`. `platform = "ubuntu"` isn't used by any entry yet - see below.)

`configuration.nix` turns that table into `environment.systemPackages`, `homebrew.brews`, and `homebrew.casks` in two stages. First, whether the tool exists on this machine at all:

```text
scope:
  basic setup    -> only scope=basic
  personal setup -> basic + personal

platform:
  platform=all             -> any OS
  platform=currentPlatform -> this OS
  anything else            -> skip
```

Only then is the installer picked, based on `currentPlatform`:

```text
macOS:
  stable + all   -> Nix
  fast + all     -> Homebrew
  macos-only     -> Homebrew

Ubuntu:
  stable + all     -> Nix
  fast + all       -> native installer (not yet wired up - see "Ubuntu setup")
  stable + ubuntu  -> Nix
  fast + ubuntu    -> native installer (not yet wired up)
```

`currentPlatform` isn't one global constant: `configuration.nix` hardcodes it to `"macos"` (there's only one macOS target), while each Ubuntu `homeConfigurations."<user>@<system>"` output in `home.nix` derives it from `pkgs.stdenv.isDarwin`/`isLinux`, so it's correct per-output rather than a single file-level toggle that would only ever be right for one platform at a time.

The invariant that makes this Ubuntu-ready without a later reorg: installer selection always depends on `currentPlatform`, not on a tool's fields alone. A `platform=all; updatePolicy=fast` tool is Homebrew-managed only because `currentPlatform == "macos"` right now - on Ubuntu that same tool goes through `useNative` (a native installer) instead. A `platform=ubuntu` tool can never enter the Homebrew lists while `currentPlatform == "macos"`. `isCask` only decides `homebrew.casks` vs `homebrew.brews` for a tool the platform stage already selected for Homebrew - it plays no role in which installer is chosen. See `isEnabled`/`isForCurrentPlatform`/`useNix`/`useHomebrew`/`useNative` in `tool-selection.nix` (shared by `configuration.nix` and `home.nix`) for the exact predicates.

One toggle controls both scopes: flip `usePersonalSetup` in `flake.nix` to `false` for dev tooling only - handy for a second, non-personal machine (e.g. a server).

**Heads-up:**

- `home/AGENTS.md` is my personal agent policy, and `home.nix` installs it for Claude, Codex, and opencode.
  If you clone this repo, you'd silently inherit my agent instructions - edit or delete `home/AGENTS.md` if you don't want that.
- The `cc` and `co` shell aliases in `home.nix` are high-agency shortcuts: `claude --dangerously-skip-permissions` and `codex --full-auto`.
  They're convenient for me, but know what they do before you use them.

## Repo tour

- `flake.nix` - the entry point.
  Wires up nixpkgs, nix-darwin, home-manager, and nix-homebrew for the macOS `darwinConfigurations.mac` output, and nixpkgs + home-manager (standalone, no nix-darwin) for the Linux `homeConfigurations."<user>@<system>"` outputs; `usePersonalSetup` selects the brews/casks/Nix-package profile on both.
- `configuration.nix` - macOS-only system-level config: system defaults, Homebrew, and macOS package selection (see "Package metadata" above).
- `tools.nix` - the per-tool metadata table every platform selects packages from.
- `tool-selection.nix` - the shared `isEnabled`/`isForCurrentPlatform`/`useNix`/`useHomebrew`/`useNative` predicates that turn `tools.nix` into concrete package lists for one `currentPlatform`; used by both `configuration.nix` (macOS) and `home.nix` (Ubuntu).
- `home.nix` - user-level config: shell, packages, prompt, and the symlinks described below. Shared between macOS and Ubuntu; platform-specific bits (home directory, Nix-managed package list, a couple of aliases) branch on `pkgs.stdenv.isDarwin`.
- `rebuild.sh` - re-applies the config after the first switch (macOS or Ubuntu).
  Run this every time you make a change.
- `home/` - the actual config files that get symlinked into place; the sections below explain the shared symlink model and Pi's narrower selective setup.

## How the symlinks work

The files under `home/` are the real files - editing them here is editing your live config, no rebuild needed to see the change in your editor.
`home.nix` uses `mkOutOfStoreSymlink` to point paths like `~/.config/nvim` straight at `home/.config/nvim` in this repo, so the two never drift out of sync.
You only run `./rebuild.sh` when you change something that isn't just a symlinked file, like a package list or a system default.

## Optional Pi configuration

Pi is an opt-in CLI, not a dependency this repository vendors. Install it from its owner with the [official Pi instructions](https://pi.dev), for example:

```sh
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

[Pi Launcher](https://github.com/kunchenguid/homebrew-tap) is also optional and installed from its owner, not declared by this config:

```sh
brew install --cask kunchenguid/tap/pi-launcher
```

Home Manager owns exactly two repository-authored Pi directories: `~/.pi/agent/themes` and `~/.pi/agent/extensions`. It also links `models.json` and `settings.json` as individual files. The local extension directory is for public, repository-authored extensions only - third-party package code never belongs there. Run `/reload` after editing a local extension or other Pi resources. The terminal-title extension shows a spinner while Pi is working, then a completion mark with the session name or current directory. The `rose-pine-moon` theme was authored clean-room from the public [Rosé Pine Moon palette](https://rosepinetheme.com/palette) and Pi's [public theme schema](https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json), not from a private or live theme file.

### Pi Calm

`home/.pi/agent/extensions/calm` is a standalone local Pi extension. Home Manager's existing global extensions-directory link makes Pi auto-load it without another declaration. `/calm` toggles a conversation-only presentation mode and is off by default. Its choice is stored locally in `~/.pi/agent/calm` (or the directory selected by `PI_CODING_AGENT_DIR`), not in this repository or Home Manager. Adapted from Firstmate under the bundled MIT license, Calm imports no Firstmate modules and has no Firstmate runtime dependency.

When enabled, Calm hides collapsed thinking and the call/result shells for Pi's seven built-in tools (`read`, `bash`, `edit`, `write`, `grep`, `find`, and `ls`) without leaving blank transcript rows. During an active run it replaces Pi's working row with a two-line animated blue-water, yellow-boat widget. `/calm` restores Pi's stock rendering and preserves the existing Ctrl+O tool-expansion choice.

Calm never changes prompts, tool execution, model context, session data, or ordering. `/share` and `/export` use the complete stock transcript. Generic custom tools, images, and unsupported Pi transcript classes deliberately remain visible because Pi has no safe general-purpose transcript filter. If a future Pi release no longer exports the exact collapsed-thinking rendering seam, Calm logs one diagnostic and leaves only that adapter disabled; all other behavior remains available.

Pi's package system declares two third-party sources in the linked global `settings.json`:

- `npm:@ryan_nookpi/pi-extension-codex-fast-mode@0.2.6` - the exact public npm release from `ryan_nookpi`.
- `git:github.com/algal/pi-openai-server-compaction@c6d593087709e9481223dc6c6c2269b371b5e055` - the exact public `algal` commit for experimental OpenAI server-side compaction.

The version and commit are immutable pins, so Pi does not move them during package updates. Deliberate updates require a new source and security audit, followed by an explicit pin change in `home/.pi/agent/settings.json`. On Pi 0.82.0, global settings declarations install missing pinned packages automatically at startup. No one-time install command is required. Pi keeps the downloaded npm and git package trees in its own unmanaged `~/.pi/agent/npm` and `~/.pi/agent/git` runtime directories, outside Home Manager and Git tracking.

Both packages execute with your full user permissions and must be trusted like any other executable code. The compaction package is experimental, sends the relevant OpenAI compaction and continuity data to OpenAI, and upstream declares the stale peer range `>=0.80.9 <0.81.0`; this exact immutable ref was locally proven to load and perform remote compaction on Pi 0.82.0. Do not treat that proof as a guarantee for a different Pi version or a different package ref.

Home Manager deliberately does not manage `~/.pi/agent` itself, or Pi authentication, sessions, trust decisions, caches, npm/git package trees, or any other runtime state. The model overrides contain no credentials or endpoint settings, do not choose a default model, and only take effect after you authenticate Pi yourself. This remains an additive post-video layer: it does not install Pi, a launcher, or package source code into this repository.

## Notes

The first time you launch `nvim`, it bootstraps [lazy.nvim](https://github.com/folke/lazy.nvim) by cloning plugins from GitHub.
That needs network access once; after that it's offline.
Neovim and WezTerm both use the rose-pine moon theme.
Neovim keeps italics off and uses a transparent background on macOS, Windows, and WSL so it matches the terminal setup.

## License

This repo is licensed under MIT No Attribution.
See `LICENSE`.
