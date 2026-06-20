# AIDLC Operations Workflows

AIDLC Operations Workflows is a public, multi-agent workflow package for cloud
operations, DevOps, infrastructure, and SRE work. It keeps the disciplined,
auditable style of AIDLC while shifting the center of gravity from application
delivery to operational work: incidents, triage, provisioning, production
readiness, observability, security, and cost.

> Generative AI can make mistakes. Treat operational actions as high impact:
> review plans, verify context, and require explicit approval before mutating
> infrastructure, production systems, identity, networking, or data.

## Contents

- [What This Provides](#what-this-provides)
- [Quick Start](#quick-start)
- [Supported Agents](#supported-agents)
- [Installation](#installation)
- [How To Use](#how-to-use)
- [Workflow](#workflow)
- [Rule Package Layout](#rule-package-layout)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License and Attribution](#license-and-attribution)

## What This Provides

- A portable **AIDLC Operations** core workflow for AI coding and operations
  agents.
- Operational playbooks for triage, incidents, provisioning/change,
  production readiness, observability, and security/cost review.
- A SEV1-SEV4 severity model that controls autonomy and escalation.
- A five-gate execution loop:
  `Gather Context -> Pre-flight -> Plan -> Execute -> Validate/Learn`.
- Cross-agent installation for Kiro, Claude Code, Codex, Antigravity, and Cursor.
- Release-friendly packaging as `aidlc-rules-vX.Y.Z.zip`.

## Quick Start

From a target project where you want the rules installed:

```bash
git clone https://github.com/victor-dias21/aidlc-workflows /tmp/aidlc-workflows
/tmp/aidlc-workflows/scripts/install.sh --agent all --target . --source local
```

On Windows PowerShell:

```powershell
git clone https://github.com/victor-dias21/aidlc-workflows $env:TEMP\aidlc-workflows
& "$env:TEMP\aidlc-workflows\scripts\install.ps1" -Agent all -Target . -Source local
```

Then start your agent in the target project and ask:

```text
Using AIDLC Operations, triage this alert.
```

or:

```text
Using AIDLC, plan this production change safely.
```

## Supported Agents

| Agent              | IDE | CLI | Installation target                                                   |
| ------------------ | --- | --- | --------------------------------------------------------------------- |
| Kiro               | Yes | Yes | `.kiro/steering/aws-aidlc-rules/` and `.kiro/aws-aidlc-rule-details/` |
| Claude Code        | Yes | Yes | `CLAUDE.md` and `.aidlc-rule-details/`                                |
| OpenAI Codex       | Yes | Yes | `AGENTS.md` and `.aidlc-rule-details/`                                |
| Google Antigravity | Yes | Yes | `.agents/agents.md`, `.agents/skills/`, `.agents/workflows/`          |
| Cursor             | Yes | Yes | `.cursor/rules/aidlc-workflow.mdc` and `.aidlc-rule-details/`         |

The package keeps the `aws-aidlc-rules/` and `aws-aidlc-rule-details/` directory
names because they are part of the inherited distribution contract.

## Installation

### Universal Installer

macOS/Linux:

```bash
scripts/install.sh --agent all --target /path/to/project --source local
```

Windows PowerShell:

```powershell
.\scripts\install.ps1 -Agent all -Target C:\path\to\project -Source local
```

Supported options:

| Option                   | Values                                                       | Purpose                                  |
| ------------------------ | ------------------------------------------------------------ | ---------------------------------------- |
| `--agent` / `-Agent`     | `kiro`, `claude`, `codex`, `antigravity`, `cursor`, `all`    | Select target agent                      |
| `--target` / `-Target`   | path                                                         | Project where rules will be installed    |
| `--source` / `-Source`   | `local`, `release`                                           | Install from checkout or release         |
| `--version` / `-Version` | `latest`, `vX.Y.Z`                                           | Release version when source is `release` |
| `--force` / `-Force`     | flag                                                         | Overwrite existing files                 |
| `--dry-run` / `-DryRun`  | flag                                                         | Show actions without writing             |

### Kiro

```bash
scripts/install.sh --agent kiro --target .
```

Expected structure:

```text
.kiro/
├── steering/
│   └── aws-aidlc-rules/
└── aws-aidlc-rule-details/
```

Verify in Kiro CLI with `/context show` and confirm the steering entry is loaded.

### Claude Code

```bash
scripts/install.sh --agent claude --target .
```

Expected structure:

```text
CLAUDE.md
.aidlc-rule-details/
```

Start Claude Code in the project and ask what project instructions are active.

### Codex

```bash
scripts/install.sh --agent codex --target .
```

Expected structure:

```text
AGENTS.md
.aidlc-rule-details/
```

Codex automatically loads `AGENTS.md` from the project root.

### Cursor

```bash
scripts/install.sh --agent cursor --target .
```

Expected structure:

```text
.cursor/rules/aidlc-workflow.mdc
.aidlc-rule-details/
```

Open Cursor settings and confirm the `aidlc-workflow` project rule is active.

### Antigravity

```bash
scripts/install.sh --agent antigravity --target .
```

Expected structure:

```text
.agents/
├── agents.md
├── skills/
│   └── aidlc-operations.md
└── workflows/
    └── aidlc-operations.md
.aidlc-rule-details/
```

## How To Use

Start requests with the workflow name when you want operational discipline:

```text
Using AIDLC Operations, investigate this Datadog alert.
```

```text
Using AIDLC, create a safe plan to add this IAM permission.
```

```text
Using AIDLC Operations, review production readiness for this service.
```

The agent should classify the work, gather context, show a plan, and ask for
approval before mutating anything.

## Workflow

### 1. Gather Context

Read the ticket, alert, repo, environment, dashboards, logs, metrics, traces, and
runbooks. This gate is read-only.

### 2. Pre-flight

Classify mode and severity. Confirm account, region, cluster, namespace, repo,
blast radius, dependencies, and rollback availability.

### 3. Plan

Produce an approvable plan with evidence, steps, exact mutating actions,
rollback, validation, and open risks.

### 4. Execute

Execute only the approved scope. Stop and re-plan if risk or evidence changes.

### 5. Validate / Learn

Verify health, document the outcome, identify residual risk, and propose durable
learning when a reusable runbook, rule, template, monitor, or script would help.

## Rule Package Layout

```text
aidlc-rules/
├── VERSION
├── aws-aidlc-rules/
│   └── core-workflow.md
└── aws-aidlc-rule-details/
    ├── common/
    ├── construction/
    ├── extensions/
    ├── inception/
    └── operations/
```

The workflow uses the operations rules first. The inherited inception,
construction, common, and extension folders are kept so the package remains
compatible with existing AIDLC tooling and evaluator workflows.

## Troubleshooting

### The agent does not mention AIDLC Operations

Confirm the expected instruction file exists for your agent:

- Kiro: `.kiro/steering/aws-aidlc-rules/core-workflow.md`
- Claude Code: `CLAUDE.md`
- Codex: `AGENTS.md`
- Cursor: `.cursor/rules/aidlc-workflow.mdc`
- Antigravity: `.agents/agents.md`

Then ask:

```text
What project instructions are active?
```

### Rule details are not loaded

Confirm `.aidlc-rule-details/` or the Kiro-specific
`.kiro/aws-aidlc-rule-details/` directory exists. The core workflow lists the
supported lookup order.

### Existing files block installation

Re-run with `--force` only after reviewing what will be overwritten:

```bash
scripts/install.sh --agent codex --target . --dry-run
scripts/install.sh --agent codex --target . --force
```

### Windows extracted a nested release folder

If a zip extracts to `aidlc-rules-vX.Y.Z/aidlc-rules/`, point the installer at
the repository checkout or copy the inner `aidlc-rules/` folder into the expected
location.

### Production action looks unsafe

Stop at Gate 3. Require a new plan with exact account, environment, blast radius,
rollback, and validation. SEV1 work is diagnostic-only for the agent.

## Contributing

Use conventional commits and run local checks before opening a pull request:

```bash
npx markdownlint-cli2 "**/*.md"
bash -n scripts/install.sh
```

For PowerShell syntax validation:

```powershell
$null = [System.Management.Automation.Language.Parser]::ParseFile(
  "scripts/install.ps1",
  [ref]$null,
  [ref]$null
)
```

## License and Attribution

This project is a public adaptation inspired by AWS AIDLC workflows and an
operations lifecycle for SRE and DevOps teams. Existing upstream license and
attribution files are preserved. See [LICENSE](LICENSE).
