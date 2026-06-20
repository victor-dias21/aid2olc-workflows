# AGENTS.md

## Project Overview

AIDLC Operations Workflows is a multi-agent methodology for cloud operations,
DevOps, infrastructure, and SRE work. The repository packages portable Markdown
rules, operational playbooks, installers, release automation, and supporting
evaluation tools.

The distributable product is the `aidlc-rules/` directory. It is zipped and
published through GitHub Releases as `aidlc-rules-vX.Y.Z.zip`.

## Repository Structure

```text
aidlc-rules/
├── aws-aidlc-rules/
│   └── core-workflow.md
└── aws-aidlc-rule-details/
    ├── common/
    ├── extensions/
    └── operations/
scripts/
├── install.sh
├── install.ps1
├── aidlc-evaluator/
├── aidlc-designreview/
├── aidlc-codereview/
└── aidlc-traceability/
docs/
├── ADMINISTRATIVE_GUIDE.md
├── DEVELOPERS_GUIDE.md
├── WORKING-WITH-AIDLC.md
└── GENERATED_DOCS_REFERENCE.md
```

## Development Rules

- Keep public naming as **AIDLC** or **AIDLC Operations**.
- Do not introduce non-AIDLC product terminology.
- Preserve `aidlc-rules/`, `aws-aidlc-rules/`, and
  `aws-aidlc-rule-details/`; they are compatibility paths.
- Prefer shared guidance in `common/` and operation-specific guidance in
  `operations/`.
- Mutating operational guidance must preserve the five gates:
  Gather Context, Pre-flight, Plan, Execute, Validate/Learn.
- Never store secrets, tokens, passwords, private keys, or raw credentials in
  examples, fixtures, state files, or documentation.

## Setup Commands

```bash
npx markdownlint-cli2 "**/*.md"
bash -n scripts/install.sh
```

PowerShell parser check:

```powershell
$null = [System.Management.Automation.Language.Parser]::ParseFile(
  "scripts/install.ps1",
  [ref]$null,
  [ref]$null
)
```

Python package tests, when touching a package:

```bash
cd scripts/aidlc-evaluator && uv run pytest
```

## Installation Testing

Use temporary directories and dry-run mode first:

```bash
scripts/install.sh --agent all --target /tmp/aidlc-test --dry-run
```

Then test each target agent path:

```bash
scripts/install.sh --agent kiro --target /tmp/aidlc-kiro --force
scripts/install.sh --agent claude --target /tmp/aidlc-claude --force
scripts/install.sh --agent codex --target /tmp/aidlc-codex --force
scripts/install.sh --agent cursor --target /tmp/aidlc-cursor --force
scripts/install.sh --agent antigravity --target /tmp/aidlc-antigravity --force
```

## PR Guidance

- Use conventional commit titles.
- Run markdown lint and relevant script syntax checks before commit.
- Include the contributor statement from `.github/pull_request_template.md`.
- For operational rule changes, update README or docs when setup, behavior, or
  compatibility changes.
