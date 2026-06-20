# Incident Playbook

Use incident mode when something is broken, degraded, unavailable, unsafe, or
threatening production stability.

## Gather

- Read alert/ticket and identify exact symptoms.
- Confirm service, account, region, cluster, namespace, and owner.
- Inspect health, pods/tasks, recent deploys, logs, metrics, traces, and
  dependency status.
- Capture timeline from first signal to current state.

## Pre-flight

- Classify severity using `severity-matrix.md`.
- Identify blast radius and shared dependencies.
- Confirm rollback options.
- For SEV1, diagnose only and escalate to human owner.

## Plan

Create 3-5 hypotheses. For each hypothesis, include the read-only check that
would confirm or reject it.

If remediation is likely, include:

- exact action
- expected impact
- rollback
- validation
- approval request

## Execute

Run diagnostics first. Apply remediation only after approval for SEV2/SEV3/SEV4
mutating work.

## Validate

- Confirm service health and error/latency recovery.
- Confirm monitors return to OK or expected state.
- Document root cause, remediation, rollback status, and residual risk.
- Recommend postmortem for SEV1/SEV2.
