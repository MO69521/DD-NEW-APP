#!/usr/bin/env bash
# 一次性配置：创建 Vercel 预览项目，并输出 GitHub Actions 所需的 Secrets。
#
# 用法：
#   bash scripts/setup_vercel_ci.sh
#
# 完成后到 GitHub 仓库 → Settings → Secrets and variables → Actions → New repository secret
# 添加以下三个 secret，之后 push 到 main 会自动部署预览。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${PREVIEW_PROJECT:-diandian-preview}"
MAIN="${PREVIEW_MAIN:-lib/previews/global_preview_main.dart}"

cd "$ROOT"

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: 未找到 flutter，请先安装 Flutter SDK。"
  exit 1
fi

echo ">> Step 1/3: 登录 Vercel（浏览器会打开）"
npx -y vercel login

echo ""
echo ">> Step 2/3: 构建并创建/更新 Vercel 项目: $PROJECT"
flutter build web -t "$MAIN" --release
npx -y vercel deploy build/web --prod --yes --name "$PROJECT"

echo ""
echo ">> Step 3/3: 关联项目并读取 ID"
rm -rf build/web/.vercel
npx -y vercel link build/web --yes --project "$PROJECT"

PROJECT_JSON="build/web/.vercel/project.json"
if [[ ! -f "$PROJECT_JSON" ]]; then
  echo "ERROR: 未找到 $PROJECT_JSON，请检查 vercel link 是否成功。"
  exit 1
fi

ORG_ID="$(python3 -c "import json; print(json.load(open('$PROJECT_JSON'))['orgId'])")"
PROJECT_ID="$(python3 -c "import json; print(json.load(open('$PROJECT_JSON'))['projectId'])")"

echo ""
echo "============================================================"
echo "  请打开 GitHub 仓库 → Settings → Secrets and variables"
echo "  → Actions → New repository secret，添加以下 3 项："
echo "============================================================"
echo ""
echo "  VERCEL_ORG_ID"
echo "  $ORG_ID"
echo ""
echo "  VERCEL_PROJECT_ID"
echo "  $PROJECT_ID"
echo ""
echo "  VERCEL_TOKEN"
echo "  在 https://vercel.com/account/tokens 创建（Full Account 或 Deploy 权限）"
echo ""
echo "============================================================"
echo "  配置完成后，push 到 main 分支会自动部署到："
echo "  https://${PROJECT}.vercel.app"
echo "============================================================"
