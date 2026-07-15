#!/usr/bin/env bash
# 开发期主题预览：把工作区同步到非 iCloud 临时目录，再按指定主题包在 iOS 模拟器运行。
# 规避 iCloud 路径下 com.apple.provenance 导致的 codesign 失败
# （见 .cursor/rules/icloud-ios-simulator-workflow.mdc）。
#
# 用法：
#   scripts/run-sim.sh [theme] [device-id]
#     theme     : yellow_dark(默认) | pink_light | yellow_light
#     device-id : 可选；缺省自动选已启动的 iOS 模拟器，没有则由 flutter 选择
#
# 示例：
#   scripts/run-sim.sh pink_light
#   scripts/run-sim.sh yellow_light
#   scripts/run-sim.sh yellow_dark 08021E39-F157-426E-B3DC-2BB800DA287F
set -euo pipefail

THEME="${1:-yellow_dark}"
DEVICE="${2:-}"

case "$THEME" in
  yellow_dark | pink_light | yellow_light) ;;
  *)
    echo "未知主题：${THEME}（可选：yellow_dark | pink_light | yellow_light）" >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$(cd "$SCRIPT_DIR/.." && pwd)"
PREVIEW="/tmp/diandian-sim-preview"

# 未指定设备时，自动选取第一个已启动的模拟器。
if [ -z "$DEVICE" ]; then
  DEVICE="$(xcrun simctl list devices booted 2>/dev/null \
    | grep -oE '[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}' \
    | head -1 || true)"
fi

echo "▶ 同步工作区 → ${PREVIEW}（排除 .git / build / .dart_tool）"
rm -rf "$PREVIEW"
rsync -a --exclude='.git' --exclude='build' --exclude='.dart_tool' \
  "$WORKSPACE/" "$PREVIEW/"

cd "$PREVIEW"
echo "▶ flutter run  THEME=${THEME}${DEVICE:+  device=${DEVICE}}"
if [ -n "$DEVICE" ]; then
  exec flutter run -d "$DEVICE" --dart-define=THEME="$THEME"
else
  exec flutter run --dart-define=THEME="$THEME"
fi
