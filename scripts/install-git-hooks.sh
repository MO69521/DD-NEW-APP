#!/usr/bin/env bash
#
# 安装项目 git hooks 到 .git/hooks/（不修改 git config，克隆后运行一次即可）。
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
hook="$repo_root/.git/hooks/pre-commit"

cat > "$hook" <<'EOF'
#!/usr/bin/env bash
# 委托到版本管理的检查脚本（docs 同步警告，不阻断）。
root="$(git rev-parse --show-toplevel)"
exec bash "$root/scripts/check-docs-sync.sh"
EOF

chmod +x "$hook"
echo "已安装 pre-commit hook -> $hook"
