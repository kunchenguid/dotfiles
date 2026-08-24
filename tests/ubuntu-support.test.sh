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
# refactor (PR #17, merged as 51fe4b7), then re-pinned after deliberate
# macOS-affecting changes to shared Home Manager zsh initContent, most recently
# when the Hetzner alias changed from root to the configured user, then
# re-pinned again after the fm/dotfiles-ssh-fragment-approach change replaced
# programs.ssh with fragment symlinks + an Include-prepending activation
# script in home.nix.
# Update this only alongside a deliberate macOS-affecting change; an
# unexpected mismatch means something meant to be Linux-only leaked into
# the shared macOS evaluation.
EXPECTED_DARWIN_DRVPATH="/nix/store/50xdh8icbkm5qyh90nrwmhlwbiaf8rl1-darwin-system-26.05.adda04f.drv"

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

test_linux_home_manager_cli_enabled() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux home-manager CLI check"
    return 0
  fi
  local system enabled
  for system in x86_64-linux aarch64-linux; do
    enabled=$(cd "$ROOT" && nix eval --json ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.programs.home-manager.enable" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" home-manager CLI setting failed to evaluate"
    [ "$enabled" = "true" ] \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" must install the home-manager CLI so ./rebuild.sh works after bootstrap"
  done
  pass "home-manager CLI is installed by both Linux homeConfigurations outputs"
}

test_linux_treesitter_buildtools_present() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux build-toolchain check"
    return 0
  fi
  local system names pkg
  for system in x86_64-linux aarch64-linux; do
    names=$(cd "$ROOT" && nix eval --json ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.packages" \
      --apply 'pkgs: map (p: p.pname or p.name) pkgs' 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" home.packages failed to evaluate"
    for pkg in gcc-wrapper gnumake pkg-config-wrapper; do
      assert_contains "$names" "\"$pkg\"" \
        "homeConfigurations.\"${FLAKE_USER}@${system}\" is missing $pkg (needed for nvim-treesitter parser compilation: cc/make/pkg-config)"
    done
  done
  pass "gcc, make, and pkg-config are wired into home.packages for both Linux homeConfigurations outputs"
}

test_linux_nodejs_present_for_npm_backed_native_tools() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux nodejs check"
    return 0
  fi
  # skills and pi-coding-agent are npm-backed CLIs: their ~/.local/bin
  # launcher scripts shebang into `node`, so Node must stay on PATH after
  # install too, not just during it (unlike macOS, where the Homebrew
  # formula's own `node` dependency covers this) - see home.nix's home.packages.
  local system names
  for system in x86_64-linux aarch64-linux; do
    names=$(cd "$ROOT" && nix eval --json ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.packages" \
      --apply 'pkgs: map (p: p.pname or p.name) pkgs' 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" home.packages failed to evaluate"
    assert_contains "$names" "\"nodejs\"" \
      "homeConfigurations.\"${FLAKE_USER}@${system}\" is missing nodejs - skills and pi-coding-agent's launchers need node on PATH at runtime, not just during install"
  done
  pass "nodejs is wired into home.packages for both Linux homeConfigurations outputs"
}

test_linux_native_install_tools_wired() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux native-install check"
    return 0
  fi
  # Every useNative-selected tools.nix entry that is expected to have a
  # working unattended installer, the real ~/.local/bin binary name each
  # one's installer actually produces (see tools.nix's nativeInstallBinName
  # comment: claude-code's and pi-coding-agent's launcher names differ from
  # their tools.nix entry name), and the exact dry-run line it must print.
  local expected_name_binname="claude-code claude
