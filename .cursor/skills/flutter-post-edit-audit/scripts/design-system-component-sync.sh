#!/usr/bin/env bash
# 设计规范「组件 / 样式 增删改 ↔ 文档 + 画廊同步」强制守卫（§0.1）。
#
# 触发本次改动后，强制核对：
#   A) 新增的共享组件（lib/shared/{components,widgets,layouts}/*.dart 且含公共 API）
#      是否已登记进 design-system/README.md 或 canvas（类名或源码路径其一被引用）。
#   B) 删除的共享组件是否已从 README / canvas 移除（不得残留悬空引用）。
#   C) 本次改了「共享组件（增/删）」或「token 样式（lib/core/theme/*）」时，
#      design-system/（README 或 canvas）必须同在本次改动内（否则视为漏同步）。
#   D) 仅「修改」了共享组件时，提醒确认外观是否变化、是否需要同步文档（软提示）。
#
# 退出码：0 通过；2 检测到未同步 / 悬空引用，需处理。
set -uo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT" || exit 0

README="design-system/README.md"
CANVAS="design-system/design-system-spec.canvas.tsx"

YELLOW=$'\033[1;33m'; RED=$'\033[0;31m'; GREEN=$'\033[0;32m'; NC=$'\033[0m'

echo "=== 设计规范组件 / 样式同步守卫（§0.1）==="

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "${YELLOW}非 git 仓库，跳过（请人工核对增删组件是否同步 README + canvas）${NC}"
  exit 0
fi
if [ ! -f "$README" ] || [ ! -f "$CANVAS" ]; then
  echo "${RED}缺少权威文件 $README 或 $CANVAS${NC}"; exit 2
fi

