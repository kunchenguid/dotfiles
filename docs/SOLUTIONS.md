# Solutions & Tools Reference

Quick-reference companion to [`mindmap.html`](./mindmap.html) (the visual map). This
file covers the same ground in plain Markdown, with more detail on what each
tool does and why it's configured the way it is.

## How this repo is managed

**One flake, one variable.** `flake.nix` is the entry point. It pins every
input (`nixpkgs`, `nix-darwin`, `home-manager`, `nix-homebrew`) to the
`nixpkgs-26.05-darwin` / `nix-darwin-26.05` release branches, and declares a
single `darwinConfigurations."mac"` system built from `configuration.nix`
(system-level) and `home.nix` (user-level). The only line meant to change per
machine is `user = "zak"` in `flake.nix` — `configuration.nix`, `home.nix`,
and every home-directory path are threaded from that one variable.

**Two entry-point scripts, two different jobs.**
- `bootstrap.sh` — run once, on a bare clone: installs Determinate Nix if
  missing, symlinks the repo to `~/.dotfiles` (required before the first
  build, since `home.nix` resolves paths through it), checks the configured
  `user` against the actual macOS username, and runs the first
  `darwin-rebuild switch`.
- `rebuild.sh` — run every time after that, whenever a config file changes.

**Edit-in-place, not build-and-copy.** Files under `home/` are the real
files. `home.nix` uses `mkOutOfStoreSymlink` to point live paths
(`~/.config/nvim`, `~/.config/wezterm`, `~/.claude/settings.json`, the Pi
`themes`/`extensions`/`models.json`/`settings.json`) straight at this repo, so
editing here *is* editing the live config — no rebuild needed to see the
change take effect in the editor or terminal. `./rebuild.sh` is only required
for changes that aren't just a symlinked file: a package list, a system
default, a new Homebrew entry.

**Validate before you apply.** `nix flake check --no-build` and
`nix build .#darwinConfigurations.mac.system --dry-run` check that the config
still builds without touching the running system.

**Homebrew is declarative and destructive.** `configuration.nix` sets
`homebrew.onActivation.cleanup = "zap"` — every `rebuild.sh` run removes any
Homebrew package or cask installed on the machine that isn't listed in the
`brews`/`casks` arrays. This is a deliberate choice (see `AGENTS.md`): it
forces every Homebrew install to be declared in `configuration.nix` instead of
installed ad hoc, keeping the machine reproducible. It also means anything
installed outside this repo gets uninstalled on the next switch.

**Behavior tests live in `tests/`.** `tests/lib.sh` is a shared Bash harness
(self-cleaning temp dirs, `pass`/`fail` helpers); `tests/pi-calm.test.sh`
exercises the Calm Pi extension's behavior directly rather than just
eyeballing it.

**Repo governance is intentionally closed.** `.github/workflows/close-prs.yml`
auto-closes every pull request; `CONTRIBUTING.md` explains bug reports are
welcome via the GitHub Issues bug-report template, but feature requests and
PRs (including bug-fix PRs) are not accepted — this is Kun's personal setup,
shared to read and fork, not to co-maintain.

**Pi is the one deliberately unmanaged layer.** Home Manager only links
Pi's *authored* files — `themes/`, `extensions/`, `models.json`,
`settings.json` — and never touches Pi's credentials, sessions, trust
decisions, caches, or its `~/.pi/agent/npm` and `~/.pi/agent/git` package
trees. Third-party Pi packages are pinned to immutable versions/commits in
`settings.json`; bumping a pin is a deliberate, security-audited edit, not an
automatic update.

---

## Nix Foundation — `flake.nix`, reproducible builds

| Tool | What it does here |
|---|---|
| **flake.nix** | Pins `nixpkgs`, `nix-darwin`, `home-manager`, and `nix-homebrew` to locked revisions and declares the `mac` darwin system. This is the single source of truth for every input version in the repo. |
| **nix-darwin** | Applies declarative macOS *system* settings — `configuration.nix` — the same way every time: dark mode, key repeat, Dock/Finder defaults, Homebrew management. |
| **home-manager** | Applies declarative *user* config — `home.nix` — packages, shell, symlinked dotfiles. Runs with `useGlobalPkgs`/`useUserPackages` so it shares nix-darwin's package set instead of managing its own. |
| **nix-homebrew** | Bridges Homebrew's imperative install model into the Nix-managed system so `configuration.nix` can declare `brews`/`casks` as data. |
| **Determinate Nix** | Installs and owns the Nix daemon itself. Because Determinate already manages it, `configuration.nix` sets `nix.enable = false` so nix-darwin doesn't fight it for control. |

