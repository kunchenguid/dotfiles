#!/usr/bin/env bash
# Print paths of contribution-related docs in a checkout.
set -euo pipefail

ROOT="${1:-.}"
if [[ ! -d "$ROOT" ]]; then
  echo "Not a directory: $ROOT" >&2
  exit 1
fi

candidates=(
  CONTRIBUTING.md
  CONTRIBUTING.rst
  CONTRIBUTING.txt
  CONTRIBUTING
  .github/CONTRIBUTING.md
  docs/CONTRIBUTING.md
  docs/contributing.md
  Documentation/Contributing.md
  CODE_OF_CONDUCT.md
  .github/CODE_OF_CONDUCT.md
  .github/PULL_REQUEST_TEMPLATE.md
  .github/pull_request_template.md
  .github/ISSUE_TEMPLATE
  CODEOWNERS
  .github/CODEOWNERS
  DEVELOPMENT.md
  docs/development.md
  README.md
)

found=0
tmp_seen="$(mktemp)"
trap 'rm -f "$tmp_seen"' EXIT

emit() {
  local rel="$1"
  if grep -Fxq -- "$rel" "$tmp_seen" 2>/dev/null; then
    return
  fi
  printf '%s\n' "$rel" >> "$tmp_seen"
  echo "  ${rel}"
  found=1
}

for rel in "${candidates[@]}"; do
  if [[ -e "${ROOT}/${rel}" ]]; then
    emit "$rel"
  fi
done

while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  rel="${f#"${ROOT}/"}"
  emit "$rel"
done < <(
  find "$ROOT" \( -path "$ROOT/.git" -o -path "$ROOT/node_modules" -o -path "$ROOT/target" -o -path "$ROOT/dist" \) -prune -o \
    -type f \( -iname '*contribut*' -o -iname 'pull_request_template*' \) -print 2>/dev/null | head -n 40
)

if [[ "$found" -eq 0 ]]; then
  exit 1
fi
