---
name: elasticsearch-axi
description: Agent-facing CLI for Elasticsearch/OpenSearch clusters — inspect health, indices, mappings, and pipelines; run queries and SQL; manage snapshots — via token-efficient TOON output. Use when a user asks about Elasticsearch or OpenSearch cluster state, indices, search queries, mappings, ingest pipelines, or snapshots.
---

Run `elasticsearch-axi` with no arguments for live cluster status. Run `elasticsearch-axi doctor` first if unsure whether a cluster is reachable. Run `elasticsearch-axi <command> --help` for any subcommand's flags. All output is TOON-formatted (not JSON) — read the header line (`name[count]{fields}:`) to know the shape before parsing rows. Mutating and destructive commands default to dry-run; pass `--execute` (and `--confirm <name>` for destructive ones) only after reviewing the preview.
