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
      # bootstrap.sh offers to rewrite this for you if your macOS username differs.
      user = "thomasharper";
      # The one host label to change if you want to rename the machine.
      # rebuild.sh and bootstrap.sh read this value back out of flake.nix,
      # so it only needs to be changed here. Purely cosmetic - it has no
      # effect on which casks get installed; see includePersonalCasks below
      # for that.
      hostLabel = "mac";
      # Toggle this machine's profile: true installs this Mac's personal
      # GUI apps (Slack, Discord, Spotify, Notion, Figma) alongside the
      # dev tooling everyone gets; false installs dev tooling only (e.g.
      # for a server).
      includePersonalCasks = true;
    in
    {
      darwinConfigurations.${hostLabel} = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user includePersonalCasks; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}
