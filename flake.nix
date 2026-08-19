{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:
    let
      # The one username line to change if this isn't your machine.
      # bootstrap.sh offers to rewrite this for you if your local username differs.
      user = "thomasharper";
      # The one host label to change if you want to rename the machine.
      # rebuild.sh and bootstrap.sh read this back out of flake.nix, so it
      # only needs to be changed here.
      hostLabel = "mac";
      # true installs personal brews and GUI casks on macOS (Slack,
      # Discord, Spotify, Notion, Figma) alongside the shared dev tooling,
      # and selects the full TeX Live scheme (all packages/engines) on every OS;
      # false installs dev tooling only (e.g. for a server), with the
      # minimal TeX Live scheme (just pdflatex/xelatex).
      usePersonalSetup = true;
      # Ubuntu 22.04 has no nix-darwin equivalent, so its path is standalone
      # home-manager (below) instead of a darwinConfigurations-style system
      # config: no root, no sudo, no Homebrew.
      linuxSystems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      darwinConfigurations.${hostLabel} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user usePersonalSetup; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "before-home-manager";
            home-manager.extraSpecialArgs = { inherit user usePersonalSetup; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };

      # bootstrap.sh/rebuild.sh select "${user}@$(uname -m)-linux" on Ubuntu.
      homeConfigurations = builtins.listToAttrs (map (system: {
        name = "${user}@${system}";
        value = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          extraSpecialArgs = { inherit user usePersonalSetup; };
          modules = [ ./home.nix ];
        };
      }) linuxSystems);
    };
}
