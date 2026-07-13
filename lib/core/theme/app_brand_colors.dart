import 'package:flutter/material.dart';

import 'app_palette.dart';

/// 品牌 / 主题语义层（Tier 2）。
///
/// 本层不定义原色（`Color(0x…)` 一律在 [AppPalette]）；这里只做两件事：
/// - **§A 主题壳源色**：按 `themeId` 从 [AppPalette] 选原色（随 THEME 切换）。
/// - **§B feature 品牌语义**：给 [AppPalette] 原色起 feature 语义名（跨主题恒定）。
/// [AppColors]、各 feature 色板与页面通过本层 / [AppColors] 的语义名取色。
///
/// ── 编译期主题包（小流量实验用）───────────────────────────────
/// 一个实验包 = §A 整组的一套取值；`AppColors` / 页面经语义名取色，换包不改调用点。
/// 当前实验包：`dark`（默认深色）、`pink_light`（粉色浅色系）。
///
/// 新增一个实验包（示例 id `xxx`）：
///   1. 在 [AppPalette] 补该包所需原色（如新壳基色 `shellXxx` + 透明度阶）。
///   2. 在 §A 每个字段三元里前插 `themeId == 'xxx' ? AppPalette.xxx : …`。
///   3. 构建时 `--dart-define=THEME=xxx`；新增原色登记 `design-system/README.md` §4。
///
/// 约束（强制）：默认（不带 `--dart-define`）永远解析为 `dark`，
/// §A 的 dark 分支（[AppPalette] 深色原色）不得改动。
abstract final class AppBrandColors {
  static const String themeId = String.fromEnvironment(
    'THEME',
    defaultValue: 'dark',
  );

  // ══════════════════════════════════════════════════════════════
  // §A 主题壳源色（随 --dart-define=THEME 从 AppPalette 选）
  // ══════════════════════════════════════════════════════════════

  /// 全局背景（主题壳基色）。
  static const Color backgroundDark =
      themeId == _pinkLight ? AppPalette.pink50 : AppPalette.neutralCool950;

  /// 主强调色（主 CTA / 点赞 / 互动选中）。
  static const Color accent =
      themeId == _pinkLight ? AppPalette.pink500 : AppPalette.yellow500;

  /// 极光渐变亮核（暖米金）。pink_light 暂复用 dark（v1 已知项）。
  static const Color auroraGlow = AppPalette.cream100;

  /// 极光渐变暗边（暗红近黑）。pink_light 暂复用 dark。
  static const Color auroraEdge = AppPalette.wine950;

  /// 弹窗底。pink_light 用白底。
  static const Color dialogBackground =
      themeId == _pinkLight ? AppPalette.neutralWhite : AppPalette.neutralCool880;

  /// 主题壳主文字（深壳纯白；pink_light 深墨）。
  static const Color textOnDark =
      themeId == _pinkLight ? AppPalette.neutralBlue950 : AppPalette.neutralWhite;

  /// 实心浮层/卡片底（如「继续阅读」浮层）。pink_light 用白面板。
  static const Color surfaceMuted = themeId == _pinkLight
      ? AppPalette.neutralWhite
      : AppPalette.neutralCool800;

  // 背景 tint 阶：主题壳基色的不同透明度（渐隐 / 毛玻璃底）。
  // 头图/封面「图上遮罩」不用这里（浅色下需恒暗），由 AppColors 单独按主题处理。
  static const Color bgTint00 =
      themeId == _pinkLight ? AppPalette.pink50Alpha00 : AppPalette.neutralCool950Alpha00;
  static const Color bgTint35 =
      themeId == _pinkLight ? AppPalette.pink50Alpha35 : AppPalette.neutralCool950Alpha35;
  static const Color bgTint45 =
      themeId == _pinkLight ? AppPalette.pink50Alpha45 : AppPalette.neutralCool950Alpha45;
  static const Color bgTint55 =
      themeId == _pinkLight ? AppPalette.pink50Alpha55 : AppPalette.neutralCool950Alpha55;
  static const Color bgTint60 =
      themeId == _pinkLight ? AppPalette.pink50Alpha60 : AppPalette.neutralCool950Alpha60;
  static const Color bgTint80 =
      themeId == _pinkLight ? AppPalette.pink50Alpha80 : AppPalette.neutralCool950Alpha80;
  static const Color bgTint90 =
      themeId == _pinkLight ? AppPalette.pink50Alpha90 : AppPalette.neutralCool950Alpha90;

