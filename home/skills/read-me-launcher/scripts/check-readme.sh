#!/usr/bin/env bash
# Validate a README for GitHub render safety, missing assets, and secret leaks.
# Usage: check-readme.sh [README.md] [--strict-style]
#
# Exit codes:
#   0  OK (warnings allowed)
#   1  ERROR findings
#   2  usage / missing file
set -euo pipefail

STRICT_STYLE=0
README="${1:-README.md}"
if [[ "${1:-}" == "--strict-style" ]]; then
  STRICT_STYLE=1
  README="${2:-README.md}"
elif [[ "${2:-}" == "--strict-style" ]]; then
  STRICT_STYLE=1
fi

ROOT="$(cd "$(dirname "$README")" && pwd -P)"
FILE="$ROOT/$(basename "$README")"
[[ -f "$FILE" ]] || { echo "missing: $FILE" >&2; exit 2; }

export CHECK_README_FILE="$FILE"
export CHECK_README_ROOT="$ROOT"
export CHECK_README_STRICT_STYLE="$STRICT_STYLE"

set +e
python3 <<'PY'
import os
import pathlib
import re
import sys
import urllib.request

file_path = pathlib.Path(os.environ["CHECK_README_FILE"])
root = pathlib.Path(os.environ["CHECK_README_ROOT"])
strict_style = os.environ.get("CHECK_README_STRICT_STYLE") == "1"
text = file_path.read_text(encoding="utf-8", errors="replace")

errors: list[str] = []
warnings: list[str] = []
prefs: list[str] = []


def err(msg: str) -> None:
    errors.append(msg)


def warn(msg: str) -> None:
    warnings.append(msg)


def pref(msg: str) -> None:
    prefs.append(msg)


# --- ERROR: nested fences inside real HTML containers ---
# Only treat tags followed by a newline as block wrappers (avoids `<div>` in prose/tables).
for tag in ("div", "section", "center"):
    for m in re.finditer(
        rf"<{tag}\b[^>]*>\s*\n[\s\S]*?</{tag}>",
        text,
        flags=re.I,
    ):
        if "```" in m.group(0):
            err(f"nested code fence inside <{tag}> (breaks GitHub render) at char {m.start()}")

# --- ERROR: placeholder / broken image markup ---
img_srcs: list[str] = []
for m in re.finditer(
    r"!\[[^\]]*\]\(([^)]+)\)|<img[^>]+src=[\"']([^\"']+)[\"']",
    text,
    flags=re.I,
):
    src = (m.group(1) or m.group(2) or "").strip()
    img_srcs.append(src)
    if not src or src.lower() in {"todo.png", "todo.jpg", "image.png", "#"}:
        err(f"placeholder image src: {src!r}")
    if " " in src and not src.startswith("data:"):
        err(f"image src contains spaces (often breaks): {src!r}")

# --- WARN: div without blank line after open ---
for m in re.finditer(r"<div\b[^>]*>\n(?!\n)", text):
    warn(f"<div> should be followed by a blank line before Markdown (char {m.start()})")

# --- PREF / optional ERROR: em dash style ---
if "\u2014" in text or re.search(r"\bem dash\b", text, flags=re.I):
    msg = "contains em dash (style preference; use hyphen or rephrase)"
    if strict_style:
        err(msg)
    else:
        pref(msg)

# --- WARN: local SVG without raster companion ---
local_svg = [
    u
    for u in img_srcs
    if u.lower().endswith(".svg") and not u.startswith(("http://", "https://", "data:"))
]
local_raster = [
    u
    for u in img_srcs
    if u.lower().endswith((".png", ".jpg", ".jpeg", ".webp"))
    and not u.startswith(("http://", "https://", "data:"))
]
if local_svg and not local_raster:
    warn(
        "README uses local SVG images but no PNG/JPEG/WebP; "
        "GitHub camo often blanks CSS-based SVGs"
    )

# --- ERROR: missing local images ---
for src in img_srcs:
    if not src or src.startswith(("http://", "https://", "data:")):
        continue
    clean = src.split("#", 1)[0]
    if not (root / clean).is_file():
        err(f"local image missing: {clean}")

# --- ERROR: secret / credential patterns (deny-list enforcement) ---
fake_markers = (
    "example",
    "sample",
    "dummy",
    "fake",
    "placeholder",
    "your-",
    "xxx",
    "redacted",
    "<",
    "changeme",
    "not-a-real",
    "sk-example",
)


def looks_fake(s: str) -> bool:
    low = s.lower()
    return any(m in low for m in fake_markers)


secret_patterns = [
    ("GitHub PAT", re.compile(r"\bgh[pousr]_[A-Za-z0-9_]{20,}\b")),
    ("AWS access key id", re.compile(r"\bAKIA[0-9A-Z]{16}\b")),
    ("OpenAI-like key", re.compile(r"\bsk-[A-Za-z0-9]{20,}\b")),
    ("Stripe live key", re.compile(r"\bsk_live_[A-Za-z0-9]{16,}\b")),
    ("Slack token", re.compile(r"\bxox[baprs]-[A-Za-z0-9-]{10,}\b")),
    ("Bearer token", re.compile(r"\bBearer\s+[A-Za-z0-9._\-+/=]{20,}\b")),
    (
        "DB URL with password",
        re.compile(r"\b(?:postgres|postgresql|mysql|mongodb)://[^:\s]+:[^@\s]+@"),
    ),
    (
        "PEM private key block",
        re.compile(r"-----BEGIN (?:RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----"),
    ),
]

for label, pat in secret_patterns:
    for m in pat.finditer(text):
        snippet = m.group(0)
        if looks_fake(snippet):
            continue
        # Truncate for safe logging
        shown = snippet[:24] + ("…" if len(snippet) > 24 else "")
        err(f"possible secret ({label}): {shown}")

# --- WARN: external image HEAD checks (best effort) ---
for src in img_srcs:
    if not src.startswith(("http://", "https://")):
        continue
    try:
        req = urllib.request.Request(src, method="HEAD")
        with urllib.request.urlopen(req, timeout=8) as resp:
            code = getattr(resp, "status", 200)
        if code not in (200, 301, 302):
            warn(f"external image HTTP {code}: {src}")
    except Exception as exc:  # noqa: BLE001 - lint should not crash
        warn(f"external image fetch failed ({exc.__class__.__name__}): {src}")

for e in errors:
    print(f"ERROR: {e}", file=sys.stderr)
for w in warnings:
    print(f"WARN: {w}", file=sys.stderr)
for p in prefs:
    print(f"PREF: {p}", file=sys.stderr)

if errors:
    print(f"check-readme: FAILED ({len(errors)} error(s), {len(warnings)} warning(s))", file=sys.stderr)
    sys.exit(1)

print(
    f"check-readme: OK ({len(warnings)} warning(s), {len(prefs)} preference(s))",
    file=sys.stderr,
)
sys.exit(0)
PY
status=$?
set -e
exit "$status"
