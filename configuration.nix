{ user, lib, pkgs, usePersonalSetup, ... }:

let
  # See ./tools.nix for the per-tool metadata and README.md ("Package
  # metadata") for the full field/selection-logic reference.
  tools = import ./tools.nix;

  # The only OS this config installs onto today. Selection below is written
  # against this variable (not literal "macos" checks) so that flipping it
  # to "ubuntu" later, once real Ubuntu installer wiring exists, is a data
  # change rather than a restructuring of the tool ontology.
  currentPlatform = "macos";

  # Decision 1: is the tool wanted on this machine's setup at all?
  isEnabled = t:
    t.scope == "basic" || usePersonalSetup;

  # Decision 2: does the tool apply to the OS we're installing onto?
  isForCurrentPlatform = t:
    t.platform == "all" || t.platform == currentPlatform;

  # Decision 3a: on any OS, a stable "all" package is Nix-managed - it is
  # never macOS/Ubuntu-specific, so nix.enable=false aside, Nix owns it.
  useNix = t:
    isForCurrentPlatform t
    && t.updatePolicy == "stable"
    && t.platform != "macos";

  # Decision 3b: on macOS, tools that apply to macOS use Homebrew when they
  # are either fast-moving or macOS-specific. A platform=all/updatePolicy=fast
  # tool is Homebrew-managed only because currentPlatform is "macos" right
  # now, not because Homebrew is inherently "the" fast-package installer.
  useHomebrew = t:
    currentPlatform == "macos"
    && isForCurrentPlatform t
    && (t.platform == "macos" || t.updatePolicy == "fast");

  # Decision 3c: not reachable while currentPlatform = "macos". Documents
  # the intended future rule so Ubuntu support is a data flip, not a rewrite:
  # on Ubuntu, fast-moving tools that apply there use a native installer
  # instead of Homebrew.
  useNative = t:
    currentPlatform == "ubuntu"
    && isForCurrentPlatform t
    && t.updatePolicy == "fast";

  isCaskTool = t: t.isCask or false;
  brewName = t: t.brewName or t.name;

  enabled = lib.filter isEnabled tools;
  nixTools = lib.filter useNix enabled;
  brewTools = lib.filter (t: useHomebrew t && !isCaskTool t) enabled;
  caskTools = lib.filter (t: useHomebrew t && isCaskTool t) enabled;
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
