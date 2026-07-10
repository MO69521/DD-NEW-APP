#!/usr/bin/env bash
# 设计规范对照检查：检测本次改动是否在 token 层「新增」了规范外的值 / token。
# 收敛（把重复字面量指向已有 token，值不变）不会被判为新增；
# 真正新增字面量 / 新 token 才会被列出，需对照 design-system/README.md 并向用户确认。
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 0

THEME_GLOB='lib/core/theme'
SPEC='design-system/README.md'

YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; NC=$'\033[0m'

echo "=== 设计规范对照检查 ==="
if [ ! -f "$SPEC" ]; then
  echo "${RED}缺少规范文档 ${SPEC}${NC}"
  exit 1
fi

# 收集本次改动（工作区 + 暂存）中 theme 文件里「新增行(+)」引入的字面量 / 新 token。
diff_added() { git diff -U0 -- "$THEME_GLOB"; git diff -U0 --cached -- "$THEME_GLOB"; }

added="$(diff_added | rg '^\+' | rg -v '^\+\+\+' || true)"

flag=0

# 1) 新增的原始颜色字面量（core/theme 内允许定义 token，但新增 hex 需登记规范）
new_hex="$(printf '%s\n' "$added" | rg -o 'Color\(0x[0-9A-Fa-f]{8}\)' | sort -u || true)"
# 2) 新增的字号 / 行高数字字面量
new_fs="$(printf '%s\n' "$added" | rg -o 'fontSize:\s*[0-9.]+' | sort -u || true)"
new_h="$(printf '%s\n' "$added" | rg -o 'height:\s*[0-9.]+' | sort -u || true)"
# 3) 新增的 static const token 声明（名称）
new_tok="$(printf '%s\n' "$added" | rg -o 'static const \w+ [a-zA-Z0-9_]+' | awk '{print $4}' | sort -u || true)"

report() {
  local title="$1"; shift
  local body="$1"
  if [ -n "$body" ]; then
    flag=1
    echo "${YELLOW}$title${NC}"
    printf '%s\n' "$body" | sed 's/^/  /'
  fi
}

filter_undocumented_literals() {
  local values="$1"
  local missing=""
  while IFS= read -r value; do
    [ -z "$value" ] && continue
    local raw="$value"
    case "$value" in
      Color\(0x*\)) raw="${value#Color(}"; raw="${raw%)}" ;;
      fontSize:*) raw="$(printf '%s' "$value" | awk -F: '{gsub(/[[:space:]]/, "", $2); print $2}')" ;;
      height:*) raw="$(printf '%s' "$value" | awk -F: '{gsub(/[[:space:]]/, "", $2); print $2}')" ;;
    esac
    if ! rg -Fq "$value" "$SPEC" 2>/dev/null && ! rg -Fq "$raw" "$SPEC" 2>/dev/null; then
      missing="${missing}${value}"$'\n'
    fi
  done <<< "$values"
  printf '%s' "$missing"
}

filter_undocumented_tokens() {
  local tokens="$1"
  local missing=""
  while IFS= read -r token; do
    [ -z "$token" ] && continue
    if rg -q "(^|[^A-Za-z0-9_])${token}([^A-Za-z0-9_]|$)" "$SPEC" 2>/dev/null; then
      :
    else
      missing="${missing}${token}"$'\n'
    fi
  done <<< "$tokens"
  printf '%s' "$missing"
}

undoc_hex="$(filter_undocumented_literals "$new_hex")"
undoc_fs="$(filter_undocumented_literals "$new_fs")"
undoc_h="$(filter_undocumented_literals "$new_h")"
undoc_tok="$(filter_undocumented_tokens "$new_tok")"

report "新增颜色字面量未登记（需对照规范 §4，超出请先询问用户）：" "$undoc_hex"
report "新增字号字面量未登记（需对照规范 §1，超出请先询问用户）：" "$undoc_fs"
report "新增行高字面量未登记（需对照规范 §2，超出请先询问用户）：" "$undoc_h"
report "新增 token 未登记（确认是否属于规范内收敛，还是需登记）：" "$undoc_tok"

echo "=== 小结 ==="
if [ "$flag" -eq 0 ]; then
  echo "${GREEN}未检测到规范外新增：无需额外确认${NC}"
  exit 0
fi
echo "${YELLOW}检测到未登记 token / 字面量：请对照 ${SPEC} ，若超出规范先向用户说明并取得确认，再更新规范文档${NC}"
exit 2
