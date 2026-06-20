# Operations Overview

AIDLC Operations is organized around operational work rather than software delivery
phases. The workflow starts with real context, classifies risk, creates an
approvable plan, executes only what was approved, and validates the result.

## Modes

| Mode                 | Primary question                         | Output                                      |
| -------------------- | ---------------------------------------- | ------------------------------------------- |
| Triage               | What is this and who should handle it?   | Classification and next action              |
| Incident             | What is broken and how do we restore it? | Diagnosis, remediation, validation          |
| Provision / Change   | What should change safely?               | Change plan, artifacts, rollout, rollback   |
| Production Readiness | Is this safe to run in production?       | Readiness report and blocking gaps          |
| Observability        | Can we see and alert on the right things?| Instrumentation and monitor plan            |
| Security / Cost      | Is risk or waste acceptable?             | Findings, recommendations, accepted risk    |

## Required Posture

- Gather context before action.
- Prefer read-only commands until a plan is approved.
- Make current account, region, cluster, namespace, and repo explicit.
- Treat production, identity, networking, data stores, and deletion as high risk.
- Include rollback and validation for every mutating action.
- Stop when blast radius is larger than expected.