## macOS System — `configuration.nix`

| Setting | Effect |
|---|---|
| **Appearance** | `AppleInterfaceStyle = "Dark"`, fast key repeat (`KeyRepeat = 2`, `InitialKeyRepeat = 15`), auto-hidden menu bar, all file extensions shown. |
| **Dock & Finder** | Dock auto-hides; Finder defaults to list view (`Nlsv`) with no icons on the desktop. |
| **Trackpad** | Tap-to-click enabled. |

## Homebrew Apps — casks & brews, zap-cleaned

| Tool | What it does here |
|---|---|
| **WezTerm** (cask) | The terminal emulator — see the WezTerm section below. |
| **Claude Code** (cask) | Anthropic's coding-agent CLI; this is the `claude` binary the `cc` alias runs. |
| **herdr** (brew) | A terminal session/pane manager (config at `home/.config/herdr/config.toml`): tmux-style pane splits and tab/workspace switching under a `ctrl+b` prefix, plus an agent-aware panel that groups running agents by workspace ("space") rather than by priority. |

## CLI Toolbelt — `home.nix` packages

| Tool | What it does here |
|---|---|
| **ripgrep** | Fast recursive text search (`rg`). |
| **fd** | Fast, friendly file finder — a saner `find`. |
| **fzf** | General-purpose fuzzy finder, used interactively and by other tools. |
| **jq** | JSON processor for the command line. |
| **lazygit** | Terminal UI for git — stage, commit, branch, rebase without leaving the terminal. |
| **Neovim** | The editor itself — see below. |
| **Nerd Font (JetBrains Mono)** | Icon-patched monospace font, shared by the terminal and the editor so devicon/statusline glyphs render correctly. `fonts.fontconfig.enable = true` makes it available system-wide. |

## Shell — `programs.zsh`

| Feature | What it does here |
|---|---|
| **Autosuggestion** | Ghost-text completion from shell history; `Ctrl+F` accepts the suggestion (`bindkey '^f' autosuggest-accept`). |
| **Syntax highlighting** | Commands turn green once they resolve to something valid, red otherwise — instant feedback before you hit Enter. |
| **Starship** | The prompt: working directory, git branch/status, and command duration, with a purple `❯` on success and red on error. `add_newline = false` keeps it compact. |
| **Aliases** | `..` (up a dir), `add`/`push`/`pull` (git shortcuts), `m` (switch to `main`), `cc` = `claude --dangerously-skip-permissions`, `co` = `codex --full-auto`. The last two are high-agency shortcuts — convenient, but worth knowing what they skip before using them. |

## Neovim — the editor

| Plugin | What it does here |
|---|---|
| **lazy.nvim** | The plugin manager. Bootstraps itself by cloning from GitHub on first launch (needs network once, then works offline). |
| **rose-pine (moon variant)** | The colorscheme — italics off, transparent background on macOS/Windows/WSL so it matches the terminal. Shared visually with WezTerm and (separately, hand-ported) Pi. |
| **Neogit + Diffview + plenary.nvim** | A full git UI inside the editor — status, staging, commits, diff review — bound to `<leader>g`. |
| **gitsigns.nvim** | Inline change markers in the gutter, plus on-demand git blame for the current line (`<leader>gb`). |
| **oil.nvim** | A file browser that treats a directory listing as an editable buffer; shows hidden files; bound to `<leader>e`. |
| **snacks.nvim** | Fuzzy picker (`<leader>f` files, `<leader>s` grep, `<leader>b` buffers), a notifier, and LSP "goto definition" (`gd`). |
| **which-key.nvim** | Pops up a cheat sheet of what each leader-key combo does, so bindings don't have to be memorized. |

