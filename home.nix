{ config, pkgs, user, treehouse, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  imports = [ ./vscode.nix ];

  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    # vscode + its extensions live in ./vscode.nix
    # the font everything renders in
    nerd-fonts.hack
    # treehouse install
    treehouse.packages.${pkgs.system}.default
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
      server = "python3 -m http.server 8080";
      # run models all night / clamshell without letting the computer sleep
      preventsleep = "sudo pmset -b sleep 0; sudo pmset -b disablesleep 1";
      enablesleep = "sudo pmset -b sleep 30; sudo pmset -b disablesleep 0";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Keep Pi's credential and runtime state local by linking only authored files and directories.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  # VSCode
  home.file."Library/Application Support/Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.vscode/settings.json";


  # we're using nix to install homebrew, then homebrew to install nodejs/npm so
  # that we can keep it updated easier than relying on the nix packages.
  # However, that means we must install the packages ourselves and homebrew 
  # doesn't have packages for all of them (neither does nix actually) so...
  # ...here we are with a hacky post-install script.
  home.activation.installNpmPackages = lib.hm.dag.entryAfter ["writeBoundary"] ''
    BREW_BIN="/opt/homebrew/bin"
    NODE_PATH="$BREW_BIN/node"
    NPM_PATH="$BREW_BIN/npm"
    NPX_PATH="$BREW_BIN/npx"

    if [ -x "$NPM_PATH" ]; then
      export PATH="$BREW_BIN:$PATH"

      # export NPM_CONFIG_PREFIX="${config.home.homeDirectory}/.npm-global"
      # mkdir -p "$NPM_CONFIG_PREFIX"

      echo "Installing global npm packages via Homebrew Node..."
      $DRY_RUN_CMD "$NPM_PATH" install -g skills gh-axi chrome-devtools-axi gnhf
    else
      echo "Warning: Homebrew npm not found at $NPM_PATH yet. Skipping."
    fi

    if [ -x "$NPX_PATH" ]; then
      export PATH="$BREW_BIN:$PATH"
      $DRY_RUN_CMD "$NPX_PATH" skills add kunchenguid/lavish-axi --skill lavish

      # report installed skills
      "$NPX_PATH" skills list -g
    else
      echo "Warning: Homebrew npx not found at $NPX_PATH yet. Skipping."
    fi

    # also install the no-mistakes binary
    $DRY_RUN_CMD go install github.com/kunchenguid/no-mistakes/cmd/no-mistakes@latest
  '';
}
