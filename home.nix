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
  ] ++ lib.optionals (!isDarwin) linuxNixTools
    # skills and pi-coding-agent are npm-backed CLIs (their ~/.local/bin
    # launchers shebang into `node`), so Node needs to stay on PATH after
    # install, not just during it - unlike macOS, where the Homebrew
    # formula's own `node` dependency covers this. gnutar: codex's installer
    # shells out to `tar` to unpack its own download, and a genuinely minimal
    # Ubuntu base image (unlike Docker Hub's ubuntu:22.04) can lack a system
    # tar binary entirely - Nix-managed here so it's always present rather
    # than assumed from the base image.
    ++ lib.optionals (!isDarwin) [ nodejs gnutar ];
  # Fast-moving tools.nix entries with a verified non-interactive install
  # path (see tools.nix's nativeInstallUrl/nativeInstallNpmPackage comments
  # for each tool's evidence). Skips the install when the binary is already
  # present, so a rebuild with network access already spent doesn't re-fetch
  # every time.
  home.activation.installNativeTools = lib.mkIf (!isDarwin) (
    lib.hm.dag.entryAfter [ "writeBoundary" ] (lib.concatMapStrings (t: ''
      if [ ! -x "$HOME/.local/bin/${sel.nativeInstallBinName t}" ]; then
        if [ -n "''${DRY_RUN_CMD:-}" ]; then
          ${if t.nativeInstallUrl or null != null then
            ''echo "Would install ${t.name} via ${t.nativeInstallUrl}"''
          else
            ''echo "Would install ${t.name} via npm install -g ${t.nativeInstallNpmPackage}"''
          }
        else
          (
            # install.sh scripts (herdr's included) shell out to their own
            # curl/coreutils/tar calls internally, so both the outer curl and
            # the piped-in script need those on PATH - export, don't prefix,
            # so it covers the whole pipeline instead of just curl.
            # $HOME/.local/bin is included so codex's installer sees its
            # target dir already on PATH and skips rewriting a shell profile;
            # nodejs's bin is included for pi-coding-agent's installer and
            # the npm branch below, both of which need `node`/`npm` present
            # to do anything. gnutar's bin is included because codex's
            # installer hard-requires `tar` to unpack its own download, and a
            # genuinely minimal base image's PATH (appended after this list)
            # may not have one - see home.packages' gnutar entry above.
            export PATH="${pkgs.curl}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.gnutar}/bin:${pkgs.nodejs}/bin:$HOME/.local/bin:$PATH"
            # CODEX_NON_INTERACTIVE: skips codex's installer prompts (safe
            # no-op for the other tools, which don't read it).
            # NPM_CONFIG_PREFIX: nodejs's own npm prefix lives in the
            # read-only /nix/store, so a plain `npm install -g` would fail;
            # pointing it at ~/.local lands binaries in $HOME/.local/bin,
            # same as every other native install here.
            export CODEX_NON_INTERACTIVE=1
            export NPM_CONFIG_PREFIX="$HOME/.local"
            set -o pipefail
            ${if t.nativeInstallUrl or null != null then ''
              ${pkgs.curl}/bin/curl -fsSL ${lib.escapeShellArg t.nativeInstallUrl} | ${pkgs.runtimeShell}
            '' else ''
              ${pkgs.nodejs}/bin/npm install -g ${lib.escapeShellArg t.nativeInstallNpmPackage}
            ''}
          # Fault isolation: activation scripts run under `set -e`, so one
          # tool's install failing (e.g. a transient network error, or an
          # installer's own environment check) would otherwise abort every
          # later tool in this same loop without ever attempting them. Each
          # tool's block is independently caught and reported loudly instead
          # - a silent partial install would be worse than a visible one.
          ) || echo "WARNING: native install of ${t.name} failed (exit $?) - continuing with remaining tools" >&2
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
