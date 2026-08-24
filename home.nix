{ config, pkgs, lib, user, usePersonalSetup, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # true on macOS (via nix-darwin's home-manager integration), false on the
  # standalone Ubuntu homeConfigurations outputs (see flake.nix). Derived
  # from pkgs.stdenv rather than a passed-in flag, so each flake output gets
  # its own correct platform context automatically.
  isDarwin = pkgs.stdenv.isDarwin;
  osLabel = if isDarwin then "macOS" else "Linux";

  # currentPlatform for ./tool-selection.nix: "macos" here always resolves
  # to the exact same value configuration.nix hardcodes, so this branch is
  # provably a no-op on Darwin (see the drvPath-diff test in tests/).
  currentPlatform = if isDarwin then "macos" else "ubuntu";
  sel = import ./tool-selection.nix { inherit lib usePersonalSetup currentPlatform; };
  # nix-darwin's own environment.systemPackages already installs the macOS
  # Nix tools (configuration.nix); standalone home-manager on Ubuntu has no
  # such system-level list, so home.packages is the only place to add them.
  linuxNixTools = map (t: pkgs.${sel.nixName t}) sel.nixTools;
in

{
  home.username = user;
  home.homeDirectory = if isDarwin then "/Users/${user}" else "/home/${user}";
  home.stateVersion = "24.11";
  programs.home-manager.enable = !isDarwin;
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    docker
    docker-compose
    # nvim-treesitter (main) needs the CLI; brew's tree-sitter is library-only
    tree-sitter
    # the font everything renders in
    nerd-fonts.hack
    # LaTeX: full scheme (all packages/engines) on personal machines to match
    # what MacTeX used to provide; minimal scheme (just pdflatex/xelatex) on
    # non-personal machines (e.g. a server).
    (if usePersonalSetup then texlive.combined.scheme-full else texlive.combined.scheme-basic)
  ] ++ lib.optionals (!isDarwin) linuxNixTools;
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.CLICOLOR = "1";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      # WezTerm leader (Ctrl-Space) + g sends Ctrl-G into the terminal.
      # Replace the current input line with an AI-generated one, no execution.
      ai-fill-buffer() {
        [[ -z $BUFFER ]] && return
        local sys="Output ONLY the raw zsh command for ${osLabel} that accomplishes the task below. No explanation, no markdown, no code fences, no commentary - just the command, ready to run as-is."
        BUFFER=$(claude -p --tools="" --append-system-prompt "$sys" "$BUFFER" 2>/dev/null | sed -e '/^```/d' -e '/^[[:space:]]*$/d')
        CURSOR=$#BUFFER
      }
      zle -N ai-fill-buffer
      bindkey '^G' ai-fill-buffer
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex -s workspace-write -a never";
      gitverify = "ssh-add ${config.home.homeDirectory}/.ssh/id_rsa";

      # One-shot, no tools
      askclaude = ''claude -p --tools=""'';
      askpi = "pi --no-context-files --exclude-tools read,write,edit,bash -p";
      askcodex = "codex exec --ephemeral --sandbox read-only";

      # One-shot, full agent/tool access
      doclaude = "claude -p";
      dopi = "pi -p";
      docodex = "codex exec";

      # Interactive chat, no tools
      chatclaude = ''claude --tools ""'';
      chatpi = "pi --no-context-files --exclude-tools read,write,edit,bash";
      chatcodex = "codex --sandbox read-only --ask-for-approval never";
    } // lib.optionalAttrs isDarwin {
      # macOS-only: clipboard (pbcopy) and sleep control (pmset) have no
      # direct Linux equivalent wired up here.
      cpath = "echo -n `pwd`|pbcopy";
      disablesleep = "sudo pmset -a disablesleep 1";
      enablesleep = "sudo pmset -a disablesleep 0";
    };
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd" "cd" ];
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "tommyrharper";
      email = "thomasrobertharper@gmail.com";
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
}
