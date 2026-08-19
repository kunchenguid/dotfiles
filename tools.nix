# Single source of truth for CLI/GUI tool metadata, shared by macOS
# (Homebrew + Nix) and Ubuntu (Nix + native installers).
#
# Field reference and selection-logic docs: README.md ("Package metadata").
# Selection logic that reads this table lives in ./tool-selection.nix,
# consumed by configuration.nix (macOS) and home.nix (Ubuntu).
[
  # Fast-moving CLI agents wanted on every machine - track upstream closely,
  # so Homebrew rather than a pinned nixpkgs version.
  { name = "claude-code"; scope = "basic"; platform = "all"; updatePolicy = "fast"; isCask = true; }
  { name = "codex"; scope = "basic"; platform = "all"; updatePolicy = "fast"; isCask = true; }
  { name = "herdr"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }
  { name = "skills"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }
  { name = "pi-coding-agent"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }

  # Stable CLI dev tooling wanted on every machine, personal or not.
  { name = "btop"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "mosh"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "bzip2"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "gh"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "gnu-tar"; scope = "basic"; platform = "all"; updatePolicy = "stable"; nixName = "gnutar"; }
  { name = "tree"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "wget"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "cmake"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }

  # Stable CLI tooling only this personal Mac needs, but not OS-specific -
  # would apply equally on a future personal Ubuntu machine.
  { name = "ffmpeg"; scope = "personal"; platform = "all"; updatePolicy = "stable"; }
  { name = "lcov"; scope = "personal"; platform = "all"; updatePolicy = "stable"; }
  # nixpkgs ships this under the "libusb1" attribute.
  { name = "libusb"; scope = "personal"; platform = "all"; updatePolicy = "stable"; nixName = "libusb1"; }

  # macOS-specific CLI toolchains for this personal Mac (no meaningful
  # Ubuntu equivalent through this same package name/manager).
  { name = "thefuck"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "echidna"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "solc-select"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "tenderly"; scope = "personal"; platform = "macos"; updatePolicy = "fast"; brewName = "tenderly/tenderly/tenderly"; }
  { name = "postgresql"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; brewName = "postgresql@15"; }
  { name = "libpq"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "colima"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }

  # macOS GUI apps for this personal Mac only, installed as Homebrew casks.
  { name = "wezterm"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "opensuperwhisper"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "slack"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "discord"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "notion"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "figma"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "altair-graphql-client"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "mongodb-compass"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "todoist-app"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "anki"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
  { name = "zoom"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; isCask = true; }
]
