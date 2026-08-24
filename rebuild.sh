#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

OS="$(uname -s)"
if [ "$OS" = Darwin ]; then
  HOST_LABEL="$(sed -nE 's/^[[:space:]]*hostLabel = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
  if [ -z "$HOST_LABEL" ]; then
    echo "Could not find the single \"hostLabel = \" line in flake.nix." >&2
    echo "Edit flake.nix yourself before continuing." >&2
    exit 1
  fi
  # -f /etc/gitconfig, not --system: --system resolves per-git-binary and can
  # land in a nix store path a wrapped git considers "system", not the fixed
  # path Nix's own libgit2 fetcher reads.
  sudo git config -f /etc/gitconfig --get-all safe.directory 2>/dev/null | grep -qx "$DIR" \
    || sudo git config -f /etc/gitconfig --add safe.directory "$DIR"
  exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#"$HOST_LABEL"
elif [ "$OS" = Linux ]; then
  FLAKE_USER="$(sed -nE 's/^[[:space:]]*user = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
  if [ -z "$FLAKE_USER" ]; then
    echo "Could not find the single \"user = \" line in flake.nix." >&2
    echo "Edit flake.nix yourself before continuing." >&2
    exit 1
  fi
  case "$(uname -m)" in
    x86_64) LINUX_SYSTEM=x86_64-linux ;;
    aarch64|arm64) LINUX_SYSTEM=aarch64-linux ;;
    *)
      echo "Unsupported Linux architecture: $(uname -m)" >&2
      exit 1
      ;;
  esac
  # No sudo: standalone home-manager runs entirely as the normal user.
  exec home-manager switch --flake ~/.dotfiles#"${FLAKE_USER}@${LINUX_SYSTEM}"
else
  echo "Unsupported OS: $OS (this repo supports macOS and Ubuntu 22.04 LTS)" >&2
  exit 1
fi
