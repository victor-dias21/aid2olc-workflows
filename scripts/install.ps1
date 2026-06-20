[CmdletBinding()]
param(
    [ValidateSet("kiro", "claude", "codex", "antigravity", "cursor", "all")]
    [string]$Agent = "all",

    [string]$Target = ".",

    [ValidateSet("local", "release")]
    [string]$Source = "local",

    [string]$Version = "latest",

    [switch]$Force,

    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$script:CopiedDetails = @{}

function Write-Step {
    param([string]$Message)
    Write-Host $Message
}

function Invoke-Step {
    param(
        [scriptblock]$Action,
        [string]$Description
    )
    if ($DryRun) {
        Write-Host "[dry-run] $Description"
    } else {
        & $Action
    }
}

function Assert-CanWrite {
    param([string]$Path)
    if ($DryRun) {
        return
    }
    if ((Test-Path -LiteralPath $Path) -and -not $Force) {
        throw "Refusing to overwrite existing path without -Force: $Path"
    }
}

function Copy-DirectoryFresh {
    param(
        [string]$SourcePath,
        [string]$DestinationPath
    )
    Assert-CanWrite $DestinationPath
    Invoke-Step {
        $parent = Split-Path -Parent $DestinationPath
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        if (Test-Path -LiteralPath $DestinationPath) {
            Remove-Item -LiteralPath $DestinationPath -Recurse -Force
        }
        Copy-Item -LiteralPath $SourcePath -Destination $DestinationPath -Recurse
    } "copy $SourcePath -> $DestinationPath"
}

function Copy-Details {
    param([string]$DestinationPath)
    if ($script:CopiedDetails.ContainsKey($DestinationPath)) {
        return
    }
    Copy-DirectoryFresh (Join-Path $script:RulesDir "aws-aidlc-rule-details") $DestinationPath
    $script:CopiedDetails[$DestinationPath] = $true
}

function Write-CoreFile {
    param(
        [string]$DestinationPath,
        [string]$Prefix
    )
    Assert-CanWrite $DestinationPath
    Invoke-Step {
        $parent = Split-Path -Parent $DestinationPath
        if ($parent) {
            New-Item -ItemType Directory -Force -Path $parent | Out-Null
        }
        $core = Get-Content -Raw -LiteralPath (Join-Path $script:RulesDir "aws-aidlc-rules/core-workflow.md")
        "$Prefix`n`n$core" | Set-Content -LiteralPath $DestinationPath -Encoding utf8
    } "write $DestinationPath from core workflow"
}

function Initialize-RulesSource {
    $scriptDir = Split-Path -Parent $PSCommandPath
    $repoRoot = Split-Path -Parent $scriptDir
    if ($Source -eq "local") {
        $script:RulesDir = Join-Path $repoRoot "aidlc-rules"
        return
    }

    $workDir = Join-Path ([System.IO.Path]::GetTempPath()) ("aidlc-rules-" + [System.Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $workDir | Out-Null
    $releaseRepo = if ($env:AIDLC_RELEASE_REPO) { $env:AIDLC_RELEASE_REPO } else { "victor-dias21/aidlc-workflows" }
    $apiUrl = if ($Version -eq "latest") {
        "https://api.github.com/repos/$releaseRepo/releases/latest"
    } else {
        "https://api.github.com/repos/$releaseRepo/releases/tags/$Version"
    }
    $release = Invoke-RestMethod -Uri $apiUrl
    $asset = $release.assets | Where-Object { $_.name -match '^aidlc-rules-v.*\.zip$' } | Select-Object -First 1
    if (-not $asset) {
        throw "Could not find aidlc-rules zip in release metadata: $apiUrl"
    }
    $zipPath = Join-Path $workDir "aidlc-rules.zip"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath
    Expand-Archive -LiteralPath $zipPath -DestinationPath $workDir -Force
    $script:RulesDir = Join-Path $workDir "aidlc-rules"
}

function Install-Kiro {
    Write-Step "Installing AIDLC Operations for Kiro..."
    Copy-DirectoryFresh (Join-Path $script:RulesDir "aws-aidlc-rules") (Join-Path $script:TargetPath ".kiro/steering/aws-aidlc-rules")
    Copy-Details (Join-Path $script:TargetPath ".kiro/aws-aidlc-rule-details")
}

function Install-Claude {
    Write-Step "Installing AIDLC Operations for Claude Code..."
    Write-CoreFile (Join-Path $script:TargetPath "CLAUDE.md") "# AIDLC Operations project memory"
    Copy-Details (Join-Path $script:TargetPath ".aidlc-rule-details")
}

function Install-Codex {
    Write-Step "Installing AIDLC Operations for Codex..."
    Write-CoreFile (Join-Path $script:TargetPath "AGENTS.md") "# AIDLC Operations agent instructions"
    Copy-Details (Join-Path $script:TargetPath ".aidlc-rule-details")
}

function Install-Cursor {
    Write-Step "Installing AIDLC Operations for Cursor..."
    $prefix = @"
---
description: "AIDLC Operations workflow for cloud, DevOps, infrastructure, and SRE work"
alwaysApply: true
---
"@
    Write-CoreFile (Join-Path $script:TargetPath ".cursor/rules/aidlc-workflow.mdc") $prefix
    Copy-Details (Join-Path $script:TargetPath ".aidlc-rule-details")
}

function Install-Antigravity {
    Write-Step "Installing AIDLC Operations for Antigravity..."
    Write-CoreFile (Join-Path $script:TargetPath ".agents/agents.md") "# AIDLC Operations agent instructions"
    Invoke-Step {
        New-Item -ItemType Directory -Force -Path (Join-Path $script:TargetPath ".agents/skills") | Out-Null
        New-Item -ItemType Directory -Force -Path (Join-Path $script:TargetPath ".agents/workflows") | Out-Null
        "# AIDLC Operations Skill`n`nUse .agents/agents.md as the entry point and load .aidlc-rule-details/." |
            Set-Content -LiteralPath (Join-Path $script:TargetPath ".agents/skills/aidlc-operations.md") -Encoding utf8
        "# AIDLC Operations Workflow`n`nFollow Gather Context -> Pre-flight -> Plan -> Execute -> Validate/Learn." |
            Set-Content -LiteralPath (Join-Path $script:TargetPath ".agents/workflows/aidlc-operations.md") -Encoding utf8
    } "write Antigravity skill and workflow pointers"
    Copy-Details (Join-Path $script:TargetPath ".aidlc-rule-details")
}

Initialize-RulesSource
$script:TargetPath = (Resolve-Path -LiteralPath $Target).Path

if (-not (Test-Path -LiteralPath (Join-Path $script:RulesDir "aws-aidlc-rules"))) {
    throw "Rules source is incomplete: $script:RulesDir"
}

switch ($Agent) {
    "kiro" { Install-Kiro }
    "claude" { Install-Claude }
    "codex" { Install-Codex }
    "cursor" { Install-Cursor }
    "antigravity" { Install-Antigravity }
    "all" {
        Install-Kiro
        Install-Claude
        Install-Codex
        Install-Cursor
        Install-Antigravity
    }
}

Write-Step "AIDLC Operations installation complete."
