#!/usr/bin/env bash
# 浅色主题（pink_light / yellow_light）token 反模式检测。
#
# 背景：浅色实验包靠 AppColors._isLight（编译期 THEME=pink_light / yellow_light）翻转中性面/文字/描边
# （yellow_light 复用同一套中性外壳，仅强调色换黄；门禁逻辑与具体主题无关）。
# 凡「公开语义 token 绑死深色值」或「UI 直接把 whiteNN/blackNN/深色 Color(0x) 当面/描边/文字」，
# 浅色态都不翻转 → 白底看不见、深块压浅底、白字消失、主色上黑字。
#
# 修复约定：深色分支保持原值不变，浅色分支翻到已有语义 token（surface/surfaceSoft/divider/
# borderSubtle/textPrimary/textSecondary/textTertiary/onPrimary），不新增色值。
# 图上恒暗 / 纯特效可加行内注释豁免：`// light-audit: keep-dark` 或 `// light-audit: effect`。
#
# 门禁：① 公开 token 直绑 _dark* 视为硬错误（退出码 2）。②③④ 为信息性人工复核清单（不阻断）。
# 用法：bash scripts/check-light-theme.sh
set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

YEL=$'\033[1;33m'; GRN=$'\033[0;32m'; NC=$'\033[0m'
gate_fail=0

echo "=== 浅色主题 token 反模式检测（pink_light）==="

# ① 硬门禁：公开语义 token 绑死私有 _dark*（浅色不翻转）。图上恒暗项加 // light-audit: keep-dark 豁免。
echo; echo "--- ① [门禁] 公开 token 直绑 _dark*（app_colors.dart）---"
hits="$(rg -n '=\s*_dark(Surface|SurfaceSoft|Border|Divider)\b' lib/core/theme/app_colors.dart 2>/dev/null | rg -v 'light-audit: keep-dark')"
if [ -n "$hits" ]; then
  echo "$hits"
  echo "${YEL}→ 翻到语义 token（surface/surfaceSoft/divider/borderSubtle），或图上恒暗则加 // light-audit: keep-dark${NC}"
  gate_fail=1
else
  echo "${GRN}✓ 无${NC}"
fi

# ②③④ 信息性复核（feature 色板本就含合法品牌/金/橙恒定色，需人工判定，不阻断）。
echo; echo "--- ② [复核] feature 色板硬编码 Color(0x…)（已 _isLight 翻转 / 已豁免的不计）---"
rg -n 'Color\(0x' lib/core/theme/app_welfare_colors.dart lib/core/theme/app_membership_colors.dart lib/core/theme/app_partner_colors.dart 2>/dev/null | rg -v 'light-audit:|_isLight' || echo "${GRN}✓ 无${NC}"

echo; echo "--- ③ [复核] UI 层直用 AppColors.whiteNN / blackNN（特效加 // light-audit: effect）---"
rg -n 'AppColors\.(white|black)[0-9]' lib/features lib/shared 2>/dev/null | rg -v 'light-audit: effect' || echo "${GRN}✓ 无${NC}"

echo; echo "--- ④ [复核] UI 层裸 Color(0x…) ---"
rg -n 'Color\(0x' lib/features lib/shared 2>/dev/null | rg -v 'light-audit: (effect|keep-dark)' || echo "${GRN}✓ 无${NC}"

echo; echo "=== 小结 ==="
if [ "$gate_fail" -eq 0 ]; then
  echo "${GRN}① 门禁通过；②③④ 为人工复核清单，逐项判定特效/图上恒暗（豁免）或面·文字（翻转）${NC}"
  exit 0
fi
echo "${YEL}① 门禁未过：存在公开 token 直绑 _dark*，请翻转或加 keep-dark 豁免${NC}"
exit 2
