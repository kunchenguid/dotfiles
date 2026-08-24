#!/usr/bin/env bash
# Takes a fresh Mac or Ubuntu 22.04 LTS box from nothing to a built config.
# Run this once. After it finishes, use ./rebuild.sh for every later change.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM=darwin ;;
  Linux) PLATFORM=linux ;;
  *)
    echo "Unsupported OS: $OS (this repo supports macOS and Ubuntu 22.04 LTS)"
    exit 1
    ;;
esac

if [ "$PLATFORM" = linux ]; then
  case "$(uname -m)" in
    x86_64) LINUX_SYSTEM=x86_64-linux ;;
    aarch64|arm64) LINUX_SYSTEM=aarch64-linux ;;
    *)
      echo "Unsupported Linux architecture: $(uname -m)"
      exit 1
      ;;
  esac
fi

echo "==> Step 1: Determinate Nix"
if command -v nix >/dev/null 2>&1; then
  echo "    nix already installed, skipping"
else
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

echo "==> Step 2: symlink this repo to ~/.dotfiles"
# home.nix resolves its mkOutOfStoreSymlink paths through ~/.dotfiles, so this
# has to exist before the first switch or the build will fail to find them.
ln -sfn "$DIR" ~/.dotfiles

echo "==> Step 3: personalize the configured username"
# Do this before any sudo call (macOS only): sudo resets $USER to root, so
# whoami has to run as the real interactive user first.
REAL_USER="$(whoami)"
FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ -z "$FLAKE_USER" ]; then
  echo "    Could not find the single \"user = \" line in flake.nix."
  echo "    Edit flake.nix yourself before continuing."
  exit 1
elif [ "$FLAKE_USER" != "$REAL_USER" ]; then
  echo "    flake.nix is configured for user \"$FLAKE_USER\", but you are \"$REAL_USER\"."
  read -r -p "    Rewrite flake.nix's \"user = \" line to \"$REAL_USER\"? [y/N] " REPLY
  if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    if [ "$PLATFORM" = darwin ]; then
      sed -i '' -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    else
      sed -i -E "s/^([[:space:]]*user = \")[^\"]+(\";.*)/\1${REAL_USER}\2/" "$DIR/flake.nix"
    fi
    FLAKE_USER="$REAL_USER"
    echo "    Updated. Review the change with: git diff flake.nix"
  else
    echo "    Skipped. Edit the single \"user = \" line in flake.nix yourself before continuing."
    exit 1
  fi
else
  echo "    flake.nix already matches \"$REAL_USER\", nothing to do."
fi

if [ "$PLATFORM" = darwin ]; then
  echo "==> Step 4: trust this repo for root"
  # darwin-rebuild always runs via sudo, so root evaluates this flake's
  # git+file:// input. libgit2 refuses to open a repo owned by a different
  # user unless it's allow-listed - add it once, idempotently.
  # -f /etc/gitconfig, not --system: --system resolves per-git-binary and can
  # land in a nix store path a wrapped git considers "system", not the fixed
  # path Nix's own libgit2 fetcher reads.
  sudo git config -f /etc/gitconfig --get-all safe.directory 2>/dev/null | grep -qx "$DIR" \
    || sudo git config -f /etc/gitconfig --add safe.directory "$DIR"

  echo "==> Step 5: first darwin-rebuild switch (pinned to nix-darwin-26.05)"
  # darwin-rebuild doesn't exist yet on a fresh machine, so run it straight
  # from the flake this once. After this, rebuild.sh works normally.
  # This fetches the darwin-rebuild tool from the nix-darwin-26.05 release branch,
  # not the exact flake.lock revision. The system config it applies is still pinned
  # by this repo's flake.lock.
  # sudo resets PATH to a secure default that excludes /nix/.../bin, so a
  # freshly installed `nix` would not be found under sudo even though it's
  # on PATH here. Resolve the absolute path first and invoke that instead.
  NIX_BIN="$(command -v nix)"
  FLAKE_HOST_LABEL="$(sed -nE 's/^[[:space:]]*hostLabel = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
  if [ -z "$FLAKE_HOST_LABEL" ]; then
    echo "    Could not find the single \"hostLabel = \" line in flake.nix."
    echo "    Edit flake.nix yourself before continuing."
    exit 1
  fi
  sudo "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
    switch --flake ~/.dotfiles#"$FLAKE_HOST_LABEL"
  # If this still fails with "nix: command not found", open a new terminal
  # (Determinate adds nix to new shells' PATH) and re-run ./bootstrap.sh.
else
  echo "==> Step 4: first home-manager switch (pinned to release-26.05)"
  # Standalone home-manager runs as the normal user - no root, no sudo, and
  # no /etc/gitconfig trust step (that step exists on macOS only because
  # darwin-rebuild runs as root). home-manager doesn't exist yet on a fresh
  # machine, so run it straight from its own flake this once; after this,
  # rebuild.sh calls the installed `home-manager` command directly.
  nix run github:nix-community/home-manager/release-26.05 -- \
    switch --flake ~/.dotfiles#"${FLAKE_USER}@${LINUX_SYSTEM}"

  echo "==> Step 5: make zsh the login shell"
  # home.nix configures programs.zsh and nothing else, so on a box that still
  # logs you into /bin/bash none of it is ever sourced: no aliases, and - the
  # one that actually bites - no SSH_AUTH_SOCK, because home-manager's
  # services.ssh-agent module only injects that export into the shells it
  # manages. The systemd ssh-agent runs, but bash can't see it, so every
  # git pull re-prompts for the key passphrase. macOS already logs into zsh,
  # hence Linux-only. This is the one step here that needs sudo.
  ZSH_BIN="$HOME/.nix-profile/bin/zsh"
  CURRENT_SHELL="$(getent passwd "$REAL_USER" | cut -d: -f7)"
  if [ "$CURRENT_SHELL" = "$ZSH_BIN" ]; then
    echo "    already $ZSH_BIN, nothing to do"
  elif ! "$ZSH_BIN" -lc 'exit 0' >/dev/null 2>&1; then
    # Never chsh to a shell that doesn't run: sshd hands you your login shell
    # and nothing else, so a bad one locks you out of the machine entirely.
    echo "    WARNING: $ZSH_BIN does not start - leaving the login shell as $CURRENT_SHELL" >&2
  else
    # chsh rejects any shell missing from /etc/shells.
    grep -qxF "$ZSH_BIN" /etc/shells || echo "$ZSH_BIN" | sudo tee -a /etc/shells >/dev/null
    sudo chsh -s "$ZSH_BIN" "$REAL_USER"
    echo "    login shell is now $ZSH_BIN - open a new SSH session to pick it up"
  fi
fi

echo "==> Done. Use ./rebuild.sh for future changes."
