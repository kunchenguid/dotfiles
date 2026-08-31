# Resolving upstream from what you were using

## Agent skill directory

1. Read `SKILL.md` frontmatter (`author`, `metadata`, URLs).
2. Check parent vendor tree README (`home/cyber-skills`, synced kunchenguid skills, etc.).
3. If the skill path is a symlink, `readlink` to the real directory and look for `.git` or a sync script comment.
4. Search GitHub: `gh search repos "SKILL_NAME" --owner possible-owner` or web search for the skill name + "SKILL.md".

## npm package (AXI CLIs, etc.)

```bash
npm view PACKAGE repository.url
npm view PACKAGE homepage
```

## Homebrew / binaries

```bash
brew info FORMULA   # look for homepage / head URL
which BINARY && strings "$(which BINARY)" | rg -i 'github.com' | head
```

## Already-vendored kunchenguid checkouts

Preferred contrib roots (when present):

| Project | Typical upstream |
|---------|------------------|
| axi | kunchenguid/axi |
| gh-axi | kunchenguid/gh-axi |
| lavish-axi | kunchenguid/lavish-axi |
| no-mistakes | kunchenguid/no-mistakes |
| firstmate | kunchenguid/firstmate |

Still re-read that repo's CONTRIBUTING each time; do not assume one style for all.

## Ambiguity

If two remotes could own the code (mirror vs canonical), prefer the repo CONTRIBUTING points at, or the npm `repository` field, and confirm with the user before forking.
