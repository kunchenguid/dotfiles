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

if command -v nix >/dev/null 2>&1; then
  activation=$(
    cd "$ROOT" &&
      nix eval --raw \
        '.#homeConfigurations."thomasharper@x86_64-linux".config.home.activation.sshIncludeDotfilesFragments.data' \
        2>/dev/null
  ) || fail "could not evaluate the SSH Include activation fragment"

  scratch_home="$(dotfiles_test_tmproot ssh-fragments-home)"
  mkdir -p "$scratch_home/.ssh"
  cat > "$scratch_home/.ssh/config" <<'SSH_CONFIG'
# Include ~/.ssh/dotfiles.config.public
Include ~/.ssh/dotfiles.config.public.extra
Host colima
  Include ~/.colima/ssh_config
SSH_CONFIG

  HOME="$scratch_home" DRY_RUN_CMD= VERBOSE_ARG= bash -eu -c "$activation"
  HOME="$scratch_home" DRY_RUN_CMD= VERBOSE_ARG= bash -eu -c "$activation"

  [ "$(grep -xcF -- "Include ~/.ssh/dotfiles.config.public" "$scratch_home/.ssh/config")" -eq 1 ] ||
    fail "activation must prepend exactly one public Include line"
  [ "$(grep -xcF -- "Include ~/.ssh/dotfiles.config.private" "$scratch_home/.ssh/config")" -eq 1 ] ||
    fail "activation must prepend exactly one private Include line"

  expected_prefix="$(mktemp "$scratch_home/expected-prefix.XXXXXX")"
  cat > "$expected_prefix" <<'EXPECTED_PREFIX'
Include ~/.ssh/dotfiles.config.public
Include ~/.ssh/dotfiles.config.private
EXPECTED_PREFIX
  head -n 2 "$scratch_home/.ssh/config" | diff -u "$expected_prefix" - >/dev/null ||
    fail "activation must prepend the public Include above the private Include"
  grep -qF -- "Include ~/.colima/ssh_config" "$scratch_home/.ssh/config" ||
    fail "activation must preserve existing Colima config content"

  dry_home="$(dotfiles_test_tmproot ssh-fragments-dry-run-home)"
  HOME="$dry_home" DRY_RUN_CMD=echo VERBOSE_ARG= bash -eu -c "$activation" >/dev/null
  [ ! -e "$dry_home/.ssh/config" ] ||
    fail "dry-run activation must not create or write ~/.ssh/config"
else
  echo "skip: nix not found for SSH activation behavior check"
fi

pass "SSH fragment files, gitignore, and home.nix wiring match the fragment + auto-Include model"
