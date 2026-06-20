# Observability Playbook

Use this mode for logs, metrics, traces, dashboards, monitors, SLOs, alert
quality, and telemetry gaps.

## Gather

- Identify service, owner, environment, and user journey.
- Inspect existing dashboards, monitors, log patterns, traces, and metrics.
- Check alert routing, severity, noise, and runbook links.

## Design

Cover the four golden signals:

- latency
- traffic
- errors
- saturation

Add domain metrics when they directly explain user impact.

## Plan

Include:

- telemetry source
- tags/labels
- monitor thresholds
- routing and severity
- dashboard placement
- validation query

## Validate

Confirm that telemetry appears with expected tags, monitor state is correct, and
the alert message tells an on-call engineer what to do next.
