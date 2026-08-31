---
name: celery-axi
description: Use celery-axi to discover, inspect, run, debug, monitor, schedule, control, and safely operate Celery task queues and managed brokers through safe TOON CLI workflows.
---

# celery-axi

Use `celery-axi` when a task involves Celery apps, workers, queues, tasks, beat schedules, broker/result backends, Redis, RabbitMQ, SQS, managed broker operations, logs, events, retries, revokes, purges, or Celery safety checks.

Run `npx -y celery-axi` for live context. Use `npx -y celery-axi doctor` before Celery work. Discover targets with `npx -y celery-axi discover --full`. Inspect workers with `npx -y celery-axi workers`. Plan before mutating with `npx -y celery-axi plan --target <worker|beat|task|broker|managed-broker>`. Mutations require `--execute`; destructive broker/task operations also require exact `--confirm`.
