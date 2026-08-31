---
name: oracle-axi
description: Use oracle-axi to discover, create, inspect, query, export, import, maintain, and diagnose Oracle databases through safe TOON CLI workflows.
---

# oracle-axi

Use `oracle-axi` when a task involves Oracle Database connections, TNS, wallets, schemas, users, tables, views, indexes, roles, tablespaces, sequences, synonyms, PL/SQL, triggers, jobs, queries, Data Pump export/import, maintenance, activity, stats, local Oracle XE/Free, Docker Compose Oracle, or managed Oracle connection safety checks.

Run `npx -y oracle-axi` for live context. Use `npx -y oracle-axi doctor` before database work. Discover targets with `npx -y oracle-axi discover`. Inspect before mutating: `npx -y oracle-axi inspect --kind table --schema <schema> --name <name>`. Mutations require `--execute`; destructive operations also require `--confirm <exact-name>`.
