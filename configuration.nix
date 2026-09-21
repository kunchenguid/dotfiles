{ pkgs, ... }:
{
  # Determinate Nix manages the daemon
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
  system.primaryUser = "oibaf";

  # SIP protects /etc/pam.d/sudo_local on recent macOS; leave it alone
  security.pam.services.sudo_local.enable = false;

  users.users.oibaf = {
    home = "/Users/oibaf";
  };

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv";
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
  };

  # First activate: do not uninstall undeclared Homebrew packages
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    casks = [
      "wezterm"
      "claude-code"
    ];
    brews = [
      "herdr"
    ];
  };
}
