{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
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
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LSCOLORS = "BxBxhxDxfxhxhxhxhxcxcx";  # palette for the `ls -G` aliases below
    MANPAGER = "less -X";                 # don't clear the screen after quitting a man page
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    ANDROID_NDK_HOME = "/opt/homebrew/share/android-ndk";
  };

  # Toolchains that install themselves under $HOME rather than through nix.
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.bun/bin"
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid

    history = {
      size = 32768;
      save = 32768;
      ignoreAllDups = true;  # HISTCONTROL=ignoredups
      ignoreSpace = true;    # HISTCONTROL=ignorespace
      share = true;
    };

    initContent = ''
      bindkey '^f' autosuggest-accept

      # Up/Down search history using what is already typed, rather than walking
      # every past command. Carried over from the old ~/.inputrc.
      autoload -U up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[[3;3~' kill-word          # Alt+Delete kills the preceding word

      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # completion-ignore-case
      zstyle ':completion:*' list-dirs-first true
      compdef g=git                                              # complete `g` as git

      setopt AUTO_CD NO_CASE_GLOB

      # Non-nix toolchains. Each guard is a no-op when the tool isn't installed.
      export GPG_TTY=$(tty)
      command -v pyenv >/dev/null && eval "$(pyenv init -)"
      [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
      [[ -r /opt/homebrew/share/google-cloud-sdk/path.zsh.inc ]] \
        && source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc
      [[ -r /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc ]] \
        && source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
    '';

    shellAliases = {
      # navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      p = "cd ~/Projects";
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";

      # git
      g = "git";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";

      # ls - BSD ls on macOS; LSCOLORS above supplies the palette
      ls = "command ls -G";
      l = "ls -lF";
      la = "ls -lAF";
      lsd = "ls -lF | grep --color=never '^d'";

      # misc
      activate = ". venv/bin/activate";
      reload = "exec $SHELL -l";
      path = "print -l \${(s.:.)PATH}";

      # agents
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Michael Shandrovskiy";
        email = "misha84@gmail.com";
      };
      commit.gpgsign = false;
      pull.rebase = false;
      core = {
        untrackedCache = true;
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
      };
      diff.renames = "copies";
      merge.log = true;
      help.autocorrect = 1;
      push = {
        default = "simple";
        followTags = true;
      };
      color.ui = "auto";

      alias = {
        # Abbreviated SHA, description, and history graph of the latest 20 commits
        l = "log --pretty=oneline -n 20 --graph --abbrev-commit";

        s = "status -s";
        st = "status";

        # Diff between the latest commit and the current state
        d = ''!git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat'';

        # Diff between the state $1 revisions ago and the current state
        di = ''!d() { git diff --patch-with-stat HEAD~$1; }; git diff-index --quiet HEAD -- || clear; d'';

        # Diff of what is staged
        diffs = "diff --staged";

        p = "pull --recurse-submodules";
        c = "clone --recursive";
        ca = "!git add -A && git commit -av";
        co = "checkout";
        br = "branch";

        # Switch to a branch, creating it if necessary
        go = ''!f() { git checkout -b "$1" 2> /dev/null || git checkout "$1"; }; f'';

        tags = "tag -l";
        branches = "branch -a";
        remotes = "remote -v";
        aliases = "config --get-regexp alias";

        amend = "commit --amend --reuse-message=HEAD";

        # Credit an author on the latest commit
        credit = ''!f() { git commit --amend --author "$1 <$2>" -C HEAD; }; f'';

        # Interactive rebase with the given number of latest commits
        reb = ''!r() { git rebase -i HEAD~$1; }; r'';

        # Remove the old tag with this name and tag the latest commit with it
        retag = ''!r() { git tag -d $1 && git push origin :refs/tags/$1 && git tag $1; }; r'';

        # Find branches / tags containing a commit
        fb = ''!f() { git branch -a --contains $1; }; f'';
        ft = ''!f() { git describe --always --contains $1; }; f'';

        # Find commits by source code / by commit message
        fc = ''!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f'';
        fm = ''!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f'';

        # Delete branches already merged into the current one
        dm = ''!git branch --merged | grep -v '\*' | xargs -n 1 git branch -d'';

        contributors = "shortlog --summary --numbered";

        # Email configured for the current repository
        whoami = "config user.email";

        # Merge a GitHub pull request on top of the current branch, or of $2
        mpr = ''!f() { declare currentBranch="$(git symbolic-ref --short HEAD)"; declare branch="''${2:-$currentBranch}"; if [ $(printf "%s" "$1" | grep '^[0-9]\+$' > /dev/null; printf $?) -eq 0 ]; then git fetch origin refs/pull/$1/head:pr/$1 && git checkout -B $branch && git rebase $branch pr/$1 && git checkout -B $branch && git merge pr/$1 && git branch -D pr/$1 && git commit --amend -m "$(git log -1 --pretty=%B)\n\nCloses #$1."; fi }; f'';
      };
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
