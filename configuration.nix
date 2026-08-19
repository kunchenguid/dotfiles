{ user, lib, pkgs, usePersonalSetup, ... }:

let
  # See ./tools.nix for the package metadata model and field semantics.
  tools = import ./tools.nix;

  enabled = lib.filter (t: t.scope == "basic" || usePersonalSetup) tools;

  isNixTool = t: t.platform == "all" && t.updatePolicy == "stable";
  isHomebrewTool = t: t.platform == "macos" || t.updatePolicy == "fast";
  isCaskTool = t: t.isCask or false;

  nixTools = lib.filter isNixTool enabled;
  brewTools = lib.filter (t: isHomebrewTool t && !isCaskTool t) enabled;
  caskTools = lib.filter (t: isHomebrewTool t && isCaskTool t) enabled;

  brewName = t: t.brewName or t.name;
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
  environment.systemPackages = map (t: pkgs.${t.nixName or t.name}) nixTools;
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
    brews = map brewName brewTools;
    casks = map brewName caskTools;
  };
}
