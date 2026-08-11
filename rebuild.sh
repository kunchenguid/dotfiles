#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
HOST_LABEL="$(sed -nE 's/^[[:space:]]*hostLabel = "([^"]+)";.*/\1/p' "$DIR/flake.nix" | head -n1)"
if [ -z "$HOST_LABEL" ]; then
  echo "Could not find the single \"hostLabel = \" line in flake.nix." >&2
  echo "Edit flake.nix yourself before continuing." >&2
  exit 1
fi
sudo git config --system --get-all safe.directory 2>/dev/null | grep -qx "$DIR" \
  || sudo git config --system --add safe.directory "$DIR"
exec sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#"$HOST_LABEL"
