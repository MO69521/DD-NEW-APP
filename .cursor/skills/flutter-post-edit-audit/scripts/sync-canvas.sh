#!/usr/bin/env bash
# 将设计规范可视化源文件同步到 Cursor 托管渲染副本。
#
# 背景：design-system/design-system-spec.canvas.tsx 是随仓库版本管理的「源文件」；
# 但真正在 Cursor 里实时渲染预览的是托管副本
#   ~/.cursor/projects/<mangled-workspace>/canvases/design-system-spec.canvas.tsx
# 两者不同步时，改了源文件预览却不更新（曾出现「我怎么没看到」问题）。
#
# 本脚本自动查找所有托管副本并用源文件覆盖，保证三处一致（§0.1）。
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SRC="$ROOT/design-system/design-system-spec.canvas.tsx"

YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; NC=$'\033[0m'

echo "=== 同步可视化文档到托管渲染副本 ==="

if [ ! -f "$SRC" ]; then
  echo "${RED}未找到源文件：$SRC${NC}"
  exit 1
fi

count=0
while IFS= read -r dst; do
  [ -z "$dst" ] && continue
  cp "$SRC" "$dst"
  echo "${GREEN}✓ 已同步${NC} $dst"
  count=$((count + 1))
done < <(find "$HOME/.cursor/projects" -type f \
           -path '*/canvases/design-system-spec.canvas.tsx' 2>/dev/null)

if [ "$count" -eq 0 ]; then
  echo "${YELLOW}未找到托管副本（可能尚未在 Cursor 打开过该 canvas）。${NC}"
  echo "${YELLOW}首次预览时 Cursor 会在托管目录生成副本，之后重跑本脚本即可。${NC}"
  exit 0
fi

echo "=== 完成：同步 $count 处 ==="
exit 0
