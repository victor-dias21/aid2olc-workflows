# Administrative Guide

This guide documents the CI/CD, release, security, and maintenance model for
the AIDLC Operations Workflows repository.

## Repository Overview

The repository publishes AIDLC Operations as Markdown workflow rules under
`aidlc-rules/`. The release pipeline packages that directory as
`aidlc-rules-vX.Y.Z.zip`.

```text
.github/workflows/
├── ci.yml
├── codebuild.yml
├── pull-request-lint.yml
├── release.yml
├── release-pr.yml
├── security-scanners.yml
└── tag-on-merge.yml
aidlc-rules/
├── aws-aidlc-rules/
└── aws-aidlc-rule-details/
scripts/
├── install.sh
└── install.ps1
```

## Release Process

1. Dispatch `release-pr.yml`.
2. Review the generated changelog and `aidlc-rules/VERSION`.
3. Merge the release PR.
4. `tag-on-merge.yml` creates tag `vX.Y.Z`.
5. `release.yml` creates a draft release with `aidlc-rules-vX.Y.Z.zip`.
6. Optional evaluation/build artifacts are attached by `codebuild.yml`.
7. A maintainer reviews and publishes the draft release.

## Release Artifact Contract

- Artifact name: `aidlc-rules-vX.Y.Z.zip`.
- The zip must contain the top-level `aidlc-rules/` directory.
- `aidlc-rules/aws-aidlc-rules/core-workflow.md` is the portable entry point.
- `aidlc-rules/aws-aidlc-rule-details/operations/` contains the operational
  playbooks.

## Protected Environments

| Environment | Purpose                                  |
| ----------- | ---------------------------------------- |
| `codebuild` | Gates AWS credentials and build uploads  |

## Required Secrets and Variables

| Name                     | Type        | Purpose                                  |
| ------------------------ | ----------- | ---------------------------------------- |
| `AWS_CODEBUILD_ROLE_ARN` | Secret      | OIDC role assumption for CodeBuild       |
| `CODEBUILD_PROJECT_NAME` | Variable    | CodeBuild project name                   |
| `AWS_REGION`             | Variable    | AWS region for CodeBuild and STS         |

## Security Posture

- External GitHub Actions should remain SHA-pinned.
- Workflows should use least-privilege permissions.
- Secret findings must be rotated and removed from history.
- High and critical dependency or IaC findings require remediation or documented
  risk acceptance.

## Local Maintainer Checks

```bash
npx markdownlint-cli2 "**/*.md"
bash -n scripts/install.sh
git diff --check
```

```powershell
$tokens = $null
$errors = $null
$null = [System.Management.Automation.Language.Parser]::ParseFile(
  "scripts/install.ps1",
  [ref]$tokens,
  [ref]$errors
)
if ($errors) { $errors; exit 1 }
```
