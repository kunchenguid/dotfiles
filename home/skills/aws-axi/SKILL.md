---
name: aws-axi
description: Use aws-axi to discover, plan, provision, deploy, inspect, and troubleshoot AWS hosting, backend, database, and AI workloads through safe TOON CLI workflows.
---

# aws-axi

Use `aws-axi` when a task involves AWS architecture, hosting, deployments, service recommendations, infrastructure status, CloudWatch logs, or production safety checks.

Run `npx -y aws-axi` for live context. Use `npx -y aws-axi doctor` before production work. Plan before applying: `npx -y aws-axi plan --target <id> --environment <name>`. Mutations require `--execute`; production also requires `--confirm-account <account-id>`.
