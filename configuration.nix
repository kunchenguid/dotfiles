{ user, ... }:

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
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    # High impact: `zap` removes Homebrew items not listed below on switch.
    # Review brews/casks before bootstrap or rebuild on an existing machine.
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "coreutils"
      "ffmpeg-full"
      "gh"
      "herdr"
      "just"
      "node"
      "opencode"
      "tailscale"
      "tmux"
      "uv"
    ];
    casks = [
      "1password"
      "1password-cli"
      "android-platform-tools"
      "antigravity"
      "claude"
      "claude-code"
      "codex"
      "cursor"
      "nomachine"
      "obsidian"
      "orbstack"
      "rustdesk"
      "tailscale-app"
      "wezterm"
    ];
  };
}
