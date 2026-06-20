# Triage Playbook

Use triage when the request is a new ticket, alert, question, or unclear task.

## Gather

- Read the full request and comments.
- Identify requester, affected service, environment, urgency, and deadline.
- Check whether the work belongs to the current team.
- Look for duplicates, related incidents, and existing runbooks.

## Classify

Choose one:

- incident
- provision/change
- production readiness
- observability
- security/cost
- information only
- out of scope
- needs more information

For incident-like work, classify SEV1-SEV4.
For change-like work, classify risk: low, medium, high.

## Output

```markdown
**Triage result**
- Type:
- Severity/Risk:
- Owner:
- Next action:
- ETA:
- Missing information:
```

If out of scope, explain why and suggest the right owner or queue.
