#!/bin/sh
set -e
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"
cd "$DOTFILES"
# path: avoids libgit2 "not owned by current user" when sudo runs the flake eval
exec sudo darwin-rebuild switch --flake "path:$DOTFILES#Mac"
