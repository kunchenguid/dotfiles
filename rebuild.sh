#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# sudo resolves the command against its own secure PATH, which does not include
# /run/current-system/sw/bin, so a bare `sudo darwin-rebuild` fails with
# "command not found" even though darwin-rebuild is installed. Same workaround
# bootstrap.sh uses for `nix`: resolve the absolute path first, then invoke it.
DARWIN_REBUILD="$(command -v darwin-rebuild || true)"
: "${DARWIN_REBUILD:=/run/current-system/sw/bin/darwin-rebuild}"
# "mac" is the flake host label - if you renamed it, change it in flake.nix
# and bootstrap.sh too.
exec sudo "$DARWIN_REBUILD" switch --flake ~/.dotfiles#mac
