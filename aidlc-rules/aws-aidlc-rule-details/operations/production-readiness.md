# Production Readiness Playbook

Use this mode before promoting a service, platform change, or infrastructure
component to production.

## Review Areas

- ownership and support model
- architecture and dependencies
- deployment and rollback
- scaling and capacity
- security, identity, and secrets
- observability and SLOs
- backup, restore, and disaster recovery
- runbooks and incident response
- cost and quota risks

## Output

```markdown
# Production Readiness Review

## Decision

Ready | Ready with risks | Not ready

## Blocking Findings

## Non-blocking Findings

## Required Before Production

## Follow-up After Production
```

Do not mark a workload ready when rollback, ownership, or observability is
unknown.
