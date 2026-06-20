# Post-Session Learning

At the end of meaningful operational work, evaluate whether the system should
learn from the session.

## Ask

- What worked?
- What took longer than expected?
- Which context was missing?
- Which command, query, checklist, or decision repeated?
- Should a runbook, rule, template, dashboard, or monitor be updated?

## Proposal Format

```markdown
## Improvement Proposal

**Type:** rule | runbook | template | dashboard | monitor | script
**File or system:**
**Reason:**
**Proposed change:**
**Source ticket/session:**
```

Do not store secrets. Do not create unrelated broad rules from one narrow event.
