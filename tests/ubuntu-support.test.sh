#!/usr/bin/env bash
# Ubuntu 22.04 LTS support checks: the Linux homeConfigurations outputs
# evaluate to real derivations, and adding them left the existing
# darwinConfigurations.mac output's evaluated derivation byte-for-byte
# unchanged. The macOS check exists because a past Ubuntu-port attempt
# broke it by editing lines home.nix shares between platforms (the
# gitverify alias, the ai-fill-buffer prompt) without gating them per
# platform - functionally harmless on macOS at runtime, but it still
# changed the evaluated derivation. See tool-selection.nix and home.nix.
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

FLAKE_USER=thomasharper

# Pinned at the moment Ubuntu support was layered on top of the tools.nix
# refactor (PR #17, merged as 51fe4b7). Update this only alongside a
# deliberate macOS-affecting change; an unexpected mismatch means something
# meant to be Linux-only leaked into the shared macOS evaluation.
EXPECTED_DARWIN_DRVPATH="/nix/store/5f607r0w92yn7mp7g732xkkvkgj58zlx-darwin-system-26.05.adda04f.drv"

test_darwin_drvpath_unchanged() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for darwin drvPath check"
    return 0
  fi
  local drv
  drv=$(cd "$ROOT" && nix eval --raw .#darwinConfigurations.mac.system.drvPath 2>/dev/null) \
    || fail "darwinConfigurations.mac.system.drvPath failed to evaluate"
  [ "$drv" = "$EXPECTED_DARWIN_DRVPATH" ] \
    || fail "darwinConfigurations.mac's evaluated derivation changed (expected $EXPECTED_DARWIN_DRVPATH, got $drv) - Ubuntu support must never change macOS behavior"
  pass "darwinConfigurations.mac.system.drvPath is byte-for-byte unchanged by adding Ubuntu support"
}

test_linux_home_configurations_evaluate() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux homeConfigurations check"
    return 0
  fi
  local system drv
  for system in x86_64-linux aarch64-linux; do
    drv=$(cd "$ROOT" && nix eval --raw ".#homeConfigurations.\"${FLAKE_USER}@${system}\".activationPackage.drvPath" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" failed to evaluate"
    assert_contains "$drv" ".drv" "homeConfigurations.\"${FLAKE_USER}@${system}\" did not evaluate to a real derivation: $drv"
  done
  pass "homeConfigurations for x86_64-linux and aarch64-linux both evaluate to real derivations"
}

test_darwin_drvpath_unchanged
test_linux_home_configurations_evaluate
