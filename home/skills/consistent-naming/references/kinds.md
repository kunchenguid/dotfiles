# Name kinds

Pick one kind before surveying. If unsure, ask once.

| Kind | Examples of asks | Survey focus |
|------|------------------|--------------|
| project | "name this repo", "new product folder" | sibling projects on disk + parent listing |
| package | "name the workspace package" | `packages/`, `apps/`, workspace members |
| directory | "make a folder for X" | immediate parent listing |
| file | "create a util for Y", "new module" | sibling files + extension conventions |
| system | "env template", "workflow file", "compose" | existing config idioms in that repo |
| component | "new React component" | `components/`, PascalCase peers |
| test | "add a test file" | existing `*.test.*` / `*_test.go` |
| env | "what should the env var be called" | `.env.example`, vault index, `PROVIDER_*` |
| branch | "branch name for this work" | `git branch` recent names |
| skill | "new agent skill" | `home/skills/*` kebab names |
| cli | "flag/command name" | existing `--help` and scripts |
| api | "route or table name" | routers, migrations |

When one artifact implies many names (project + package + env prefix), decide
the **stem** first in the correct scope, then derive the rest from
[rules.md](rules.md). For cross-repo work, re-survey each destination
([scope.md](scope.md)).
