#!/usr/bin/env bash
# Flutter STRICT V2 post-edit audit — scans changed Dart files for common violations.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

issues=0
warnings=0

collect_changed_files() {
  {
    git diff --name-only --diff-filter=ACMR 2>/dev/null || true
    git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
  } | rg '\.dart$' 2>/dev/null | sort -u || true
}

collect_changed_all_files() {
  {
    git diff --name-only --diff-filter=ACMR 2>/dev/null || true
    git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true
  } | sort -u || true
}

has_changed_match() {
  local pattern="$1"
  printf '%s\n' "$CHANGED_ALL_FILES" | rg -q "$pattern" 2>/dev/null
}

CHANGED_FILES="$(collect_changed_files)"
CHANGED_ALL_FILES="$(collect_changed_all_files)"

if [ -z "$CHANGED_ALL_FILES" ]; then
  echo -e "${YELLOW}No changed files detected. Audit skipped.${NC}"
  exit 0
fi

echo "=== Flutter Post-Edit Audit ==="
echo "Changed files:"
echo "$CHANGED_ALL_FILES" | sed 's/^/  /'
echo ""

report_issue() {
  echo -e "${RED}ISSUE:${NC} $1"
  issues=$((issues + 1))
}

report_warning() {
  echo -e "${YELLOW}WARN:${NC} $1"
  warnings=$((warnings + 1))
}

run_required_check() {
  local title="$1"
  local command="$2"
  echo ""
  echo "--- $title ---"
  set +e
  bash -c "$command"
  local code=$?
  set -e
  if [ "$code" -ne 0 ]; then
    report_issue "$title failed (exit $code)"
  fi
}

# --- 1. Hardcoded styles in non-theme UI files ---
echo "--- Token / hardcoded style check ---"
if [ -z "$CHANGED_FILES" ]; then
  echo "No changed Dart files detected."
else
  while IFS= read -r file; do
    [ -f "$file" ] || continue
    case "$file" in
      lib/core/theme/*) continue ;;
    esac
    case "$file" in
      lib/features/*/presentation/*|lib/shared/*|lib/routes/*)
        if rg -n "Color\(0x" "$file" 2>/dev/null; then
          report_issue "$file: hardcoded Color(0x...) — use AppColors"
        fi
        if rg -n "fontSize:\s*[0-9]" "$file" 2>/dev/null; then
          report_issue "$file: hardcoded fontSize — use AppTextStyles"
        fi
        if rg -n "EdgeInsets\.(all|symmetric|only)\(\s*[0-9]" "$file" 2>/dev/null; then
          report_issue "$file: hardcoded EdgeInsets — use AppSpacing"
        fi
        if rg -n "BorderRadius\.circular\(\s*[0-9]" "$file" 2>/dev/null; then
          report_issue "$file: hardcoded BorderRadius — use AppRadius"
        fi
        ;;
    esac
  done <<< "$CHANGED_FILES"
fi

# --- 2. New tokens added ---
echo ""
echo "--- New design token check ---"
TOKEN_FILES=""
while IFS= read -r file; do
  case "$file" in
    lib/core/theme/app_*.dart)
      TOKEN_FILES="$TOKEN_FILES$file\n"
      if git diff -U0 -- "$file" 2>/dev/null | rg '^\+' | rg -v '^\+\+\+' | rg 'static const' >/dev/null 2>&1; then
        report_warning "$file: new static const token(s) added — confirm naming & reuse"
        git diff -U0 -- "$file" 2>/dev/null | rg '^\+.*static const' || true
      fi
      ;;
  esac
done <<< "$CHANGED_FILES"

# --- 2.5 Design-system authority gates ---
if has_changed_match '^lib/core/theme/' || has_changed_match '^design-system/'; then
  run_required_check "Design-system token check" ".cursor/skills/flutter-post-edit-audit/scripts/design-system-check.sh"
fi

if has_changed_match '^design-system/'; then
  run_required_check "Design-system consistency check" ".cursor/skills/flutter-post-edit-audit/scripts/design-system-consistency.sh"
fi

# --- 3. Cross-feature imports ---
echo ""
echo "--- Cross-feature dependency check ---"
while IFS= read -r file; do
  [ -f "$file" ] || continue
  case "$file" in
    lib/features/*)
      if rg -n "import .*/features/[^/]+/(data|application)/" "$file" 2>/dev/null; then
        report_issue "$file: cross-feature import of data/application layer"
      fi
      ;;
  esac
