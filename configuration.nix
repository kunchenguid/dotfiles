{ user, lib, pkgs, usePersonalSetup, ... }:

let
  # The only OS this config installs onto today. Passed into the shared
  # ./tool-selection.nix predicates (also used by home.nix's Linux outputs)
  # so that Ubuntu support is a per-output data value, not a restructuring
  # of the tool ontology. See README.md ("Package metadata") for the full
  # field/selection-logic reference.
  currentPlatform = "macos";
  sel = import ./tool-selection.nix { inherit lib usePersonalSetup currentPlatform; };
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
  environment.systemPackages = map (t: pkgs.${sel.nixName t}) sel.nixTools;
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
    brews = map sel.brewName sel.brewTools;
    casks = map sel.brewName sel.caskTools;
  };
}