  static const String _pinkLight = 'pink_light';

  /// 浅色实验包判定（供 [AppColors] 翻转中性叠色 / ink 文字）。
  static const bool isLightExperiment = themeId == _pinkLight;

  // ══════════════════════════════════════════════════════════════
  // §B feature 品牌语义（跨主题恒定，引用 AppPalette 原色）
  // ══════════════════════════════════════════════════════════════

  // ── 浅色主题（预留）──
  static const Color backgroundLight = AppPalette.neutralCool50;
  static const Color textPrimary = AppPalette.neutralBlue950;
  static const Color textSecondary = AppPalette.neutralCool600;

  // ── VIP 粉紫系（福利 / 会员共用）──
  static const Color vipGradientStart = AppPalette.peach100;
  static const Color vipGradientEnd = AppPalette.pink300;
  static const Color vipOnGradientText = AppPalette.magenta950;
  static const Color vipCtaGradientStart = AppPalette.peach50;
  static const Color vipCtaGradientEnd = AppPalette.pink100Soft;
  static const Color vipCtaBorder = AppPalette.pink200;
  static const Color vipSelectedBorder = AppPalette.magenta500;
  static const Color vipBannerText = AppPalette.magenta980;

  // ── 伙伴页粉紫系（主色 = brandPink）──
  static const Color partnerPrimary = AppPalette.pink500;
  static const Color partnerPrimaryLight = AppPalette.pink400;
  static const Color partnerPrimaryDark = AppPalette.pink600;

  // ── 福利金/橙系 ──
  static const Color goldMedium = AppPalette.brown600;
  static const Color goldDark = AppPalette.brown500;
  static const Color goldText = AppPalette.brown800;
  static const Color accentOrange = AppPalette.orange500;
  static const Color checkInYellow = accent;
  static const Color checkInHighlightHeader = accent;

  // ── 书籍详情悬浮促销条（Figma 1598:4319）──
  static const Color promoBarGradientStart = AppPalette.rose500;
  static const Color promoBarGradientMid = AppPalette.orange550;
  static const Color promoBarGradientEnd = AppPalette.orange300;
  static const Color promoSubtitle = AppPalette.cream50;
  static const Color promoRewardText = AppPalette.orange700;

  // ── 中性辅助 ──
  static const Color textOnLightPanel = AppPalette.neutralWarm900;
  static const Color originalPriceMuted = AppPalette.neutralGray400;
  static const Color planOriginalPrice = AppPalette.neutralGray500;
  static const Color subtitleMuted = AppPalette.neutralGray600;
  static const Color iconMuted = AppPalette.neutralCool300;
  static const Color iconMutedSecondary = AppPalette.neutralCool350;
  static const Color rankingHeroTitle = AppPalette.cream200;

  // ── 语义状态色（Design Token v1.0）──
  static const Color success = AppPalette.green500;
  static const Color warning = AppPalette.amber500;
  static const Color error = AppPalette.rose400;
  static const Color hotSaleBadge = AppPalette.red400;
  static const Color hotSaleBadgeText = AppPalette.cream10;

  // ── 蓝色品牌预设（礼花粒子 / [AppColorScheme.brandBlue] 用）──
  static const Color brandBlueBackground = AppPalette.neutralCool960;
  static const Color brandBlueAccent = AppPalette.blue500;

  // ── Design Token v1.0 · 语义强调色扩展 ──
  static const Color premiumGold = AppPalette.gold400;
  static const Color info = AppPalette.sky500;
  static const Color fantasyPurple = AppPalette.purple400;
  static const Color energyCyan = AppPalette.cyan400;
  static const Color growthBlue = AppPalette.indigo400;
}
