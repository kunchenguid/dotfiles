---
name: dynamodb-axi
description: Use dynamodb-axi to discover, inspect, query, scan, create, update, back up, restore, export, import, and safely operate DynamoDB tables through safe TOON CLI workflows.
---

# dynamodb-axi

Use `dynamodb-axi` when a task involves DynamoDB table discovery, inspection, keys, indexes, reads, bounded scans, guarded writes, backups, restores, exports, imports, TTL, streams, capacity, DynamoDB Local, or AWS DynamoDB safety checks.

Run `npx -y dynamodb-axi` for live context. Use `npx -y dynamodb-axi doctor` before production work. Inspect before mutating: `npx -y dynamodb-axi inspect --table <name>`. Scans require an explicit limit: `npx -y dynamodb-axi scan --table <name> --limit 25`. Mutations require `--execute`; destructive operations also require `--confirm <exact-name>`.