codex codex
herdr herdr
skills skills
pi-coding-agent pi"
  local expected_dry_run_lines=(
    "Would install claude-code via https://claude.ai/install.sh"
    "Would install codex via https://chatgpt.com/codex/install.sh"
    "Would install herdr via https://herdr.dev/install.sh"
    "Would install skills via npm install -g skills"
    "Would install pi-coding-agent via https://pi.dev/install.sh"
  )
  local system selected data tmp_home dry_run_output path_has_local_bin bin_name expect_line
  for system in x86_64-linux aarch64-linux; do
    selected=$(cd "$ROOT" && nix eval --raw --impure --expr "
      let
        flake = builtins.getFlake \"path:$ROOT\";
        pkgs = import flake.inputs.nixpkgs { system = \"$system\"; };
        sel = import $ROOT/tool-selection.nix {
          inherit (pkgs) lib;
          usePersonalSetup = true;
          currentPlatform = \"ubuntu\";
        };
      in pkgs.lib.concatStringsSep \"\n\" (map (t: t.name + \" \" + sel.nativeInstallBinName t) sel.nativeInstallTools)
    " 2>/dev/null) \
      || fail "tool-selection.nix nativeInstallTools failed to evaluate for $system"
    [ "$selected" = "$expected_name_binname" ] \
      || fail "tool-selection.nix nativeInstallTools must contain exactly claude-code, codex, herdr, skills, and pi-coding-agent's unattended installers (name binName) for $system, got: $selected"

    data=$(cd "$ROOT" && nix eval --raw ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.activation.installNativeTools.data" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" has no installNativeTools activation script - useNative correctly classifying these tools is not enough, something has to actually install them"

    tmp_home=$(dotfiles_test_tmproot "dotfiles-native-install-$system")
    dry_run_output=$(HOME="$tmp_home" DRY_RUN_CMD=1 bash -eu -o pipefail -c "$data" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools activation failed in dry-run mode"
    for expect_line in "${expected_dry_run_lines[@]}"; do
      assert_contains "$dry_run_output" "$expect_line" \
        "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools dry-run missing expected line: $expect_line (got: $dry_run_output)"
    done

    path_has_local_bin=$(cd "$ROOT" && nix eval --raw ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.sessionPath" \
      --apply 'p: if builtins.elem "/home/thomasharper/.local/bin" p then "true" else "false"' 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" home.sessionPath failed to evaluate"
    [ "$path_has_local_bin" = "true" ] \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" does not put ~/.local/bin (where every native installer here places its binary) on PATH"

    mkdir -p "$tmp_home/.local/bin"
    for bin_name in claude codex herdr skills pi; do
      touch "$tmp_home/.local/bin/$bin_name"
      chmod +x "$tmp_home/.local/bin/$bin_name"
    done
    dry_run_output=$(HOME="$tmp_home" DRY_RUN_CMD=1 bash -eu -o pipefail -c "$data" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools activation failed when every tool was already installed"
    [ -z "$dry_run_output" ] \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools must skip every tool already installed under its real binary name, got: $dry_run_output"
  done
  pass "claude-code, codex, herdr, skills, and pi-coding-agent's native installers are all wired into home.activation, correctly keyed to their real ~/.local/bin binary names, for both Linux homeConfigurations outputs"
}

test_linux_gnutar_present_for_native_installers() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux gnutar check"
    return 0
  fi
  # codex's own installer hard-requires a `tar` binary to unpack its
  # download ("tar is required to install Codex."), and a genuinely minimal
  # Ubuntu base image can lack one entirely - unlike Docker Hub's
  # ubuntu:22.04, which happens to ship tar and can mask this in testing.
  # gnutar must be Nix-managed (home.packages) and wired into
  # installNativeTools' own curated PATH export, not just assumed present.
  local system names data
  for system in x86_64-linux aarch64-linux; do
    names=$(cd "$ROOT" && nix eval --json ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.packages" \
      --apply 'pkgs: map (p: p.pname or p.name) pkgs' 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" home.packages failed to evaluate"
    assert_contains "$names" "\"gnutar\"" \
      "homeConfigurations.\"${FLAKE_USER}@${system}\" is missing gnutar - codex's installer requires tar, and a minimal base image may not have one"

    data=$(cd "$ROOT" && nix eval --raw ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.activation.installNativeTools.data" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools activation script failed to evaluate"
    assert_contains "$data" "gnutar" \
      "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools does not put gnutar on its curated PATH export"
  done
  pass "gnutar is Nix-managed and wired into installNativeTools' PATH for both Linux homeConfigurations outputs"
}

test_linux_native_install_fault_isolation() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Linux fault-isolation check"
    return 0
  fi
  # Activation scripts run under set -e: without per-tool isolation, one
  # tool's install failing aborts every later tool in the same
  # concatMapStrings loop before it's ever attempted (this is exactly how
  # codex's real "tar is required" failure also took down herdr, ordered
  # right after it - see AGENTS.md). Replace each tool's real network
  # install command with a deterministic local stand-in (no network needed):
  # codex is forced to fail, the other four are forced to succeed. A correct
  # activation script still installs all four survivors and reports the
  # codex failure loudly instead of aborting silently.
  local system data patched tmp_home out exit_code bin
  for system in x86_64-linux aarch64-linux; do
    data=$(cd "$ROOT" && nix eval --raw ".#homeConfigurations.\"${FLAKE_USER}@${system}\".config.home.activation.installNativeTools.data" 2>/dev/null) \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools activation script failed to evaluate"

    patched=$(printf '%s\n' "$data" \
      | sed -E 's#.*curl -fsSL https://claude\.ai/install\.sh.*#mkdir -p "$HOME/.local/bin" \&\& touch "$HOME/.local/bin/claude" \&\& chmod +x "$HOME/.local/bin/claude"#' \
      | sed -E 's#.*curl -fsSL https://chatgpt\.com/codex/install\.sh.*#false#' \
      | sed -E 's#.*curl -fsSL https://herdr\.dev/install\.sh.*#mkdir -p "$HOME/.local/bin" \&\& touch "$HOME/.local/bin/herdr" \&\& chmod +x "$HOME/.local/bin/herdr"#' \
      | sed -E 's#.*npm install -g skills.*#mkdir -p "$HOME/.local/bin" \&\& touch "$HOME/.local/bin/skills" \&\& chmod +x "$HOME/.local/bin/skills"#' \
      | sed -E 's#.*curl -fsSL https://pi\.dev/install\.sh.*#mkdir -p "$HOME/.local/bin" \&\& touch "$HOME/.local/bin/pi" \&\& chmod +x "$HOME/.local/bin/pi"#')

    tmp_home=$(dotfiles_test_tmproot "dotfiles-fault-isolation-$system")
    out=$(HOME="$tmp_home" bash -eu -o pipefail -c "$patched" 2>&1)
    exit_code=$?
    [ "$exit_code" -eq 0 ] \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools must not hard-fail the whole activation when one tool's install fails (exit $exit_code), got: $out"

    assert_contains "$out" "WARNING: native install of codex failed" \
      "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools must report a failed tool loudly, got: $out"

    [ ! -e "$tmp_home/.local/bin/codex" ] \
      || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" fault-isolation test fixture is broken: codex's forced failure still produced a binary"

    for bin in claude herdr skills pi; do
      [ -x "$tmp_home/.local/bin/$bin" ] \
        || fail "homeConfigurations.\"${FLAKE_USER}@${system}\" installNativeTools must still install $bin when codex's install fails, got: $out"
    done
  done
  pass "installNativeTools isolates each tool's install failure for both Linux homeConfigurations outputs - one broken installer no longer blocks the rest"
}

test_darwin_native_install_absent() {
  if ! command -v nix >/dev/null 2>&1; then
    echo "skip: nix not found for Darwin native-install absence check"
    return 0
  fi
  local names
  names=$(cd "$ROOT" && nix eval --json '.#darwinConfigurations.mac.config.home-manager.users.thomasharper.home.activation' --apply 'a: builtins.attrNames a' 2>/dev/null) \
    || fail "darwinConfigurations.mac home.activation failed to evaluate"
  assert_not_contains "$names" "installNativeTools" \
    "darwinConfigurations.mac must not get the Linux-only native installer activation script - herdr is Homebrew-managed on macOS"
  pass "darwinConfigurations.mac has no installNativeTools activation script (herdr stays Homebrew-managed on macOS)"
}

test_darwin_drvpath_unchanged
test_linux_home_configurations_evaluate
test_linux_home_manager_cli_enabled
test_linux_treesitter_buildtools_present
test_linux_nodejs_present_for_npm_backed_native_tools
test_linux_native_install_tools_wired
test_linux_gnutar_present_for_native_installers
test_linux_native_install_fault_isolation
test_darwin_native_install_absent
