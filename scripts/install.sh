#!/usr/bin/env bash
set -euo pipefail

AGENT="all"
TARGET="."
SOURCE="local"
VERSION="latest"
FORCE="false"
DRY_RUN="false"
COPIED_DETAILS=""

usage() {
  cat <<'EOF'
AIDLC Operations installer

Usage:
  scripts/install.sh [options]

Options:
  --agent kiro|claude|codex|antigravity|cursor|all
  --target <path>
  --source local|release
  --version latest|vX.Y.Z
  --force
  --dry-run
  -h, --help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --agent) AGENT="${2:?missing value for --agent}"; shift 2 ;;
    --target) TARGET="${2:?missing value for --target}"; shift 2 ;;
    --source) SOURCE="${2:?missing value for --source}"; shift 2 ;;
    --version) VERSION="${2:?missing value for --version}"; shift 2 ;;
    --force) FORCE="true"; shift ;;
    --dry-run) DRY_RUN="true"; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
done

case "$AGENT" in
  kiro|claude|codex|antigravity|cursor|all) ;;
  *) echo "Invalid --agent: $AGENT" >&2; exit 2 ;;
esac

case "$SOURCE" in
  local|release) ;;
  *) echo "Invalid --source: $SOURCE" >&2; exit 2 ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$(cd "$TARGET" && pwd)"
WORK_DIR=""

log() { printf '%s\n' "$*"; }

run() {
  if [[ "$DRY_RUN" == "true" ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

prepare_source() {
  if [[ "$SOURCE" == "local" ]]; then
    RULES_DIR="$REPO_ROOT/aidlc-rules"
    return
  fi

  WORK_DIR="$(mktemp -d)"
  trap '[[ -n "$WORK_DIR" ]] && rm -rf "$WORK_DIR"' EXIT

  local api_url asset_url zip_path release_repo
  release_repo="${AIDLC_RELEASE_REPO:-victor-dias21/aidlc-workflows}"
  if [[ "$VERSION" == "latest" ]]; then
    api_url="https://api.github.com/repos/${release_repo}/releases/latest"
  else
    api_url="https://api.github.com/repos/${release_repo}/releases/tags/${VERSION}"
  fi

  asset_url="$(curl -fsSL "$api_url" | grep -Eo 'https://[^"]*aidlc-rules-v[^"]*\.zip' | head -n 1 || true)"
  if [[ -z "$asset_url" ]]; then
    echo "Could not find aidlc-rules zip in release metadata: $api_url" >&2
    exit 1
  fi

  zip_path="$WORK_DIR/aidlc-rules.zip"
  curl -fsSL "$asset_url" -o "$zip_path"
  unzip -q "$zip_path" -d "$WORK_DIR"
  RULES_DIR="$WORK_DIR/aidlc-rules"
}

ensure_write_target() {
  local path="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    return
  fi
  if [[ -e "$path" && "$FORCE" != "true" ]]; then
    echo "Refusing to overwrite existing path without --force: $path" >&2
    exit 1
  fi
}

copy_details() {
  local dest="$1"
  if [[ ",$COPIED_DETAILS," == *",$dest,"* ]]; then
    return
  fi
  ensure_write_target "$dest"
  run mkdir -p "$(dirname "$dest")"
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] copy $RULES_DIR/aws-aidlc-rule-details -> $dest"
  else
    rm -rf "$dest"
    cp -R "$RULES_DIR/aws-aidlc-rule-details" "$dest"
  fi
  COPIED_DETAILS="${COPIED_DETAILS},${dest}"
}

write_with_core() {
  local file="$1"
  local prefix="$2"
  ensure_write_target "$file"
  local parent
  parent="$(dirname "$file")"
  if [[ "$parent" != "." ]]; then
    run mkdir -p "$parent"
  fi
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] write $file from core workflow"
  else
    {
      printf '%s\n\n' "$prefix"
      cat "$RULES_DIR/aws-aidlc-rules/core-workflow.md"
    } > "$file"
  fi
}

install_kiro() {
  log "Installing AIDLC Operations for Kiro..."
  local rules_dest="$TARGET/.kiro/steering/aws-aidlc-rules"
  local details_dest="$TARGET/.kiro/aws-aidlc-rule-details"
  ensure_write_target "$rules_dest"
  run mkdir -p "$TARGET/.kiro/steering"
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] copy $RULES_DIR/aws-aidlc-rules -> $rules_dest"
  else
    rm -rf "$rules_dest"
    cp -R "$RULES_DIR/aws-aidlc-rules" "$rules_dest"
  fi
  copy_details "$details_dest"
}

install_claude() {
  log "Installing AIDLC Operations for Claude Code..."
  write_with_core "$TARGET/CLAUDE.md" "# AIDLC Operations project memory"
  copy_details "$TARGET/.aidlc-rule-details"
}

install_codex() {
  log "Installing AIDLC Operations for Codex..."
  write_with_core "$TARGET/AGENTS.md" "# AIDLC Operations agent instructions"
  copy_details "$TARGET/.aidlc-rule-details"
}

install_cursor() {
  log "Installing AIDLC Operations for Cursor..."
  write_with_core "$TARGET/.cursor/rules/aidlc-workflow.mdc" "---
description: \"AIDLC Operations workflow for cloud, DevOps, infrastructure, and SRE work\"
alwaysApply: true
---"
  copy_details "$TARGET/.aidlc-rule-details"
}

install_antigravity() {
  log "Installing AIDLC Operations for Antigravity..."
  write_with_core "$TARGET/.agents/agents.md" "# AIDLC Operations agent instructions"
  run mkdir -p "$TARGET/.agents/skills" "$TARGET/.agents/workflows"
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] write Antigravity skill and workflow pointers"
  else
    cat > "$TARGET/.agents/skills/aidlc-operations.md" <<'EOF'
# AIDLC Operations Skill

Use `.agents/agents.md` as the entry point and load `.aidlc-rule-details/`
according to the AIDLC Operations workflow.
EOF
    cat > "$TARGET/.agents/workflows/aidlc-operations.md" <<'EOF'
# AIDLC Operations Workflow

Follow Gather Context -> Pre-flight -> Plan -> Execute -> Validate/Learn.
EOF
  fi
  copy_details "$TARGET/.aidlc-rule-details"
}

prepare_source

if [[ ! -d "$RULES_DIR/aws-aidlc-rules" || ! -d "$RULES_DIR/aws-aidlc-rule-details" ]]; then
  echo "Rules source is incomplete: $RULES_DIR" >&2
  exit 1
fi

case "$AGENT" in
  kiro) install_kiro ;;
  claude) install_claude ;;
  codex) install_codex ;;
  cursor) install_cursor ;;
  antigravity) install_antigravity ;;
  all)
    install_kiro
    install_claude
    install_codex
    install_cursor
    install_antigravity
    ;;
esac

log "AIDLC Operations installation complete."
