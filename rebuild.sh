#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
sudo darwin-rebuild switch --flake ~/.dotfiles#mac

echo
echo "Done. Shells that were already open (e.g. panes in a persistent"
echo "multiplexer like herdr) won't see PATH/env changes until you run"
echo "'reload' in them, or open a brand new terminal window."
