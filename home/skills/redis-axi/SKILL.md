---
name: redis-axi
description: Use redis-axi to discover, inspect, query, export, import, and maintain Redis databases through safe TOON CLI workflows.
---

# redis-axi

Use `redis-axi` when a task involves Redis databases, keys, hashes, lists, sets, sorted sets, streams, pub/sub channels, ACL users, consumer groups, persistence, performance analysis, cluster topology, Sentinel configuration, local Redis, Docker Compose Redis, Bull/BullMQ queues, Sidekiq, Celery, or managed Redis connection safety checks.

Run `npx -y redis-axi` for live context. Use `npx -y redis-axi doctor` before Redis work. Discover targets with `npx -y redis-axi discover`. Inspect before mutating: `npx -y redis-axi inspect --kind key --name <key>`. Mutations require `--execute`; destructive operations also require `--confirm <exact-value>`.