is_shared() { case "$1" in lib/shared/components/*.dart|lib/shared/widgets/*.dart|lib/shared/layouts/*.dart) return 0;; *) return 1;; esac; }

# 收集本次改动（工作区 + 暂存 + 未跟踪）。格式：<XY> <path>
status="$(git status --porcelain --untracked-files=all 2>/dev/null)"

shared_added=(); shared_deleted=(); shared_modified=()
theme_changed=0; ds_changed=0

while IFS= read -r line; do
  [ -z "$line" ] && continue
  code="${line:0:2}"; path="${line:3}"
  # 处理重命名 "old -> new"
  case "$path" in *" -> "*) path="${path##* -> }";; esac
  case "$path" in "design-system/"*) ds_changed=1;; esac
  case "$path" in lib/core/theme/*.dart) theme_changed=1;; esac
  if is_shared "$path"; then
    case "$code" in
      "??"|A*|*A) shared_added+=("$path");;
      D*|*D) shared_deleted+=("$path");;
      *) shared_modified+=("$path");;
    esac
  fi
done <<< "$status"

# 公共类名（首字母大写，自动排除 _私有 类）。
public_classes() {
  rg -o '^(?:abstract |final |sealed |base |mixin )*class ([A-Z][A-Za-z0-9_]*)' -r '$1' "$1" 2>/dev/null | sort -u
}
public_classes_from() { # 从任意文本读取
  printf '%s\n' "$1" | rg -o '^(?:abstract |final |sealed |base |mixin )*class ([A-Z][A-Za-z0-9_]*)' -r '$1' 2>/dev/null | sort -u
}
# 顶层公共函数（col0 起、返回类型 + 小写函数名，用于 book_cover_hero 这类纯函数文件）。
has_public_fn() {
  rg -q '^[A-Za-z_$][A-Za-z0-9_<>?,. ]*[[:space:]]+[a-z][A-Za-z0-9_]*[[:space:]]*\(' "$1" 2>/dev/null
}
# 是否含公共可视组件（StatelessWidget / StatefulWidget）—— 需进可视化画廊。
has_public_widget() {
  rg -q '^(?:abstract |final |sealed |base )*class [A-Z][A-Za-z0-9_]* +extends +(?:Stateless|Stateful)Widget' "$1" 2>/dev/null
}
# 名称 / 路径是否被指定文档引用。
in_doc() { rg -Fq "$2" "$1" 2>/dev/null; }
# 文件的公共类名或源码路径是否在指定文档中出现。
registered_in() { # $1=doc  $2=file  $3=classes
  local doc="$1" file="$2" classes="$3"
  local base rel; base="$(basename "$file")"; rel="${file#lib/}"
  in_doc "$doc" "$file" && return 0
  in_doc "$doc" "$rel" && return 0
  in_doc "$doc" "$base" && return 0
  while IFS= read -r c; do
    [ -z "$c" ] && continue
    in_doc "$doc" "$c" && return 0
  done <<< "$classes"
  return 1
}

flag=0

# A) 新增共享组件是否登记（可视组件须 README + canvas 双登记）
if [ "${#shared_added[@]}" -gt 0 ]; then
  echo "--- 新增共享组件登记检查（可视组件须 README + 画廊双登记）---"
  for f in "${shared_added[@]}"; do
    [ -f "$f" ] || continue
    classes="$(public_classes "$f")"
    tag="${classes:+（类：$(echo "$classes" | paste -sd, -)）}"
    has_pub_api=0; is_widget=0
    [ -n "$classes" ] && has_pub_api=1
    has_public_fn "$f" && has_pub_api=1
    has_public_widget "$f" && is_widget=1

    if [ "$has_pub_api" -eq 0 ]; then
      echo "  ${GREEN}·${NC} ${f}（无公共 API，视为内部拆分，跳过）"
      continue
    fi

    readme_ok=0; canvas_ok=0
    registered_in "$README" "$f" "$classes" && readme_ok=1
    registered_in "$CANVAS" "$f" "$classes" && canvas_ok=1

    if [ "$is_widget" -eq 1 ]; then
      # 可视组件：README 与 canvas 都必须登记。
      if [ "$readme_ok" -eq 1 ] && [ "$canvas_ok" -eq 1 ]; then
        echo "  ${GREEN}✓${NC} $f 已双登记（README + 画廊）"
      else
        local_missing=""
        [ "$readme_ok" -eq 0 ] && local_missing="README"
        [ "$canvas_ok" -eq 0 ] && local_missing="${local_missing:+$local_missing + }画廊(canvas)"
        echo "  ${RED}✗ 未登记${NC} $f${tag} → 缺：${local_missing}"
        flag=1
      fi
    else
      # 非可视（纯函数 / delegate 等）：至少 README 登记；画廊可选。
      if [ "$readme_ok" -eq 1 ]; then
        [ "$canvas_ok" -eq 1 ] \
          && echo "  ${GREEN}✓${NC} $f 已登记（README + 画廊）" \
          || echo "  ${GREEN}✓${NC} $f 已登记 README${YELLOW}（非可视组件，画廊可选）${NC}"
      else
        echo "  ${RED}✗ 未登记${NC} $f${tag} → 缺：README"
        flag=1
      fi
    fi
  done
fi

# B) 删除共享组件是否残留悬空引用
if [ "${#shared_deleted[@]}" -gt 0 ]; then
  echo "--- 删除共享组件悬空引用检查 ---"
  for f in "${shared_deleted[@]}"; do
    old="$(git show "HEAD:$f" 2>/dev/null)"
    classes="$(public_classes_from "$old")"
    base="$(basename "$f")"
    dangling=""
    while IFS= read -r c; do
      [ -z "$c" ] && continue
      if referenced "$c"; then dangling="${dangling}${c} "; fi
    done <<< "$classes"
    if referenced "$f" || referenced "$base"; then dangling="${dangling}${base} "; fi
    if [ -n "$dangling" ]; then
      echo "  ${RED}✗ 悬空引用${NC} $f → README/canvas 仍引用：$dangling"
      flag=1
    else
      echo "  ${GREEN}✓${NC} $f 已从文档移除"
    fi
  done
fi

# C) 改了组件（增/删）或 token 样式，但没同步 design-system/
struct_change=0
{ [ "${#shared_added[@]}" -gt 0 ] || [ "${#shared_deleted[@]}" -gt 0 ] || [ "$theme_changed" -eq 1 ]; } && struct_change=1
if [ "$struct_change" -eq 1 ] && [ "$ds_changed" -eq 0 ]; then
  echo "--- 同步守卫 ---"
  echo "  ${RED}✗ 本次改动含「增/删共享组件」或「token 样式（lib/core/theme）」，但未改动 design-system/${NC}"
  echo "    → 必须同步更新 $README 与 ${CANVAS}（改样式 / 增删组件 = 文档 + 画廊同步）"
  flag=1
fi

# D) 仅修改了共享组件（软提示）
if [ "${#shared_modified[@]}" -gt 0 ]; then
  echo "--- 修改的共享组件（请确认外观/变体是否变化，若变则同步文档 + 画廊）---"
  for f in "${shared_modified[@]}"; do echo "  ${YELLOW}·${NC} $f"; done
fi

echo "=== 小结 ==="
if [ "$flag" -eq 0 ]; then
  echo "${GREEN}组件 / 样式改动与规范文档 + 画廊同步一致${NC}"; exit 0
fi
echo "${YELLOW}检测到未同步 / 悬空引用：请更新 $README 与 ${CANVAS}（改 canvas 后运行 sync-canvas.sh）后重跑${NC}"
exit 2
