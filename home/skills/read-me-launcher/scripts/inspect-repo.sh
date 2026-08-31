#!/usr/bin/env bash
# Gather README-relevant repo facts. Never prints secret file contents.
# Usage: inspect-repo.sh [repo-root]
set -euo pipefail

ROOT="$(cd "${1:-.}" && pwd -P)"
cd "$ROOT"

exists() { [[ -e "$1" ]]; }
first_file() {
  local f
  for f in "$@"; do
    if [[ -f "$f" ]]; then
      printf '%s' "$f"
      return 0
    fi
  done
  return 1
}

echo "root: $ROOT"

# Visibility
visibility="unknown"
remote_url=""
if command -v gh >/dev/null 2>&1; then
  if meta="$(gh repo view --json isPrivate,visibility,url,nameWithOwner,description 2>/dev/null)"; then
    visibility="$(printf '%s' "$meta" | python3 -c 'import sys,json; d=json.load(sys.stdin); print("private" if d.get("isPrivate") else (d.get("visibility") or "public").lower())' 2>/dev/null || echo unknown)"
    remote_url="$(printf '%s' "$meta" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("url") or "")' 2>/dev/null || true)"
    desc="$(printf '%s' "$meta" | python3 -c 'import sys,json; d=json.load(sys.stdin); print((d.get("description") or "").replace("\n"," "))' 2>/dev/null || true)"
    name="$(printf '%s' "$meta" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("nameWithOwner") or "")' 2>/dev/null || true)"
    echo "github: $name"
    echo "visibility: $visibility"
    [[ -n "$remote_url" ]] && echo "url: $remote_url"
    [[ -n "$desc" ]] && echo "description: $desc"
  fi
fi
if [[ "$visibility" == "unknown" ]] && command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  remote_url="$(git remote get-url origin 2>/dev/null || true)"
  [[ -n "$remote_url" ]] && echo "origin: $remote_url"
  echo "visibility: unknown"
fi

echo "--- stack signals ---"
for f in package.json pnpm-workspace.yaml yarn.lock bun.lock Cargo.toml go.mod \
  pyproject.toml requirements.txt Gemfile composer.json flake.nix \
  docker-compose.yml docker-compose.yaml Dockerfile Makefile justfile; do
  if exists "$f"; then
    echo "manifest: $f"
  fi
done
# GameMaker
shopt -s nullglob
for f in *.yyp; do
  echo "manifest: $f (GameMaker)"
done
shopt -u nullglob

if exists package.json; then
  python3 - <<'PY'
import json
from pathlib import Path
p=Path('package.json')
d=json.loads(p.read_text())
print('name:', d.get('name') or '')
print('pkg_description:', (d.get('description') or '').replace('\n',' '))
scripts=d.get('scripts') or {}
if scripts:
  print('npm_scripts:', ', '.join(sorted(scripts)[:30]))
deps=sorted((d.get('dependencies') or {}).keys())
dev=sorted((d.get('devDependencies') or {}).keys())
if deps: print('dependencies_sample:', ', '.join(deps[:20]))
if dev: print('devDependencies_sample:', ', '.join(dev[:20]))
engines=d.get('engines') or {}
if engines: print('engines:', engines)
PY
fi

if exists Cargo.toml; then
  rg -n '^(name|version|description)\s*=' Cargo.toml | head -10 || true
fi
if exists go.mod; then
  head -5 go.mod
fi
if exists pyproject.toml; then
  rg -n '^(name|version|description)\s*=' pyproject.toml | head -10 || true
fi

echo "--- docs / meta ---"
for f in README.md LICENSE LICENSE.md AGENTS.md CONTRIBUTING.md CHANGELOG.md \
  .env.example .env.sample docker-compose.yml; do
  exists "$f" && echo "present: $f"
done

# Flag sensitive files by name only (do not read)
echo "--- sensitive paths (names only; do not read into README) ---"
for f in .env .env.local .env.production ai-keys.env credentials.json \
  auth.json id_rsa id_ed25519; do
  if exists "$f" || exists ".$f"; then
    echo "sensitive: $f (exists - never paste contents)"
  fi
done
# common nested
if find . -maxdepth 3 \( -name '.env' -o -name '.env.local' -o -name 'credentials.json' \) \
  -not -path './node_modules/*' -not -path './.git/*' 2>/dev/null | head -20 | grep -q .; then
  find . -maxdepth 3 \( -name '.env' -o -name '.env.local' -o -name 'credentials.json' \) \
    -not -path './node_modules/*' -not -path './.git/*' 2>/dev/null | head -20 \
    | while read -r p; do echo "sensitive: $p"; done
fi

echo "--- top-level ---"
ls -1 | head -40

echo "--- classification hints ---"
# Heuristic suggestions for taxonomy.md (agent must confirm)
iface="unknown"
if [[ -f package.json ]]; then
  ui_guess="$(python3 - <<'PY'
import json
from pathlib import Path
d=json.loads(Path('package.json').read_text())
deps=set((d.get('dependencies') or {}))|set((d.get('devDependencies') or {}))
ui=bool(deps & {'react','vue','svelte','next','@remix-run/react','react-dom'})
print('GUI-or-web' if ui else 'Library-or-Node-tool')
PY
)"
  iface="$ui_guess"
fi
[[ -f Cargo.toml || -f go.mod || -f pyproject.toml ]] && echo "hint_interface: packaged-library-possible"
[[ -f Dockerfile || -f docker-compose.yml || -f docker-compose.yaml ]] && echo "hint_interface: Service-possible"
[[ -d skills || -f SKILL.md ]] && echo "hint_interface: Agent-skill-possible"
if [[ "$visibility" == "private" ]]; then
  echo "hint_audience: internal-or-private"
else
  echo "hint_audience: public-developer"
fi
echo "hint_primary_proof: choose from visual|code|behavioral|performance|architectural|operational"
echo "suggested_interface_guess: $iface"

echo "--- done ---"
echo "Classify with references/taxonomy.md. Never invent scripts/deps not listed above."
echo "Use visibility=$visibility when choosing public vs private README mode."
