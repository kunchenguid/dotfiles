#!/usr/bin/env bash
# Covers programs.ssh in home.nix: the generated ~/.ssh/config has the
# safe/general managed blocks, and per-host private entries are merged
# only via an Include of a gitignored file whose content Nix never reads.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

if ! command -v nix >/dev/null 2>&1; then
  echo "skip: nix not found for Home Manager ssh evaluation"
  exit 0
fi

EXAMPLE_FILE="$ROOT/home/.ssh/config.private.example"
# home.nix Includes the private file via a fixed ~/.dotfiles clone path
# (config.home.homeDirectory + "/.dotfiles"), independent of where this repo
# checkout actually lives, so assert on that suffix rather than $ROOT.
PRIVATE_FILE_SUFFIX="/.dotfiles/home/.ssh/config.private"

if git -C "$ROOT" ls-files --error-unmatch home/.ssh/config.private >/dev/null 2>&1; then
  fail "private ssh config file is tracked"
fi

if ! git -C "$ROOT" check-ignore -q home/.ssh/config.private; then
  fail "home/.ssh/config.private is not gitignored"
fi

[ -f "$EXAMPLE_FILE" ] || fail "home/.ssh/config.private.example is missing"
assert_contains "$(cat "$EXAMPLE_FILE")" "your-server-ip-or-hostname" \
  "config.private.example must use a placeholder HostName, not a real one"

rendered=$(nix eval --raw \
  "$ROOT#darwinConfigurations.mac.config.home-manager.users.thomasharper.home.file.\".ssh/config\".text" \
  2>/dev/null) || fail "programs.ssh config.text failed to evaluate"

assert_contains "$rendered" "Include " \
  "rendered ~/.ssh/config is missing an Include directive"
assert_contains "$rendered" "$PRIVATE_FILE_SUFFIX" \
  "rendered ~/.ssh/config does not Include the private ssh config file by path"
assert_contains "$rendered" "Host github.com" \
  "rendered ~/.ssh/config is missing the managed github.com block"
assert_contains "$rendered" "Host *" \
  "rendered ~/.ssh/config is missing the managed Host * defaults block"
assert_contains "$rendered" "IdentitiesOnly yes" \
  "rendered ~/.ssh/config is missing IdentitiesOnly hardening"

# Nix only ever embeds the private file's *path* into the store, never its
# content - so the derivation output can't contain per-host secrets even
# before the file exists locally.
assert_not_contains "$rendered" "HostName " \
  "rendered ~/.ssh/config must not inline any private Host block's HostName"

pass "programs.ssh manages safe defaults declaratively and Includes private per-host entries by path only"
