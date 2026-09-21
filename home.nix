{ pkgs, config, ... }:
{
  home.stateVersion = "25.05";
  home.username = "oibaf";
  home.homeDirectory = "/Users/oibaf";

  home.packages = [
    pkgs.neovim
    pkgs.nerd-fonts.hack
    pkgs.starship
  ];

  # Point at the repo so Lazy can write lazy-lock.json (nix store is read-only)
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/nvim";
  home.file.".config/claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/claude/settings.json";
  home.file."Documents/claude.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home-agents.md";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      v = "nvim";
      rebuild = "~/.dotfiles/rebuild.sh";
    };
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
  };
}
