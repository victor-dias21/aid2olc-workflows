# Security / Cost Review Playbook

Use this mode for IAM, exposed surfaces, secrets, compliance, vulnerabilities,
cloud cost, capacity waste, quota risk, or rightsizing.

## Security Review

Check:

- least privilege
- public exposure
- secrets handling
- encryption in transit and at rest
- audit logs
- dependency or image vulnerabilities
- privileged workloads
- network boundaries

Treat suspected credential exposure as SEV1 until proven otherwise.

## Cost Review

Check:

- idle or oversized resources
- request/limit mismatch
- storage growth
- data transfer and NAT costs
- logging volume
- reserved capacity or savings opportunities
- orphaned resources

## Output

Classify findings as:

- Critical: immediate action or escalation
- High: fix before production or within agreed SLA
- Medium: planned remediation
- Low: hygiene or informational

Include evidence, recommended action, expected impact, and validation.
