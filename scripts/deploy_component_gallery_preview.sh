#!/usr/bin/env bash
# 部署组件总览到 Vercel，获得固定公网地址。
#
# 首次使用：
#   npx vercel login
#   bash scripts/deploy_component_gallery_preview.sh
#
# 默认固定地址：
#   https://diandian-component-gallery.vercel.app
#
# 可选：
#   PREVIEW_PROJECT=my-gallery bash scripts/deploy_component_gallery_preview.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="${PREVIEW_PROJECT:-diandian-component-gallery}"
MAIN="lib/previews/component_gallery_preview_main.dart"

cd "$ROOT"

echo ">> Building Flutter Web component gallery ($MAIN)..."
flutter build web -t "$MAIN" --release

echo ">> Deploying component gallery to Vercel project: $PROJECT"
npx -y vercel deploy build/web \
  --prod \
  --yes \
  --name "$PROJECT"

echo ""
echo ">> 组件总览部署完成，固定预览地址："
echo "   https://${PROJECT}.vercel.app"
