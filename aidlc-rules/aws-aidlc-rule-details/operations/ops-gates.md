# Operational Gates

## Gate 1: Gather Context

Collect:

- request, ticket, alert, or incident text
- affected service, owners, environment, account, region, cluster, namespace
- recent deployments, config changes, incidents, or infrastructure changes
- relevant logs, metrics, traces, dashboards, runbooks, and inventories

Only read state in this gate.

## Gate 2: Pre-flight

Decide:

- mode and severity
- current access and target context
- blast radius and dependencies
- whether production or shared resources are involved
- whether the requested action is read-only or mutating

Stop if the account, cluster, namespace, or repo is uncertain.

## Gate 3: Plan

Create a plan with:

- evidence summary
- hypotheses or implementation steps
- exact commands or file changes
- blast radius
- rollback path
- validation checks
- explicit approval request for mutating work

## Gate 4: Execute

Execute the approved scope only. If new evidence changes risk or scope, stop,
explain the delta, and return to Gate 3.

## Gate 5: Validate / Learn

Validate:

- service health, readiness, sync, or command result
- monitors and dashboards
- ticket/comment/PR documentation
- residual risk and owner
- whether a reusable rule, runbook, template, or state file should be updated

## State File Template

```markdown
# Gate N: <name>

**Timestamp:** YYYY-MM-DDTHH:MM:SSZ
**Status:** complete | paused | blocked
**Mode:** triage | incident | provision-change | readiness | observability | security-cost
**Severity:** SEV1 | SEV2 | SEV3 | SEV4 | n/a

## Evidence

## Decision

## Next
```
