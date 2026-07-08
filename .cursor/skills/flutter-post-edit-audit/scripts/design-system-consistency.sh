#!/usr/bin/env bash
# 设计规范一致性检查（§0.1 三处一致）：
#   1) README.md 与 canvas 源文件均存在；
#   2) canvas 源文件 与 Cursor 托管渲染副本内容一致（不一致需运行 sync-canvas.sh）；
#   3) canvas 中登记的组件源码路径（src="lib/...")在仓库中真实存在。
# 退出码：0 通过；2 检测到不一致 / 缺失，需处理。
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 0

README="design-system/README.md"
CANVAS="design-system/design-system-spec.canvas.tsx"

YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; NC=$'\033[0m'
flag=0

echo "=== 设计规范一致性检查（§0.1）==="

for f in "$README" "$CANVAS"; do
  if [ ! -f "$f" ]; then
    echo "${RED}缺少权威文件：$f${NC}"; flag=1
  fi
done
[ "$flag" -eq 1 ] && { echo "=== 需修复 ==="; exit 2; }

# 2) 源 ↔ 托管副本一致性
echo "--- 源文件 ↔ 托管渲染副本 ---"
found=0
while IFS= read -r dst; do
  [ -z "$dst" ] && continue
  found=$((found + 1))
  if diff -q "$CANVAS" "$dst" >/dev/null 2>&1; then
    echo "${GREEN}✓ 一致${NC} $dst"
  else
    echo "${YELLOW}✗ 不一致${NC} $dst → 运行 scripts/sync-canvas.sh"
    flag=1
  fi
done < <(find "$HOME/.cursor/projects" -type f \
           -path '*/canvases/design-system-spec.canvas.tsx' 2>/dev/null)
[ "$found" -eq 0 ] && echo "${YELLOW}未发现托管副本（尚未在 Cursor 打开过预览）${NC}"

# 3) canvas 登记的组件源码路径存在性
echo "--- 组件源码路径存在性（canvas src="...")---"
missing=0
while IFS= read -r p; do
  [ -z "$p" ] && continue
  if [ ! -f "$p" ]; then
    echo "${RED}✗ 源码路径不存在：$p${NC}"; missing=$((missing + 1)); flag=1
  fi
done < <(rg -o 'src="(lib/[^"]+)"' -r '$1' "$CANVAS" 2>/dev/null | sort -u)
[ "$missing" -eq 0 ] && echo "${GREEN}✓ 全部存在${NC}"

echo "=== 小结 ==="
if [ "$flag" -eq 0 ]; then
  echo "${GREEN}设计规范三处一致，组件源码路径有效${NC}"; exit 0
fi
echo "${YELLOW}检测到不一致 / 缺失，请按上文处理后重跑${NC}"; exit 2
