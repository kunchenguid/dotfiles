#!/usr/bin/env bash
# Covers the zsh alias through the generated Home Manager startup script.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if ! command -v nix >/dev/null 2>&1; then
  echo "skip: nix not found for Home Manager zsh evaluation"
  exit 0
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "skip: zsh not found for shell alias evaluation"
  exit 0
fi

TMP_ROOT=$(dotfiles_test_tmproot hetzner-alias)
TEST_HOME="$TMP_ROOT/home"
ZDOTDIR="$TMP_ROOT/zdotdir"
PRIVATE_DIR="$ROOT/home/.config/zsh"
PRIVATE_FILE="$PRIVATE_DIR/private-env.zsh"
MISSING_ALIAS_OUTPUT="$TMP_ROOT/hetzner-alias-missing"
PLACEHOLDER_HOST="hetzner.example.invalid"

cleanup_private_env() {
  rm -f "$PRIVATE_FILE"
  dotfiles_test_cleanup
}
trap cleanup_private_env EXIT

mkdir -p "$TEST_HOME" "$ZDOTDIR" "$PRIVATE_DIR"
ln -s "$ROOT" "$TEST_HOME/.dotfiles"

render_zshrc() {
  nix eval --raw \
    "$ROOT#darwinConfigurations.mac.config.home-manager.users.thomasharper.programs.zsh.initContent" \
    >"$ZDOTDIR/.zshrc"
}

print_alias() {
  HOME="$TEST_HOME" ZDOTDIR="$ZDOTDIR" zsh -ic 'alias hetzner' 2>/dev/null
}

rm -f "$PRIVATE_FILE"
render_zshrc
if print_alias >"$MISSING_ALIAS_OUTPUT" 2>&1; then
  fail "hetzner alias exists without the private env file"
fi

printf 'export HETZNER_HOST="%s"\n' "$PLACEHOLDER_HOST" >"$PRIVATE_FILE"
render_zshrc
actual=$(print_alias) || fail "hetzner alias missing when private env file is present"
assert_contains "$actual" "ssh root@$PLACEHOLDER_HOST" "hetzner alias does not use the private host value"

if git -C "$ROOT" ls-files --error-unmatch home/.config/zsh/private-env.zsh >/dev/null 2>&1; then
  fail "private zsh env file is tracked"
fi

pass "hetzner alias is generated from an ignored private zsh env file"
