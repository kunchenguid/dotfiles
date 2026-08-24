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
  # Fast-moving tools.nix entries with a verified non-interactive install.sh
  # (currently just herdr - see tools.nix's nativeInstallUrl comment for why
  # the other useNative-selected tools aren't included here). Skips the
  # download when the binary is already present, so a rebuild with network
  # access already spent doesn't re-fetch every time.
  home.activation.installNativeTools = lib.mkIf (!isDarwin) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.concatMapStrings (t: ''
      if [ ! -x "$HOME/.local/bin/${t.name}" ]; then
        if [ -n "''${DRY_RUN_CMD:-}" ]; then
          echo "Would install ${t.name} via ${t.nativeInstallUrl}"
        else
          # install.sh scripts (herdr's included) shell out to their own
          # curl/coreutils calls internally, so both the outer curl and the
          # piped-in script need those on PATH - export, don't prefix, so it
          # covers the whole pipeline instead of just curl.
          (
            export PATH="${pkgs.curl}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:$PATH"
            set -o pipefail
            ${pkgs.curl}/bin/curl -fsSL ${lib.escapeShellArg t.nativeInstallUrl} | ${pkgs.runtimeShell}
          )
        fi
      fi
    '') sel.nativeInstallTools)
  );
  # So a native-installed binary like herdr (placed in ~/.local/bin by its
  # own installer, above) is actually reachable after a shell restart.
  home.sessionPath = lib.optionals (!isDarwin) [ "${config.home.homeDirectory}/.local/bin" ];
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

      private_env="$HOME/.dotfiles/home/.config/zsh/private-env.zsh"
      unset HETZNER_HOST
      if [[ -r "$private_env" ]]; then
        source "$private_env"
      fi
      unset private_env

      if [[ -n "''${HETZNER_HOST:-}" ]]; then
        alias hetzner="ssh ${user}@$HETZNER_HOST"
      fi
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

  # ~/.ssh/config itself is NOT managed - Colima and other tools rewrite it
  # freely, and rebuild must never overwrite or regenerate it. Instead we
  # symlink two dotfiles-owned fragments and idempotently Include them (see
  # activation script below). Safe cross-machine defaults live in the
  # committed, per-platform dotfiles.config.public.{darwin,linux}; per-host
  # secrets live in the gitignored dotfiles.config.private (copy from
  # dotfiles.config.private.example) - see README.md "SSH config".
  home.file.".ssh/dotfiles.config.public".source =
    config.lib.file.mkOutOfStoreSymlink
      "${dotfiles}/home/.ssh/dotfiles.config.public.${if isDarwin then "darwin" else "linux"}";
  home.file.".ssh/dotfiles.config.private".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.ssh/dotfiles.config.private";

  # Prepend Include lines for the two fragments above into ~/.ssh/config if
  # they aren't already there, so a fresh machine gets them wired in on the
  # first rebuild with no manual paste. Prepended (not appended) so dotfiles
  # defaults load first and Colima/other tools can keep appending to the
  # bottom of the file untouched. Never touches existing content otherwise.
  home.activation.sshIncludeDotfilesFragments = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ssh_dir="$HOME/.ssh"
    ssh_config="$ssh_dir/config"

    if [ -n "''${DRY_RUN_CMD:-}" ]; then
      $DRY_RUN_CMD mkdir -p $VERBOSE_ARG "$ssh_dir"
      [ -e "$ssh_config" ] || $DRY_RUN_CMD touch $VERBOSE_ARG "$ssh_config"
    else
      mkdir -p $VERBOSE_ARG "$ssh_dir"
      touch $VERBOSE_ARG "$ssh_config"
    fi

    # Reverse order: each prepend pushes the new line above existing
    # content, so prepending private then public leaves public on top -
    # the order the two Includes are meant to appear in.
    for include_line in \
      "Include ~/.ssh/dotfiles.config.private" \
      "Include ~/.ssh/dotfiles.config.public"
    do
      if ! [ -f "$ssh_config" ] || ! grep -qxF -- "$include_line" "$ssh_config"; then
        if [ -n "''${DRY_RUN_CMD:-}" ]; then
          $DRY_RUN_CMD prepend "$include_line" "$ssh_config"
          continue
        fi

        tmp="$(mktemp "$ssh_dir/config.XXXXXX")"
        printf '%s\n' "$include_line" > "$tmp"
        cat "$ssh_config" >> "$tmp"
        mv $VERBOSE_ARG "$tmp" "$ssh_config"
      fi
    done
  '';
}
