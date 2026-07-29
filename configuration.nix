{ user, lib, includePersonalCasks, ... }:

let
  # Dev tooling wanted on every machine, personal or not - reuse this list
  # as-is on any future second machine (server or otherwise).
  basicCasks = [
    "wezterm"
    "claude-code"
  ];
  # GUI apps for this personal Mac only - leave these out of any other
  # machine's cask list.
  personalCasks = [
    "slack"
    "discord"
    "spotify"
    "notion"
    "figma"
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
      # KeyRepeat = 2;          # fast key repeat
      # InitialKeyRepeat = 15;  # short delay before repeat
      # _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    # finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    # finder.CreateDesktop = false;          # clean desktop
    # trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "thefuck"
      "skills"
    ];
    casks = basicCasks ++ lib.optionals includePersonalCasks personalCasks;
  };
}
