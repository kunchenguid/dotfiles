---
name: consistent-naming
description: >-
  Decide names for projects, packages, source files, system/config files,
  directories, branches, env vars, skills, components, and CLI flags by surveying
  the target path and matching that tree's existing structure (including sibling
  repos on the local drive). Use whenever creating, renaming, scaffolding, or
  suggesting a name for anything; when names feel random or inconsistent; or
  when the user asks what to call a file, folder, or project. Prefer this skill
  before inventing any new name.
license: MIT
---

# Consistent naming

Stop random names. Every new name must look like it already belonged in the
**target** tree - files included.

## Hard rule

Before proposing or writing any new name:

1. Pick the **naming scope** ([references/scope.md](references/scope.md)):
   siblings → package → git root → sibling projects on disk → house defaults.
2. Run `scripts/survey-names.sh` on that scope (and `--siblings` for new projects).
3. Read [references/rules.md](references/rules.md) for the name kind.
4. Propose **one primary name** plus at most **two alternates**, each justified
   by concrete examples from the survey.
5. If patterns conflict, prefer the **local neighborhood**, then one sentence
   explaining why.

Do not ship cute, meme, or one-off names that ignore neighbors. Do not reuse
repo A's style inside repo B without surveying B.

## Workflow

1. **Classify** the name kind ([references/kinds.md](references/kinds.md)):
   project, package, directory, **file**, **system/config file**, component,
   test, env, branch, skill, cli, api/route.

2. **Survey** the owning path (not a random workspace root):
   ```bash
   scripts/survey-names.sh [path]
   # new project / product stem also:
   scripts/survey-names.sh --siblings [parent-of-projects]
   ```

3. **Match case and separators** for that kind in that folder
   (kebab dirs, PascalCase components, SCREAMING_SNAKE env, fixed tool filenames).

4. **Match vocabulary** already in that tree. Reuse stems; avoid synonym forks
   (`auth/` next to `authentication/`).

5. **Check collisions** against the survey, sibling repos, and PATH/package names.
   No `2`, `final`, `new`, `copy` suffixes.

6. **Output**:
   ```
   Primary: <name>
   Scope: <path surveyed>
   Pattern: <rule + 1-2 real examples>
   Rejected: <alternatives and why>
   ```

## Files and system files

- Ordinary source files: match sibling basename style + extension exactly.
- System/config/tooling files: prefer idiomatic fixed names
  (`.env.example`, `docker-compose.yml`, `AGENTS.md`, `flake.nix`, workflow
  kebab names). See [references/scope.md](references/scope.md).

## Defaults when empty

If survey finds almost nothing, use [references/defaults.md](references/defaults.md)
and stay consistent from the first name onward.

## Anti-patterns

- Random animal/food codenames unless that theme already exists in-scope
- Spaces in new paths; Title Case folders beside kebab siblings
- Mixing `camelCase` and `kebab-case` files in the same folder
- Applying this workspace's house style to an unrelated repo without surveying it
- "Improving" required system filenames (`package.json` → `pkg.json`)
- `utils2.ts`, `helpers-new.ts`, `tmp-final.tsx`

## Bundled resources

| Path | When |
|------|------|
| [scripts/survey-names.sh](scripts/survey-names.sh) | Always before naming |
| [references/scope.md](references/scope.md) | Multi-repo, files, system/config names |
| [references/rules.md](references/rules.md) | Case / separator by kind |
| [references/kinds.md](references/kinds.md) | Classify the ask |
| [references/defaults.md](references/defaults.md) | Greenfield only |
