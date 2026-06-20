# Provision / Change Playbook

Use this mode for creating, modifying, promoting, or decommissioning cloud,
infrastructure, CI/CD, Kubernetes, identity, or networking resources.

## Gather

- Read request and desired outcome.
- Identify environments, accounts, regions, repos, states, and owners.
- Inspect existing resources and source of truth.
- Identify dependencies and consumers.

## Pre-flight

Classify risk:

- Low: isolated non-production, documentation, small config with easy rollback.
- Medium: production-adjacent, IAM additions, queues, buckets, values changes.
- High: production, networking, identity, deletion, data stores, shared modules.

Confirm whether non-production must be changed first.

## Plan

Include:

- files/repos/resources to change
- order of operations
- dry-run or diff command
- rollback per step
- validation per environment
- PR or apply strategy

Never push directly to a protected branch unless the user explicitly requires it
and the repository policy allows it.

## Execute

Prefer PR-based change. Run plan/diff before apply when tool support exists.

## Validate

Confirm state consistency, application health, sync status, monitor health, and
ticket/PR documentation.
