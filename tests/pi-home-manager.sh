#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

python3 - "$repo_root" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
settings = json.loads((root / "home/.pi/agent/settings.json").read_text())
expected_packages = [
    "npm:@ryan_nookpi/pi-extension-codex-fast-mode@0.2.6",
    "git:github.com/algal/pi-openai-server-compaction@c6d593087709e9481223dc6c6c2269b371b5e055",
]
assert settings.get("packages") == expected_packages, "Pi package declarations must be exactly the two audited pins"

home_nix = (root / "home.nix").read_text()
required_links = {
    '.pi/agent/themes': '${dotfiles}/home/.pi/agent/themes',
    '.pi/agent/extensions': '${dotfiles}/home/.pi/agent/extensions',
    '.pi/agent/models.json': '${dotfiles}/home/.pi/agent/models.json',
    '.pi/agent/settings.json': '${dotfiles}/home/.pi/agent/settings.json',
}
for destination, source in required_links.items():
    declaration = f'home.file."{destination}".source =\n    config.lib.file.mkOutOfStoreSymlink "{source}";'
    assert declaration in home_nix, f"missing exact out-of-store link: {destination}"

for old_child in [
    '.pi/agent/themes/rose-pine-moon.json',
    '.pi/agent/extensions/terminal-status-title.js',
]:
    assert f'home.file."{old_child}"' not in home_nix, f"legacy child link remains: {old_child}"

for forbidden in [
    '.pi/agent', '.pi/agent/auth.json', '.pi/agent/sessions', '.pi/agent/trust.json',
    '.pi/agent/npm', '.pi/agent/git', '.pi/agent/cache',
]:
    assert f'home.file."{forbidden}"' not in home_nix, f"Pi runtime path became managed: {forbidden}"

assert 'entryBefore [ "checkLinkTargets" ]' in home_nix, "migration must run before Home Manager collision checks"
assert 'removeLegacyPiLink "$HOME/.pi/agent/themes/rose-pine-moon.json"' in home_nix
assert 'removeLegacyPiLink "$HOME/.pi/agent/extensions/terminal-status-title.js"' in home_nix
assert (root / "home/.pi/agent/themes/rose-pine-moon.json").is_file()
assert (root / "home/.pi/agent/extensions/terminal-status-title.js").is_file()
assert [p.relative_to(root / "home/.pi/agent/themes").as_posix() for p in (root / "home/.pi/agent/themes").rglob("*") if p.is_file()] == ["rose-pine-moon.json"]
assert [p.relative_to(root / "home/.pi/agent/extensions").as_posix() for p in (root / "home/.pi/agent/extensions").rglob("*") if p.is_file()] == ["terminal-status-title.js"]
PY

# Build only the Home Manager activation package. This never activates the captain's configuration.
activation=$(nix build --no-link --print-out-paths \
  .#darwinConfigurations.mac.config.home-manager.users.kunchen.home.activationPackage)

probe=$(mktemp -d)
trap 'rm -rf "$probe"' EXIT
fake_home="$probe/home"
mkdir -p "$fake_home/.pi/agent/themes" "$fake_home/.pi/agent/extensions"
legacy_tree="$probe/home-manager-files"
mkdir -p "$legacy_tree/.pi/agent/themes" "$legacy_tree/.pi/agent/extensions"
ln -s "$repo_root/home/.pi/agent/themes/rose-pine-moon.json" \
  "$legacy_tree/.pi/agent/themes/rose-pine-moon.json"
ln -s "$repo_root/home/.pi/agent/extensions/terminal-status-title.js" \
  "$legacy_tree/.pi/agent/extensions/terminal-status-title.js"
legacy_home_manager_files=$(nix store add-path "$legacy_tree")
ln -s "$legacy_home_manager_files/.pi/agent/themes/rose-pine-moon.json" \
  "$fake_home/.pi/agent/themes/rose-pine-moon.json"
ln -s "$legacy_home_manager_files/.pi/agent/extensions/terminal-status-title.js" \
  "$fake_home/.pi/agent/extensions/terminal-status-title.js"

test "$(readlink -f "$fake_home/.pi/agent/themes/rose-pine-moon.json")" = \
  "$repo_root/home/.pi/agent/themes/rose-pine-moon.json"

# Execute only the generated pre-check migration block against a disposable HOME.
awk '
  /_iNote "Activating %s" "migratePiAuthoredDirectories"/ { enabled = 1; next }
  /_iNote "Activating %s" "checkLinkTargets"/ { exit }
  enabled { print }
' "$activation/activate" | \
  sed "s|/Users/kunchen/.dotfiles|$repo_root|g" > "$probe/migrate.sh"
HOME="$fake_home" DRY_RUN_CMD='' bash -e "$probe/migrate.sh"

test ! -e "$fake_home/.pi/agent/themes"
test ! -e "$fake_home/.pi/agent/extensions"
ln -s "$repo_root/home/.pi/agent/themes" "$fake_home/.pi/agent/themes"
ln -s "$repo_root/home/.pi/agent/extensions" "$fake_home/.pi/agent/extensions"
test -L "$fake_home/.pi/agent/themes"
test -L "$fake_home/.pi/agent/extensions"

# Safe skip paths must succeed and leave unrelated user state untouched.
mkdir -p "$probe/unmanaged/.pi/agent/themes" "$probe/unmanaged/.pi/agent/extensions"
touch "$probe/unmanaged/.pi/agent/themes/user-theme.json"
ln -s "$repo_root/home/.pi/agent/extensions/terminal-status-title.js" \
  "$probe/unmanaged/.pi/agent/extensions/user-extension.js"
HOME="$probe/unmanaged" DRY_RUN_CMD='' bash -e "$probe/migrate.sh"
test -f "$probe/unmanaged/.pi/agent/themes/user-theme.json"
test -L "$probe/unmanaged/.pi/agent/extensions/user-extension.js"

echo "Pi package declarations, runtime boundary, link shape, and child-to-parent migration passed."
