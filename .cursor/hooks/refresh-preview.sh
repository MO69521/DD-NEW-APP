#!/bin/bash
# 每次 agent 完成一轮修改后：把工作区（iCloud 路径）同步到非 iCloud 预览副本，
# 并热重载/热重启正在运行的 iOS 模拟器预览。
#
# - 仅当预览副本目录与正在运行的 `flutter run` 进程都存在时才动作，否则静默跳过。
# - 无文件变更时不触发刷新。
# - 涉及 pubspec / 资源文件（图片、字体、SVG 等）→ 热重启（重新打包资源）；
#   其余（Dart 代码）→ 热重载（更快）。
set -u

# 丢弃 stdin 的 hook JSON（本脚本不需要）。
cat >/dev/null 2>&1 || true

SRC="$(cd "$(dirname "$0")/../.." && pwd)/"
DEST="/tmp/diandian-sim-preview/"

# 没有预览副本目录 → 说明没在跑预览，直接退出。
[ -d "$DEST" ] || exit 0

# 增量同步（排除 .git / build / .dart_tool）。
# 用 -c（按内容校验）避免同字节长度的改动被 size+mtime 快检漏掉；
# 记录实际变更的文件（过滤目录条目）。
CHANGED=$(rsync -rlpgoDc \
  --exclude='.git' --exclude='build' --exclude='.dart_tool' \
  --out-format='%n' \
  "$SRC" "$DEST" 2>/dev/null | grep -v '/$' || true)

# 没有任何文件变化 → 不刷新。
[ -n "$CHANGED" ] || exit 0

# 关键：把变更文件的 mtime 顶到当前时间，否则 Flutter 增量编译器
# 会因 rsync 保留的旧 mtime 判定“无变化”，导致热重载 0 libraries。
while IFS= read -r f; do
  [ -n "$f" ] && touch "$DEST$f" 2>/dev/null || true
done <<< "$CHANGED"

# 找到正在运行的预览 `flutter run` 进程。
PID=$(pgrep -f "flutter_tools.snapshot run" | head -n1)
[ -n "$PID" ] || exit 0

# pubspec 或资源变更需要热重启以重新打包，其余用热重载。
if echo "$CHANGED" | grep -qiE '(^|/)pubspec\.yaml$|\.(png|jpe?g|webp|gif|svg|ttf|otf|frag|json|lottie)$'; then
  kill -USR2 "$PID" 2>/dev/null || true
else
  kill -USR1 "$PID" 2>/dev/null || true
fi

exit 0
