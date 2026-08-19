# Single source of truth for CLI/GUI tool metadata, shared by macOS
# (Homebrew + Nix) and, later, Linux/Ubuntu selection logic.
#
# Fields per tool:
#   scope         "basic" (every setup) | "personal" (usePersonalSetup only)
#   platform      "all" (Nix on macOS, native installers later on Ubuntu)
#                 | "macos" (macOS-only, skipped entirely on future Ubuntu)
#   updatePolicy  "stable" (platform=all -> Nix; platform=macos -> Homebrew)
#                 | "fast" (Homebrew on macOS; native installer later on Ubuntu)
#   isCask        true to use homebrew.casks instead of homebrew.brews
#                 (omit/false for a brew formula)
#   brewName      override when the Homebrew name differs from `name`
#   nixName       override when the nixpkgs attribute differs from `name`
[
  { name = "claude-code"; scope = "basic"; platform = "all"; updatePolicy = "fast"; isCask = true; }
  { name = "codex"; scope = "basic"; platform = "all"; updatePolicy = "fast"; isCask = true; }
  { name = "herdr"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }
  { name = "skills"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }
  { name = "pi-coding-agent"; scope = "basic"; platform = "all"; updatePolicy = "fast"; }

  { name = "btop"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "mosh"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "bzip2"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "gh"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "gnu-tar"; scope = "basic"; platform = "all"; updatePolicy = "stable"; nixName = "gnutar"; }
  { name = "tree"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "wget"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }
  { name = "cmake"; scope = "basic"; platform = "all"; updatePolicy = "stable"; }

  { name = "ffmpeg"; scope = "personal"; platform = "all"; updatePolicy = "stable"; }
  { name = "lcov"; scope = "personal"; platform = "all"; updatePolicy = "stable"; }
  # nixpkgs ships this under the "libusb1" attribute.
  { name = "libusb"; scope = "personal"; platform = "all"; updatePolicy = "stable"; nixName = "libusb1"; }

  { name = "thefuck"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "echidna"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "solc-select"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "tenderly"; scope = "personal"; platform = "macos"; updatePolicy = "fast"; brewName = "tenderly/tenderly/tenderly"; }
  { name = "postgresql"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; brewName = "postgresql@15"; }
  { name = "libpq"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }
  { name = "colima"; scope = "personal"; platform = "macos"; updatePolicy = "stable"; }

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
