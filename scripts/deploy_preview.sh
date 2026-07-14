#!/usr/bin/env bash
# 部署全局预览到 Vercel，获得固定公网地址（如 https://diandian-preview.vercel.app）
#
# 首次使用：
#   1. npx vercel login          # 浏览器登录 Vercel 账号（免费）
#   2. bash scripts/deploy_preview.sh
#
# 之后每次更新预览，重新运行本脚本即可，URL 不变。
# 或 push 到 main 后由 GitHub Actions 自动部署（需先运行 setup_vercel_ci.sh 配置 Secrets）。
#
# 环境变量（可选）：
#   PREVIEW_PROJECT=diandian-preview   固定项目名 → 固定 *.vercel.app 域名
#   PREVIEW_MAIN=lib/previews/global_preview_main.dart
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${PREVIEW_PROJECT:-diandian-preview}"
MAIN="${PREVIEW_MAIN:-lib/previews/global_preview_main.dart}"

cd "$ROOT"

echo ">> Building Flutter Web ($MAIN)..."
flutter build web -t "$MAIN" --release

echo ">> Deploying to Vercel project: $PROJECT"
echo ">> (首次会提示关联账号/团队，选默认即可)"
npx -y vercel deploy build/web \
  --prod \
  --yes \
  --name "$PROJECT"

echo ""
echo ">> 部署完成！固定预览地址："
echo "   https://${PROJECT}.vercel.app"
echo ""
echo "常用直达："
echo "   我的页     https://${PROJECT}.vercel.app/?tab=4"
echo "   书架·历史  https://${PROJECT}.vercel.app/?tab=3&bookshelfTab=history"
echo "   设置       https://${PROJECT}.vercel.app/?route=/settings"
