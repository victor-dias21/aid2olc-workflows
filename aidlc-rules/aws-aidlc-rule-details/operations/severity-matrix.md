# Severity Matrix

Severity determines urgency and agent autonomy.

| SEV      | Criteria                                                        | Agent autonomy                                  | Target response |
| -------- | --------------------------------------------------------------- | ----------------------------------------------- | --------------- |
| **SEV1** | Production outage, >30% traffic affected, data exposure         | Diagnose only. Human executes. Page immediately | <5 min          |
| **SEV2** | Partial outage, severe latency, critical dependency impaired    | Draft remediation, wait for approval, execute   | <15 min         |
| **SEV3** | Degradation, warning alert, isolated production issue           | Draft remediation, wait for approval, execute   | Same day        |
| **SEV4** | Hygiene, low-risk warning, cost anomaly, documentation request  | Report or PR first; mutating work needs approval| Best effort     |

## SEV1 Examples

- Production service has 0/N ready replicas for more than five minutes.
- 5xx errors exceed 30% of traffic.
- Secret, key, token, or customer data exposure is suspected.
- Shared database, broker, cache, VPN, or identity provider is unavailable.

## SEV2 Examples

- CrashLoopBackOff in production with active user impact.
- P99 latency is more than twice baseline.
- Production deploy is broken or rollback is needed.
- Cross-account networking, IAM, or certificate issue blocks a critical path.

## SEV3 Examples

- Disk, memory, queue lag, or certificate warning needs action soon.
- Main branch pipeline fails.
- Intermittent OOMKilled or degraded health without broad impact.

## SEV4 Examples

- Log volume increase without errors.
- Cost increase requiring investigation.
- Medium severity image CVE.
- Documentation, inventory, dashboard, or monitor cleanup.

## Escalation Rule

If severity is uncertain, choose the higher severity until evidence lowers it.