done <<< "$CHANGED_FILES"

# --- 4. Domain layer purity ---
echo ""
echo "--- Domain layer purity ---"
while IFS= read -r file; do
  case "$file" in
    lib/features/*/domain/*)
      if rg -n "import 'package:flutter" "$file" 2>/dev/null; then
        report_issue "$file: domain layer imports Flutter"
      fi
      if rg -n "import 'package:http" "$file" 2>/dev/null; then
        report_issue "$file: domain layer imports http"
      fi
      ;;
  esac
done <<< "$CHANGED_FILES"

# --- 5. Navigator direct usage ---
echo ""
echo "--- Routing check ---"
while IFS= read -r file; do
  [ -f "$file" ] || continue
  case "$file" in
    lib/routes/app_router.dart) continue ;;
    lib/features/*/presentation/*|lib/shared/*)
      if rg -n "Navigator\.(push|pop)\(" "$file" 2>/dev/null; then
        report_issue "$file: direct Navigator usage — use AppRouter"
      fi
      ;;
  esac
done <<< "$CHANGED_FILES"

# --- 6. Status bar inset (§3.1) ---
echo ""
echo "--- Status bar inset check (§3.1) ---"
while IFS= read -r file; do
  [ -f "$file" ] || continue
  case "$file" in
    lib/features/*/presentation/pages/*|lib/features/*/presentation/pages/*)
      if rg -q "AppTopBar\(" "$file" 2>/dev/null; then
        if ! rg -q "statusBarHeight" "$file" 2>/dev/null; then
          report_issue "$file: AppTopBar without statusBarHeight — see §3.1"
        elif rg -n "statusBarHeight\s*=\s*MediaQuery\.paddingOf\(context\)\.top\s*;" "$file" 2>/dev/null; then
          report_issue "$file: statusBarHeight must use AppLayout.statusBarHeight — see §3.1"
        elif rg -q "statusBarHeight:\s*MediaQuery\.paddingOf\(context\)\.top" "$file" 2>/dev/null; then
          report_issue "$file: inline statusBarHeight must use AppLayout.statusBarHeight — see §3.1"
        elif rg -q "AppLayout\.statusBarHeight" "$file" 2>/dev/null; then
          :
        elif rg -q "statusBarPlaceholderHeight" "$file" 2>/dev/null || \
             rg -q "topInset > 0" "$file" 2>/dev/null; then
          report_issue "$file: use AppLayout.statusBarHeight(context) instead of inline fallback — see §3.1"
        elif rg -q "statusBarHeight" "$file" 2>/dev/null; then
          report_warning "$file: statusBarHeight present — manually confirm §3.1 placeholder fallback"
        fi
      fi
      ;;
  esac
done <<< "$CHANGED_FILES"

# --- 7. File size ---
# 例外：token registry（扁平数据单一真源，非 widget/逻辑复杂度）经确认豁免 §11。
echo ""
echo "--- File size check ---"
while IFS= read -r file; do
  [ -f "$file" ] || continue
  case "$file" in
    lib/core/theme/app_sizes.dart|lib/core/theme/app_text_styles.dart) continue ;;
  esac
  lines=$(wc -l < "$file" | tr -d ' ')
  if [ "$lines" -gt 300 ]; then
    report_warning "$file: $lines lines (> 300) — consider splitting"
  fi
done <<< "$CHANGED_FILES"

echo ""
echo "=== Summary ==="
if [ "$issues" -eq 0 ] && [ "$warnings" -eq 0 ]; then
  echo -e "${GREEN}PASS${NC} — no issues or warnings"
  exit 0
elif [ "$issues" -eq 0 ]; then
  echo -e "${YELLOW}PASS WITH WARNINGS${NC} — $warnings warning(s), 0 issue(s)"
  exit 0
else
  echo -e "${RED}FAIL${NC} — $issues issue(s), $warnings warning(s)"
  exit 1
fi
