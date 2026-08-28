#!/usr/bin/env bash
set -euo pipefail

# Installs the optional kunchenguid agentic-engineering toolkit.
# None of these are Homebrew formulae/casks, so `rebuild.sh` can't bring them
# back on a new machine - this script exists so they survive a move.
# Safe to re-run: every step skips work that's already done.

install_if_missing() {
  local name="$1" check="$2" install_cmd="$3"
  if eval "$check" >/dev/null 2>&1; then
    echo "$name already installed, skipping"
  else
    echo "Installing $name..."
    eval "$install_cmd"
  fi
}

install_if_missing "treehouse" "command -v treehouse" \
  "curl -fsSL https://kunchenguid.github.io/treehouse/install.sh | sh"

install_if_missing "no-mistakes" "command -v no-mistakes" \
  "curl -fsSL https://raw.githubusercontent.com/kunchenguid/no-mistakes/main/docs/install.sh | sh"

install_if_missing "gnhf" "command -v gnhf" \
  "npm install -g gnhf"

install_if_missing "lavish-axi (lavish)" "command -v lavish-axi" \
  "npm install -g lavish-axi"

install_if_missing "gh-axi" "command -v gh-axi" \
  "npm install -g gh-axi"

FIRSTMATE_DIR="$HOME/dev/firstmate"
if [ -d "$FIRSTMATE_DIR" ]; then
  echo "firstmate already cloned at $FIRSTMATE_DIR, skipping"
else
  echo "Cloning firstmate into $FIRSTMATE_DIR..."
  mkdir -p "$HOME/dev"
  git clone https://github.com/kunchenguid/firstmate "$FIRSTMATE_DIR"
fi

echo ""
echo "Done. firstmate is cloned but not started - cd into $FIRSTMATE_DIR and"
echo "run your agent CLI (e.g. \`claude\`) there when you're ready to use it."
