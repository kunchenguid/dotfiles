#!/usr/bin/env bash
# Survey existing names near a path so new names can match local structure.
# Usage:
#   survey-names.sh [path]
#   survey-names.sh --siblings [parent-dir]
# Prints patterns only - never file contents of secrets.
set -euo pipefail

MODE="tree"
TARGET="${1:-.}"
if [[ "${1:-}" == "--siblings" ]]; then
  MODE="siblings"
  TARGET="${2:-.}"
fi

ROOT="$(cd "$TARGET" && pwd -P)"

survey_tree() {
  local root="$1"
  cd "$root"
  echo "survey_root: $root"
  echo "survey_mode: tree"

  if command -v git >/dev/null 2>&1 && git -C "$root" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "git_root: $(git -C "$root" rev-parse --show-toplevel)"
    echo "remote: $(git -C "$root" remote get-url origin 2>/dev/null || echo none)"
  fi

  echo "--- top-level entries ---"
  ls -1 | head -60

  echo "--- directories (depth 2) ---"
  find . -maxdepth 2 -type d \
    -not -path './.git*' \
    -not -path './node_modules*' \
    -not -path './.next*' \
    -not -path './dist*' \
    -not -path './build*' \
    -not -path './target*' \
    2>/dev/null | head -80 | sed 's|^\./||'

  echo "--- file basenames sample ---"
  find . -maxdepth 3 -type f \
    -not -path './.git/*' \
    -not -path './node_modules/*' \
    -not -path './.next/*' \
    2>/dev/null | sed 's|^\./||' | head -100

  echo "--- system/config filenames present ---"
  for f in \
    README.md AGENTS.md CLAUDE.md CODEX.md LICENSE SECURITY.md \
    package.json Cargo.toml pyproject.toml go.mod Makefile Justfile Taskfile.yml \
    docker-compose.yml docker-compose.prod.yml compose.yaml \
    flake.nix home.nix configuration.nix \
    .env.example .env.sample .gitignore .gitattributes
  do
    [[ -e "$f" ]] && echo "  $f"
  done
  if [[ -d .github/workflows ]]; then
    echo "  workflows:"
    ls -1 .github/workflows 2>/dev/null | head -30 | sed 's/^/    /'
  fi

  echo "--- case heuristics (cwd files/dirs) ---"
  python3 - <<'PY'
from pathlib import Path
import re
from collections import Counter
files=[p.name for p in Path('.').iterdir() if p.is_file() and not p.name.startswith('.')]
dirs=[p.name for p in Path('.').iterdir() if p.is_dir() and not p.name.startswith('.')]

def classify(names):
  kebab=sum(1 for n in names if re.fullmatch(r'[a-z0-9]+(-[a-z0-9]+)+', n.split('.')[0] or ''))
  snake=sum(1 for n in names if re.fullmatch(r'[a-z0-9]+(_[a-z0-9]+)+', n.split('.')[0] or ''))
  pascal=sum(1 for n in names if re.fullmatch(r'[A-Z][A-Za-z0-9]+', n.split('.')[0] or ''))
  camel=sum(1 for n in names if re.fullmatch(r'[a-z][A-Za-z0-9]+', n.split('.')[0] or '') and any(c.isupper() for c in n))
  return dict(kebab=kebab, snake=snake, pascal=pascal, camel=camel, total=len(names))

print('files:', classify(files))
print('dirs:', classify(dirs))
ext=Counter(Path(n).suffix for n in files if Path(n).suffix)
print('extensions:', dict(ext.most_common(12)))
PY

  if [[ -f package.json ]]; then
    echo "--- package.json name/scripts ---"
    python3 - <<'PY'
import json
from pathlib import Path
d=json.loads(Path('package.json').read_text())
print('name:', d.get('name'))
print('scripts:', ', '.join(sorted((d.get('scripts') or {}).keys())[:40]))
PY
  fi

  if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "--- recent branch names ---"
    git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads 2>/dev/null | head -20
  fi

  for f in .env.example .env.sample; do
    if [[ -f "$f" ]]; then
      echo "--- env keys from $f (names only) ---"
      python3 - "$f" <<'PY'
import re,sys
from pathlib import Path
for line in Path(sys.argv[1]).read_text().splitlines():
  m=re.match(r'\s*([A-Za-z_][A-Za-z0-9_]*)\s*=', line)
  if m: print(m.group(1))
PY
    fi
  done

  if [[ -f "${HOME}/.config/automic-vault/project-key-index.tsv" ]]; then
    echo "--- automic vault key prefixes (sample) ---"
    awk -F'\t' 'NR>1 {print $4}' "${HOME}/.config/automic-vault/project-key-index.tsv" | head -30
  fi
}

survey_siblings() {
  local parent="$1"
  cd "$parent"
  echo "survey_root: $parent"
  echo "survey_mode: siblings"
  echo "--- sibling project/folder names ---"
  ls -1 | head -80
  echo "--- sibling case heuristics ---"
  python3 - <<'PY'
from pathlib import Path
import re
names=[p.name for p in Path('.').iterdir() if not p.name.startswith('.')]

def classify(names):
  kebab=sum(1 for n in names if re.fullmatch(r'[a-z0-9]+(-[a-z0-9]+)+', n))
  snake=sum(1 for n in names if re.fullmatch(r'[a-z0-9]+(_[a-z0-9]+)+', n))
  pascal=sum(1 for n in names if re.fullmatch(r'[A-Z][A-Za-z0-9]+', n))
  spaced=sum(1 for n in names if ' ' in n)
  return dict(kebab=kebab, snake=snake, pascal=pascal, spaced=spaced, total=len(names))

print(classify(names))
print('examples_kebab:', [n for n in names if re.fullmatch(r'[a-z0-9]+(-[a-z0-9]+)+', n)][:12])
print('examples_other:', [n for n in names if not re.fullmatch(r'[a-z0-9]+(-[a-z0-9]+)+', n)][:12])
PY
}

if [[ "$MODE" == "siblings" ]]; then
  survey_siblings "$ROOT"
else
  survey_tree "$ROOT"
fi

echo "--- done ---"
echo "Match dominant case/separator from heuristics + sibling names above."
echo "For new projects, also run: $0 --siblings <parent-dir>"