General editor settings (`vim_config.lua`): space is the leader key, 2-space
indents, absolute number on the cursor line with relative numbers elsewhere,
case-insensitive search that becomes case-sensitive if you type a capital,
system clipboard by default, 16-line scroll padding, persistent undo across
sessions, and the mouse disabled (partly so Herdr keeps host mouse capture and
`Escape` isn't swallowed). `keys.lua` adds two conveniences: `Esc` saves the
file, and pasting over a visual selection no longer overwrites the clipboard
register.

## WezTerm — the terminal

| Setting | Effect |
|---|---|
| **rose-pine-moon color scheme** | Same palette as Neovim. |
| **JetBrains Mono, 12pt** | Same font as Neovim. |
| **Background blur & opacity** | `window_background_opacity = 0.8`, `macos_window_background_blur = 50` — a translucent, blurred terminal window. |
| **Focus dimming** | Unfocused windows drop to 62% background opacity and desaturate their text (`window-focus-changed` event), so the focused window is obvious at a glance. Tab bar hides when there's only one tab; window decorations are resize-only. |

## Agent Tooling — Claude, Codex, opencode, Pi

| Tool | What it does here |
|---|---|
| **AGENTS.md** (`home/AGENTS.md`) | One shared instruction file, symlinked into `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, and `~/.config/opencode/AGENTS.md` — Claude, Codex, and opencode all read the same personal agent policy instead of three drifting copies. |
| **Claude Code `settings.json`** | Custom statusline command, `dark-ansi` theme, default model `sonnet`, and `skipDangerousModePermissionPrompt` (paired with the `cc` alias's `--dangerously-skip-permissions`). |
| **Pi** *(optional, not vendored)* | A separate coding-agent CLI, installed from its own source (`pi.dev`), not a dependency this repo ships. Home Manager only manages the pieces below — everything else (auth, sessions, caches, package trees) is Pi's own runtime state. |

### Pi's layer, in detail

| Piece | What it does |
|---|---|
| **rose-pine-moon theme** (`home/.pi/agent/themes/rose-pine-moon.json`) | Authored clean-room from the public Rosé Pine Moon palette and Pi's public theme schema — not copied from a private theme file. Ties Pi's look to the same palette as Neovim and WezTerm. |
| **Calm extension** (`home/.pi/agent/extensions/calm`) | A `/calm` toggle (off by default) that hides collapsed thinking and the call/result "shells" for Pi's seven built-in tools, replacing the working row with a two-line animated indicator while a run is active. Adapted from Firstmate under its bundled MIT license, with no runtime dependency on it. Never touches prompts, tool execution, or session data — `/share` and `/export` still use the full stock transcript. Has its own test in `tests/pi-calm.test.sh`. |
| **terminal-status-title.js** | Shows a spinner in the terminal title while Pi is working, then a completion mark with the session name or current directory once it's done. |
| **Pinned third-party packages** (in `home/.pi/agent/settings.json`) | `npm:pi-web-access@0.14.0`, `npm:@ryan_nookpi/pi-extension-codex-fast-mode@0.2.6`, and `git:github.com/algal/pi-openai-server-compaction@<commit>` — each pinned to an exact, immutable version or commit. Pi installs missing pinned packages automatically at startup (on Pi 0.82.0+), but the pins themselves only move via a deliberate, security-audited edit to this file. The compaction package is explicitly experimental and sends compaction/continuity data to OpenAI. |
| **models.json** | Context-window overrides (272,000 tokens) for three `openai-codex` provider models used through Pi's `codex-fast-mode` package. No credentials, endpoints, or default-model choice — it only takes effect after you authenticate Pi yourself. |

---

## Hotkeys Quick Reference

Every custom keybinding declared in this repo, grouped by tool. WezTerm itself
declares no custom key table in `wezterm.lua` - it only sets appearance and
focus-dimming behavior - so its hotkeys are just whatever WezTerm ships by
default.

### Shell (zsh)

| Key | Action |
|---|---|
| `Ctrl+F` | Accept the current autosuggestion (ghost text from history). |

Aliases (not hotkeys, but muscle memory either way): `..` (up a dir), `add`
(`git add .`), `push`/`pull`, `m` (checkout `main`), `cc` (`claude
--dangerously-skip-permissions`), `co` (`codex --full-auto`).

### herdr (pane/session manager) - prefix `Ctrl+B`

Every binding below is pressed *after* the prefix, e.g. `Ctrl+B` then `h`.

| Key (after prefix) | Action |
|---|---|
| `h` | Focus pane left |
| `j` | Focus pane down |
| `k` | Focus pane up |
| `l` | Focus pane right |
| `"` (shift+`'`) | Split pane horizontally |
| `%` (shift+`5`) | Split pane vertically |
| `c` | New tab |
| `&` (shift+`7`) | Close tab |
| `w` | Workspace picker |
| `g` | Goto |
| `y` | Enter copy-mode |

Inside copy-mode (fixed, not configurable): `v`/`Space` to select, `y`/`Enter`
to copy, `q`/`Esc` to cancel.

### Neovim - leader is `Space`

| Key | Action |
|---|---|
| `Esc` (normal mode) | Save the file |
| `Ctrl+A` (normal mode) | Select all (`ggVG`) |
| `p` (visual mode, over a selection) | Paste without clobbering the clipboard register |
| `<leader>g` (`Space g`) | Open Neogit (git status/stage/commit/diff UI) |
| `<leader>gb` (`Space g b`) | Show git blame for the current line, on demand |
| `<leader>e` (`Space e`) | Open Oil file browser |
| `<leader>f` (`Space f`) | Fuzzy-find files (snacks.nvim picker) |
| `<leader>s` (`Space s`) | Grep search text (snacks.nvim picker) |
| `<leader>b` (`Space b`) | Fuzzy-find open buffers |
| `gd` | Goto LSP definition |
| `Space` (any leader combo, held) | which-key.nvim pops up a cheat sheet of what follows |

Mouse is disabled in Neovim (`o.mouse = ''`) so Herdr keeps host mouse capture
and `Escape` isn't swallowed - use the keys above instead of clicking.

### Neovim - standard editing commands (built-in vim, not repo config)

Everything below is stock Vim/Neovim behavior, not something this repo
configures - but it's the muscle memory an IDE gives you for free, so it's
worth having in one place. All modal: press `i`/`a`/`v`/etc. to enter a mode,
`Esc` to return to normal mode (where these run).

**Undo / redo**

| Key | Action |
|---|---|
| `u` | Undo |
| `Ctrl+R` | Redo |
| `.` | Repeat the last change |

**Delete / change**

| Key | Action |
|---|---|
| `dd` | Delete (cut) the current line |
| `D` | Delete to end of line |
| `dw` | Delete a word |
| `x` | Delete the character under the cursor |
| `cc` | Change (delete + insert) the current line |
| `cw` | Change a word |
| `ciw` | Change the word under the cursor, wherever the cursor sits in it |
| `ci(` / `ci"` / `ci{` etc. | Change inside brackets/quotes/braces |

**Copy (yank) / paste**

| Key | Action |
|---|---|
| `yy` | Yank (copy) the current line |
| `yw` | Yank a word |
| `p` | Paste after the cursor / current line |
| `P` | Paste before the cursor / current line |

Since `o.clipboard = 'unnamedplus'` is set in this config, every yank/delete
also lands on the system clipboard - so `Cmd+C`/`Cmd+V` from outside Neovim
interoperate with `y`/`p` inside it.

**Insert mode**

| Key | Action |
|---|---|
| `i` | Insert before the cursor |
| `a` | Insert (append) after the cursor |
| `I` | Insert at start of line |
| `A` | Insert (append) at end of line |
| `o` | Open a new line below and insert |
| `O` | Open a new line above and insert |
| `Esc` | Leave insert mode - and, in this config, saves the file (see above) |

**Navigation**

| Key | Action |
|---|---|
| `h` `j` `k` `l` | Left / down / up / right |
| `w` / `b` | Jump forward / back a word |
| `0` / `$` | Start / end of line |
| `gg` / `G` | Start / end of file |
| `{n}G` or `{n}gg` | Jump to line `{n}` |
| `Ctrl+D` / `Ctrl+U` | Half-page down / up |
| `%` | Jump to matching bracket/paren |
| `*` | Jump to next occurrence of the word under the cursor |

**Search & replace**

| Key | Action |
|---|---|
| `/text` then Enter | Search forward for `text` |
| `?text` then Enter | Search backward |
| `n` / `N` | Repeat search forward / backward |
| `:%s/old/new/g` | Replace every `old` with `new` in the file |
| `:%s/old/new/gc` | Same, but confirm each replacement |

**Visual mode (selecting)**

| Key | Action |
|---|---|
| `v` | Start character-wise visual selection |
| `V` | Start line-wise visual selection |
| `Ctrl+V` | Start block (column) visual selection |
| `Ctrl+A` (normal mode) | Select the whole file (repo binding: `ggVG`) |
| `y` (in visual mode) | Yank the selection |
| `d` (in visual mode) | Delete the selection |
| `>` / `<` (in visual mode) | Indent / outdent the selection |

**Windows / splits & buffers**

| Key | Action |
|---|---|
| `:vsplit` / `:split` | Split the window vertically / horizontally |
| `Ctrl+W` then `h/j/k/l` | Move focus between splits |
| `:bnext` / `:bprev` | Next / previous buffer |
| `:q` | Close the current window/buffer |
| `:wq` | Save and close |

For files and fuzzy search specifically, prefer this repo's own bindings
(`<leader>f`, `<leader>s`, `<leader>b`, `<leader>e` above) over `:e`/`:ls` -
they're faster and cover the same ground.
