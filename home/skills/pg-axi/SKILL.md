---
name: pg-axi
description: Use pg-axi to discover, create, inspect, query, back up, restore, and maintain PostgreSQL databases through safe TOON CLI workflows.
---

# pg-axi

Use `pg-axi` when a task involves PostgreSQL databases, schemas, tables, indexes, roles, extensions, functions, queries, backups, restores, maintenance, activity, stats, replication, local Postgres, Docker Compose Postgres, or managed Postgres connection safety checks.

Run `npx -y pg-axi` for live context. Use `npx -y pg-axi doctor` before database work. Discover targets with `npx -y pg-axi discover`. Inspect before mutating: `npx -y pg-axi inspect --kind table --schema public --name <name>`. Mutations require `--execute`; destructive operations also require `--confirm <exact-name>`.
