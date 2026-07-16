#!/usr/bin/env bash
# Run the repository post-edit audit at the end of each agent iteration.
# The audit itself skips clean iterations and limits checks to changed files.
set -uo pipefail

# Cursor sends hook metadata on stdin; this hook does not need it.
cat >/dev/null 2>&1 || true

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

AUDIT="$ROOT/.cursor/skills/flutter-post-edit-audit/scripts/audit.sh"

if [ ! -f "$AUDIT" ]; then
  echo "[post-edit-audit] missing: $AUDIT" >&2
  exit 1
fi

echo "[post-edit-audit] running flutter-post-edit-audit"
bash "$AUDIT"
