---
name: mongodb-axi
description: Use mongodb-axi to discover, create, inspect, query, export, import, maintain, diagnose, provision, and delete MongoDB and MongoDB Atlas resources through safe TOON CLI workflows.
---

# mongodb-axi

Use `mongodb-axi` when a task involves MongoDB connections, SRV URIs, TLS, certificates, databases, collections, views, capped collections, documents, filters, projections, aggregation pipelines, indexes, users, roles, profiler data, current operations, server stats, mongodump, mongorestore, mongoexport, mongoimport, Atlas projects, Atlas clusters, Atlas database users, Atlas access lists, local MongoDB Docker Compose, ODM configs, migrations, seeds, or managed MongoDB safety checks.

Run `npx -y mongodb-axi` for live context. Use `npx -y mongodb-axi doctor` before database or Atlas work. Discover targets with `npx -y mongodb-axi discover`. Inspect before mutating: `npx -y mongodb-axi inspect --kind collection --database <db> --collection <collection> --name <collection>`. Mutations require `--execute`; destructive operations also require `--confirm <exact-value>`. Atlas lifecycle commands are under `npx -y mongodb-axi atlas <list|inspect|create|drop|auth|readiness>` and are dry-run by default.
