#!/usr/bin/env bash
# Fixture tests for inspect-repo.sh + check-readme.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
CHECK="$ROOT/scripts/check-readme.sh"
INSPECT="$ROOT/scripts/inspect-repo.sh"
FIX="$ROOT/tests/fixtures"
pass=0
fail=0

assert_ok() {
  local name="$1"; shift
  if "$@"; then
    echo "PASS: $name"
    pass=$((pass + 1))
  else
    echo "FAIL: $name" >&2
    fail=$((fail + 1))
  fi
}

assert_fails() {
  local name="$1"; shift
  if "$@" >/dev/null 2>&1; then
    echo "FAIL: $name (expected non-zero)" >&2
    fail=$((fail + 1))
  else
    echo "PASS: $name"
    pass=$((pass + 1))
  fi
}

assert_ok "check good library" "$CHECK" "$FIX/good-library/README.md"
assert_fails "check nested fence" "$CHECK" "$FIX/bad-nested-fence/README.md"
assert_fails "check secret pattern" "$CHECK" "$FIX/bad-secret/README.md"
assert_fails "check missing image" "$CHECK" "$FIX/bad-missing-image/README.md"

# em dash should not fail by default
tmp="$(mktemp)"
printf '# t\n\nHello — world\n' > "$tmp"
assert_ok "em dash is preference not error" "$CHECK" "$tmp"
assert_fails "em dash fails under --strict-style" "$CHECK" "$tmp" --strict-style
rm -f "$tmp"

# inspect emits classification hints
out="$("$INSPECT" "$FIX/good-library")"
echo "$out" | grep -q 'manifest: package.json'
echo "$out" | grep -q 'hint_primary_proof'
echo "$out" | grep -q 'suggested_interface_guess'
echo "PASS: inspect library fixture"
pass=$((pass + 1))

out="$("$INSPECT" "$FIX/python-library")"
echo "$out" | grep -q 'manifest: pyproject.toml'
echo "PASS: inspect python fixture"
pass=$((pass + 1))

out="$("$INSPECT" "$FIX/internal-service")"
echo "$out" | grep -q 'hint_interface: Service-possible'
echo "PASS: inspect service fixture"
pass=$((pass + 1))

echo "----"
echo "passed=$pass failed=$fail"
[[ "$fail" -eq 0 ]]
