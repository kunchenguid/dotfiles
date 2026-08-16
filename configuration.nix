{ user, lib, usePersonalSetup, ... }:

let
  # Dev tooling wanted on every machine, personal or not - reuse this list
  # as-is on any future second machine (server or otherwise).
  basicCasks = [
    "wezterm"
    "claude-code"
    "codex"
    "opensuperwhisper"
  ];
  # GUI apps for this personal Mac only - leave these out of any other
  # machine's cask list.
  personalCasks = [
    "slack"
    "discord"
    "notion"
    "figma"
    "altair-graphql-client"
    "mongodb-compass"
    "todoist-app"
    "anki"
    "iterm2"
    "zoom"
  ];
  # CLI tools wanted on every machine, personal or not.
  basicBrews = [
    "herdr"
    "thefuck"
    "skills"
    "btop"
    "pi-coding-agent"
  ];
  # CLI tools for this personal Mac only.
  personalBrews = [
    # Smart-contract toolchain
    "echidna"
    "solc-select"
    "tenderly/tenderly/tenderly"
    # Python / Postgres toolchain
    "postgresql@15"
    "libpq"
    "pyenv"
    # Everything else already installed on this Mac
    "asdf"
    "bzip2"
    "cmake"
    "ekhtml"
    "ffmpeg"
    "gh"
    "gnu-tar"
    "lcov"
    "libusb"
    "tree"
    "wget"
    "yarn"
  ];
in
{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      # 1=15ms, 2=30ms
      KeyRepeat = 1;          # fast key repeat. lower is faster.
      # 10=150ms, 15=225ms
      InitialKeyRepeat = 10;  # short delay before repeat. lower is faster
      # _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    # finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    # finder.CreateDesktop = false;          # clean desktop
    # trackpad.Clicking = true;              # tap to click
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Free up ctrl+space for wezterm's leader key (was "Select the
          # previous input source").
          "60" = { enabled = false; };
        };
      };
    };
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = basicBrews ++ lib.optionals usePersonalSetup personalBrews;
    casks = basicCasks ++ lib.optionals usePersonalSetup personalCasks;
  };
}
