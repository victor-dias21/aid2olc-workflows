# AIDLC Operations Core Workflow

> This file is the portable entry point for AIDLC Operations Workflows.
> The directory name `aidlc-rules/` is retained as a legacy package path for
> compatibility with the upstream release tooling and existing agent installers.

## Mission

AIDLC Operations guides AI coding and operations agents through cloud operations,
DevOps, infrastructure, and SRE work. It adapts AIDLC's disciplined artifact
and approval model to operational workflows where context, blast radius,
rollback, and human control matter more than speed.

## Activation

Use AIDLC Operations when the user asks about:

- incident response, service degradation, alerts, or postmortems
- infrastructure provisioning, permissions, networking, CI/CD, Kubernetes, or
  cloud resources
- production readiness, observability, security review, cost review, or
  operational troubleshooting
- any request that starts with "Using AIDLC", "Using AIDLC Operations", or
  "Using OLC"

If the user is only asking a general question, answer without creating files
unless they ask for a durable artifact.

## Rule Details Loading

Resolve the rule details directory by checking these locations in order:

1. `.aidlc/aidlc-rules/aws-aidlc-rule-details/`
2. `.aidlc-rule-details/`
3. `.kiro/aws-aidlc-rule-details/`
4. `.amazonq/aws-aidlc-rule-details/`

All detail file references below are relative to the first directory found.

At workflow start, load:

- `common/process-overview.md`
- `common/session-continuity.md`
- `common/error-handling.md`
- `operations/operations.md`
- `operations/severity-matrix.md`
- `operations/ops-gates.md`

Load additional operation files only when relevant:

- `operations/triage.md`
- `operations/incident.md`
- `operations/provision-change.md`
- `operations/production-readiness.md`
- `operations/observability.md`
- `operations/security-cost-review.md`
- `operations/post-session-learning.md`

## Core Operating Principles

1. Context before action: gather real state before proposing changes.
2. Read-only by default: diagnostics, listing, and inspection are autonomous.
3. Human approves mutating work: writes, applies, deletes, restarts, rollbacks,
   merges, and cloud changes require explicit approval.
4. Severity defines autonomy: SEV1 is diagnostic only; SEV2/SEV3 require an
   approved remediation plan; SEV4 is report-first.
5. Every plan includes blast radius, rollback, validation, and owner.
6. Learn from completed work without storing secrets.

## Operational Modes

Select exactly one primary mode at Pre-flight. If the request spans modes,
start with Triage and branch.

| Mode                 | Use when                                              | Detail file                               |
| -------------------- | ----------------------------------------------------- | ----------------------------------------- |
| Triage               | New ticket, alert, vague request, or queue item       | `operations/triage.md`                    |
| Incident             | Something is broken, degraded, unavailable, or risky  | `operations/incident.md`                  |
| Provision / Change   | Create, modify, decommission, or promote resources    | `operations/provision-change.md`          |
| Production Readiness | Assess a service/change before production             | `operations/production-readiness.md`      |
| Observability        | Logs, traces, metrics, dashboards, monitors, SLOs     | `operations/observability.md`             |
| Security / Cost      | IAM, exposure, compliance, waste, rightsizing, budget | `operations/security-cost-review.md`      |

## Five Operational Gates

Every operational task follows these gates. Do not skip gates; keep them
right-sized to the request.

### Gate 1: Gather Context

Collect ticket/request text, affected service, environment, account, cluster,
namespace, recent changes, logs, metrics, traces, dashboards, and existing
runbooks. Use read-only commands only.

### Gate 2: Pre-flight

Classify mode and severity. Confirm access, current context, dependencies,
blast radius, rollback availability, and whether the user expects diagnosis,
implementation, or documentation.

### Gate 3: Plan

Produce a concise plan with:

- current evidence
- hypotheses or change steps
- blast radius
- exact mutating actions, if any
- rollback
- validation checks
- approval question for mutating work

### Gate 4: Execute

Execute only the approved plan. If evidence changes, stop and re-plan. Never
expand mutating scope silently.

### Gate 5: Validate / Learn

Validate health and expected outcomes. Document result, unresolved risk, next
owner, and whether a reusable rule, runbook, or template should be updated.

## Severity Guardrails

Use `operations/severity-matrix.md` for the full matrix.

- SEV1: production outage, high user impact, data exposure, or critical shared
  dependency down. Diagnose only and page/escalate the human owner.
- SEV2: partial production outage, severe latency, failed release, high-risk
  security or permission issue. Plan and execute only after explicit approval.
- SEV3: degraded service, warning alert, isolated production issue, failing main
  pipeline. Plan and execute only after explicit approval.
- SEV4: low-risk warning, cost anomaly, hygiene task, documentation or report.
  Prefer report or PR; mutating actions still require approval.

## State Persistence

For multi-step work, create or update `.aidlc/state/<ticket-or-topic>/` with:

- `1-gather.md`
- `2-preflight.md`
- `3-plan.md`
- `4-execute.md`
- `5-validate.md`

If state already exists, read it first and resume from the last incomplete gate.
Never store secrets, tokens, private keys, passwords, or raw credentials.

## Completion Contract

Before finishing, report:

- mode and severity
- actions taken or why no action was taken
- validation result
- residual risks or blocked items
- files, PRs, tickets, dashboards, or commands the user should know about
