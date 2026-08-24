{ pkgs, user, ... }:

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
    # Take over the pre-existing Homebrew install instead of demanding it be
    # uninstalled first. Deletes the Homebrew repositories, keeps the packages.
    autoMigrate = true;

    # nix-homebrew defaults to its own brew-src input, pinned to 6.0.1. Homebrew's
    # JSON API serves cask definitions using the `command_wrapper` stanza, which only
    # landed in brew 6.0.13, so casks like android-ndk fail with "undefined method".
    # `package` is the brew source tree itself, and nix-homebrew reads `version` off
    # it to rewrite HOMEBREW_VERSION, so both extra attrs have to be set.
    package = (pkgs.fetchFromGitHub {
      owner = "Homebrew";
      repo = "brew";
      tag = "6.0.18";
      hash = "sha256-VBESSoJccikdhxh3vp3SQeG7cZXTOulMvVkoSqNDEhs=";
    }) // {
      name = "brew-6.0.18";
      version = "6.0.18";
    };
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "herdr"
      "gnupg"        # gpg - GPG_TTY export in home.nix initContent
      "pyenv"        # pyenv init in home.nix initContent
    ];
    casks = [
      "wezterm"
      "claude-code"
      "codex"        # the `co` alias
      "gcloud-cli"   # gcloud completion sourced from home.nix initContent
      "android-ndk"  # ANDROID_NDK_HOME
    ];
  };
}
