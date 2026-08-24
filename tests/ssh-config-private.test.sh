#!/usr/bin/env bash
# Covers the SSH fragment model in home.nix: ~/.ssh/config itself is never
# managed (Colima and other tools must be free to rewrite it) - only two
# dotfiles-owned fragments are symlinked in and Included idempotently by an
# activation script. See home.nix and README.md "SSH config".
set -u

# shellcheck source=tests/lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

EXAMPLE_FILE="$ROOT/home/.ssh/dotfiles.config.private.example"
PUBLIC_DARWIN="$ROOT/home/.ssh/dotfiles.config.public.darwin"
PUBLIC_LINUX="$ROOT/home/.ssh/dotfiles.config.public.linux"

if git -C "$ROOT" ls-files --error-unmatch home/.ssh/dotfiles.config.private >/dev/null 2>&1; then
  fail "private ssh config file is tracked"
fi

if ! git -C "$ROOT" check-ignore -q home/.ssh/dotfiles.config.private; then
  fail "home/.ssh/dotfiles.config.private is not gitignored"
fi

[ -f "$EXAMPLE_FILE" ] || fail "home/.ssh/dotfiles.config.private.example is missing"
assert_contains "$(cat "$EXAMPLE_FILE")" "your-server-ip-or-hostname" \
  "dotfiles.config.private.example must use a placeholder HostName, not a real one"

[ -f "$PUBLIC_DARWIN" ] || fail "home/.ssh/dotfiles.config.public.darwin is missing"
[ -f "$PUBLIC_LINUX" ] || fail "home/.ssh/dotfiles.config.public.linux is missing"

for public_file in "$PUBLIC_DARWIN" "$PUBLIC_LINUX"; do
  contents="$(cat "$public_file")"
  assert_contains "$contents" "Host github.com" \
    "$public_file is missing the managed github.com block"
  assert_contains "$contents" "Host *" \
    "$public_file is missing the managed Host * defaults block"
  assert_contains "$contents" "IdentitiesOnly yes" \
    "$public_file is missing IdentitiesOnly hardening"
  assert_not_contains "$contents" "your-server-ip-or-hostname" \
    "$public_file must not contain placeholder private hostnames"
  assert_not_contains "$contents" "HostName " \
    "$public_file must not contain any per-host HostName entries - those belong in dotfiles.config.private"
done

assert_contains "$(cat "$PUBLIC_DARWIN")" "UseKeychain yes" \
  "dotfiles.config.public.darwin is missing UseKeychain"
assert_not_contains "$(cat "$PUBLIC_LINUX")" "UseKeychain" \
  "dotfiles.config.public.linux must not reference UseKeychain (macOS-only)"
assert_not_contains "$(cat "$PUBLIC_LINUX")" ".colima/ssh_config" \
  "dotfiles.config.public.linux must not Include Colima's ssh_config"
assert_not_contains "$(cat "$PUBLIC_DARWIN")" ".colima/ssh_config" \
  "dotfiles.config.public.darwin must not Include Colima's ssh_config - Colima stays in the unmanaged ~/.ssh/config"

home_nix="$(cat "$ROOT/home.nix")"
assert_not_contains "$home_nix" "programs.ssh" \
  "home.nix must not reintroduce programs.ssh - only fragment symlinks + activation are allowed"
assert_contains "$home_nix" '".ssh/dotfiles.config.public"' \
  "home.nix is missing the dotfiles.config.public symlink"
assert_contains "$home_nix" '".ssh/dotfiles.config.private"' \
  "home.nix is missing the dotfiles.config.private symlink"
assert_contains "$home_nix" "home.activation" \
  "home.nix is missing a home.activation entry to wire up the SSH Include lines"
assert_contains "$home_nix" "Include ~/.ssh/dotfiles.config.public" \
  "home.nix activation script is missing the public fragment Include line"
assert_contains "$home_nix" "Include ~/.ssh/dotfiles.config.private" \
  "home.nix activation script is missing the private fragment Include line"
assert_contains "$home_nix" "DRY_RUN_CMD" \
  "home.nix SSH activation script must respect \$DRY_RUN_CMD like other Home Manager activations"

# The idempotent-prepend behavior itself (second rebuild doesn't duplicate
# Include lines, existing content like a Colima block survives) is exercised
# against a scratch $HOME/.ssh in a disposable directory, not via nix eval -
# see the manual verification noted in the PR description.

pass "SSH fragment files, gitignore, and home.nix wiring match the fragment + auto-Include model"
