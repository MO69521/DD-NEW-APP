#!/usr/bin/env bash
# 组件总览 Web 预览：构建真实 Flutter Web 页面，并通过公网隧道分享给团队。
#
# 用法：
#   bash scripts/preview_component_gallery_web.sh
#
# 可选：
#   PREVIEW_PORT=8766 bash scripts/preview_component_gallery_web.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"

PREVIEW_MAIN="lib/previews/component_gallery_preview_main.dart" \
PREVIEW_PORT="${PREVIEW_PORT:-8766}" \
bash scripts/preview_global.sh
