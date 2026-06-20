# Working with AIDLC Operations

This guide explains how to use AIDLC for cloud operations, DevOps,
infrastructure, and SRE workflows.

## Operating Rule

Use AIDLC when you need the agent to be careful, auditable, and explicit:

```text
Using AIDLC Operations, triage this alert.
```

```text
Using AIDLC, prepare a safe rollout plan for this infrastructure change.
```

For casual questions, add a no-change instruction:

```text
Do not update files or execute changes. Help me understand this alert.
```

## The Five Gates

1. **Gather Context**: read-only evidence collection.
2. **Pre-flight**: classify mode, severity, risk, access, and blast radius.
3. **Plan**: propose action with rollback and validation.
4. **Execute**: apply only what was explicitly approved.
5. **Validate / Learn**: confirm outcome and capture reusable learning.

## Modes

| Mode                 | Use when                                      |
| -------------------- | --------------------------------------------- |
| Triage               | A new ticket, alert, queue item, or vague ask |
| Incident             | A service is broken, degraded, or unsafe      |
| Provision / Change   | Infrastructure or config must change          |
| Production Readiness | A workload is approaching production          |
| Observability        | Logs, metrics, traces, monitors, or SLOs      |
| Security / Cost      | Risk, exposure, IAM, waste, or budget issues  |

## Approval Discipline

Read-only diagnostics can proceed autonomously. Mutating actions require
approval, including:

- `kubectl apply`, `delete`, `patch`, rollout restart, or scale changes
- Terraform or CloudFormation apply/destroy
- IAM, networking, DNS, certificate, or secret changes
- production deploys, rollbacks, merges, or release promotion
- data deletion, migration, or restore

For SEV1, the agent diagnoses and escalates; a human executes remediation.

## Good Prompts

```text
Using AIDLC Operations, classify this alert and tell me what evidence you need
before proposing remediation.
```

```text
Using AIDLC, inspect this Terraform change. Do not apply anything. Produce a
blast radius and rollback plan.
```

```text
Using AIDLC Operations, review whether this service is production-ready. Treat
unknown ownership or rollback as blocking.
```

## Resuming Work

If `.aidlc/state/<ticket-or-topic>/` exists, ask the agent to read it first:

```text
Using AIDLC, resume this task from .aidlc/state/AIDEN-1234. Continue from the
first incomplete gate.
```

## Keeping Reports Separate

Operational state belongs in `.aidlc/state/`. Human-facing reports can go in
`reports/`. Do not store secrets or raw credentials in either location.

## Closing a Session

Before closing, verify:

- the ticket, alert, PR, or incident record has the result
- service health or command result was validated
- residual risk and owner are explicit
- reusable learning was proposed when useful
