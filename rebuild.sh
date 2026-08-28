#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# sudo resets PATH to a secure default that excludes /run/current-system/sw/bin,
# so a bare `darwin-rebuild` would not be found under sudo even when it resolves
# here. Resolve the absolute path first and invoke that instead. Fall back to
# the stable nix-darwin system-profile location when darwin-rebuild isn't on
# PATH at all (e.g. /run/current-system/sw/bin was never added to PATH).
if DARWIN_REBUILD="$(command -v darwin-rebuild 2>/dev/null)"; then
  :
elif [ -x /run/current-system/sw/bin/darwin-rebuild ]; then
  DARWIN_REBUILD=/run/current-system/sw/bin/darwin-rebuild
else
  echo "error: darwin-rebuild not found on PATH or at /run/current-system/sw/bin/darwin-rebuild" >&2
  exit 1
fi
exec sudo "$DARWIN_REBUILD" switch --flake ~/.dotfiles#mac
