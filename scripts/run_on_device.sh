#!/usr/bin/env bash
# 真机预览：自动处理 iCloud 构建目录，检测 iPhone / Android 并运行 App
#
# 用法：
#   bash scripts/run_on_device.sh
#   bash scripts/run_on_device.sh --wait          # 等待手机连接（最多 3 分钟）
#   MAIN=lib/previews/global_preview_main.dart bash scripts/run_on_device.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MAIN="${MAIN:-lib/main.dart}"
WAIT="${1:-}"
ADB="${ADB:-/opt/homebrew/share/android-commandlinetools/platform-tools/adb}"
IOS_BUILD_LINK="/tmp/diandian-chuanshu-build"

cd "$ROOT"

echo ">> 准备 iOS 构建目录（规避 iCloud codesign 问题）..."
rm -rf build/ios
mkdir -p "$IOS_BUILD_LINK"
ln -s "$IOS_BUILD_LINK" build/ios

pick_device() {
  flutter devices 2>/dev/null | awk '
    /•/ &&
    $0 !~ /simulator/ &&
    $0 !~ /macos/ &&
    $0 !~ /chrome/ {
      print
      exit
    }
  ' || true
}

wait_for_device() {
  local max=36 i=0
  echo ">> 等待手机连接（最多 3 分钟）..."
  echo ">> iPhone：数据线连接 Mac → 解锁 → 点「信任此电脑」"
  echo ">> Android：开启 USB 调试 → 数据线连接 → 允许调试"
  while [[ $i -lt $max ]]; do
    local line
    line="$(pick_device)"
    if [[ -n "$line" ]]; then
      echo ">> 已检测到设备: $line"
      return 0
    fi
    sleep 5
    i=$((i + 1))
    echo "   ...仍在等待 ($((i * 5))s)"
  done
  return 1
}

if [[ "$WAIT" == "--wait" ]]; then
  wait_for_device || {
    echo ""
    echo "ERROR: 未检测到真机。请连接手机后重试："
    echo "  bash scripts/run_on_device.sh --wait"
    exit 1
  }
fi

DEVICE_LINE="$(pick_device)"
if [[ -z "$DEVICE_LINE" ]]; then
  echo ""
  echo "当前未检测到真机，已连接设备："
  flutter devices
  echo ""
  echo "请连接手机后运行："
  echo "  bash scripts/run_on_device.sh --wait"
  exit 1
fi

DEVICE_ID="$(echo "$DEVICE_LINE" | awk -F'•' '{print $2}' | xargs)"
DEVICE_NAME="$(echo "$DEVICE_LINE" | awk -F'•' '{print $1}' | xargs)"

echo ">> 启动 App：$DEVICE_NAME ($MAIN)"
flutter run -d "$DEVICE_ID" -t "$MAIN"
