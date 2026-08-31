#!/usr/bin/env bash
# Fork (if needed), clone with upstream/origin remotes, optionally create a branch,
# and stub a contribution brief for agent reproduction/testing.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: prepare-contribution.sh OWNER/REPO [--slug SLUG] [--type fix|feat|docs] [--root DIR]

Defaults:
  --root  $OSS_CONTRIB_ROOT or ~/src/oss
  --type  fix
  --slug  derived from repo name + date if omitted

Requires: gh, git. Authenticates via existing gh session.
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

REPO_SPEC="$1"
shift
SLUG=""
TYPE="fix"
ROOT="${OSS_CONTRIB_ROOT:-$HOME/src/oss}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug) SLUG="$2"; shift 2 ;;
    --type) TYPE="$2"; shift 2 ;;
    --root) ROOT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 1 ;;
  esac
done

if [[ ! "$REPO_SPEC" =~ ^[^/]+/[^/]+$ ]]; then
  echo "REPO must be owner/name" >&2
  exit 1
fi

OWNER="${REPO_SPEC%%/*}"
NAME="${REPO_SPEC##*/}"
SLUG="${SLUG:-${NAME}-$(date +%Y%m%d)}"
BRANCH="${TYPE}/${SLUG}"
DEST="${ROOT}/${OWNER}/${NAME}"

mkdir -p "${ROOT}/${OWNER}"

if ! command -v gh >/dev/null 2>&1; then
  echo "gh is required (GitHub CLI)" >&2
  exit 1
fi

USER_LOGIN="$(gh api user --jq .login)"
FORK_SPEC="${USER_LOGIN}/${NAME}"

echo "==> Ensuring fork of ${REPO_SPEC} -> ${FORK_SPEC}"
if ! gh repo view "$FORK_SPEC" >/dev/null 2>&1; then
  gh repo fork "$REPO_SPEC" --remote=false --clone=false
fi

if ! gh repo view "$FORK_SPEC" >/dev/null 2>&1; then
  echo "Fork ${FORK_SPEC} not found after gh repo fork; check gh auth." >&2
  exit 1
fi

DEFAULT_BRANCH="$(gh repo view "$REPO_SPEC" --json defaultBranchRef --jq .defaultBranchRef.name)"

if [[ -d "${DEST}/.git" ]]; then
  echo "==> Reusing clone at ${DEST}"
  git -C "$DEST" remote get-url upstream >/dev/null 2>&1 || \
    git -C "$DEST" remote add upstream "https://github.com/${REPO_SPEC}.git"
  git -C "$DEST" remote set-url origin "https://github.com/${FORK_SPEC}.git" 2>/dev/null || \
    git -C "$DEST" remote add origin "https://github.com/${FORK_SPEC}.git"
  git -C "$DEST" fetch upstream --prune
  git -C "$DEST" fetch origin --prune
else
  echo "==> Cloning fork ${FORK_SPEC} -> ${DEST}"
  gh repo clone "$FORK_SPEC" "$DEST"
  git -C "$DEST" remote add upstream "https://github.com/${REPO_SPEC}.git" 2>/dev/null || \
    git -C "$DEST" remote set-url upstream "https://github.com/${REPO_SPEC}.git"
  git -C "$DEST" fetch upstream --prune
fi

# Create branch from upstream default if it does not exist locally
if git -C "$DEST" rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
  echo "==> Branch ${BRANCH} already exists"
  git -C "$DEST" checkout "$BRANCH"
else
  echo "==> Creating ${BRANCH} from upstream/${DEFAULT_BRANCH}"
  git -C "$DEST" checkout -B "$BRANCH" "upstream/${DEFAULT_BRANCH}"
fi

BRIEF="${DEST}/.contribution-brief.md"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="${SCRIPT_DIR}/../references/brief-template.md"

if [[ ! -f "$BRIEF" ]]; then
  {
    echo "<!-- Auto-stub from prepare-contribution.sh; fill before implementing -->"
    echo
    echo "# Contribution brief: ${REPO_SPEC}"
    echo
    echo "- **Upstream:** https://github.com/${REPO_SPEC}"
    echo "- **Fork:** https://github.com/${FORK_SPEC}"
    echo "- **Local clone:** \`${DEST}\`"
    echo "- **Default branch:** \`${DEFAULT_BRANCH}\`"
    echo "- **Working branch:** \`${BRANCH}\`"
    echo "- **Related issue:** _(search first; link or write \"none yet\")_"
    echo
    if [[ -f "$TEMPLATE" ]]; then
      # Skip the title line of the template if present
      sed '1,2d' "$TEMPLATE" 2>/dev/null || cat "$TEMPLATE"
    fi
  } > "$BRIEF"
  echo "==> Wrote brief stub: ${BRIEF}"
else
  echo "==> Brief already exists: ${BRIEF}"
fi

CONTRIB_PATHS="$("$SCRIPT_DIR/find-contributing.sh" "$DEST" || true)"

cat <<EOF

======== Contribution workspace ready ========
Upstream:   https://github.com/${REPO_SPEC}
Fork:       https://github.com/${FORK_SPEC}
Clone:      ${DEST}
Branch:     ${BRANCH}
Brief:      ${BRIEF}
Default:    ${DEFAULT_BRANCH}

Contributing / guideline files:
${CONTRIB_PATHS:-  (none found - use README + repo conventions)}

Next:
  1. Search issues/PRs for duplicates (gh issue list -R ${REPO_SPEC} --search "...")
  2. Fill ${BRIEF} (reproduction + expected/actual + test plan)
  3. Open or link an issue, then implement on ${BRANCH}
  4. Push to origin and gh pr create --repo ${REPO_SPEC}
==============================================
EOF
