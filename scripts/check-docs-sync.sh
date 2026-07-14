#!/usr/bin/env bash
#
# 提交前文档同步检查（警告式，不阻断提交）。
# 规则来源：.cursor/rules/docs-sync.mdc
#
# 当本次暂存改动包含 lib/ 下 .dart 文件，但未同步任何 docs/ 文档时，打印提醒。
# 纯重构 / bugfix 等确实无需改文档的提交可忽略本提醒。
#
# 安装（每次克隆仓库后执行一次；无需改 git config）：
#   bash scripts/install-git-hooks.sh
# 或手动：
#   ln -sf ../../scripts/check-docs-sync.sh .git/hooks/pre-commit  # 需可执行

set -euo pipefail

staged="$(git diff --cached --name-only || true)"
lib_changed="$(printf '%s\n' "$staged" | grep -E '^lib/.*\.dart$' || true)"
docs_changed="$(printf '%s\n' "$staged" | grep -E '^docs/' || true)"

if [ -n "$lib_changed" ] && [ -z "$docs_changed" ]; then
  echo ""
  echo "[docs-sync] 提醒：本次提交改动了 lib/ 但未同步 docs/。"
  echo "  按 .cursor/rules/docs-sync.mdc 更新受影响编号文档并追加 docs/CHANGELOG.md："
  echo "    改页面 -> 06_Pages   改组件 -> 05_Components   改主题/token -> 03_Theme + 04_DesignToken"
  echo "    改接口/datasource -> 07_DataFlow + 08_API   改资源 -> 09_Assets   改动画 -> 10_Animation"
  echo "    改目录结构 -> 02_ProjectStructure   任意改动 -> 追加 CHANGELOG"
  echo "  若本次为纯重构 / bugfix 无需改文档，可忽略本提醒。"
  echo ""
fi

# 警告式：永远放行提交。
exit 0
