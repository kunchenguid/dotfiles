# Claude Code skills (vendored)

These skills are vendored from [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills)
so they live in this repo and deploy declaratively via home-manager.

`home.nix` symlinks `~/.claude/skills` -> `home/.claude/skills` with an out-of-store
symlink, so Claude Code picks these up as user-scoped skills.

## Installed

| Skill | Purpose |
|-------|---------|
| `writing-guidelines` | Review docs/prose against a writing style handbook |
| `web-design-guidelines` | Review UI code for accessibility / UX / Web Interface Guidelines |
| `react-best-practices` | React/Next.js performance patterns from Vercel Engineering |
| `deploy-to-vercel` | Deploy apps/websites to Vercel |
| `vercel-cli-with-tokens` | Vercel CLI with token-based auth |
| `vercel-optimize` | Investigate and optimize Vercel projects |

## Provenance

- Source: `github.com/vercel-labs/agent-skills`, `skills/<name>/`
- Vendored at commit `f8a72b9603728bb92a217a879b7e62e43ad76c81`

## Updating

The upstream `skills` CLI (`npx skills`) installs directly into `~/.claude/skills`,
which would not be tracked here. To keep things declarative, re-vendor instead:

```sh
git clone --depth 1 https://github.com/vercel-labs/agent-skills.git /tmp/agent-skills
for s in writing-guidelines web-design-guidelines react-best-practices \
         deploy-to-vercel vercel-cli-with-tokens vercel-optimize; do
  rm -rf "home/.claude/skills/$s"
  cp -R "/tmp/agent-skills/skills/$s" "home/.claude/skills/$s"
done
# then update the commit hash above and: ./rebuild.sh
```
