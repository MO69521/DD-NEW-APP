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
      themeId == _pinkLight ? AppPalette.shellPink : AppPalette.shellDark;

  /// 主强调色（主 CTA / 点赞 / 互动选中）。
  static const Color accent =
      themeId == _pinkLight ? AppPalette.brandPink : AppPalette.brandYellow;

  /// 极光渐变亮核（暖米金）。pink_light 暂复用 dark（v1 已知项）。
  static const Color auroraGlow = AppPalette.auroraGlow;

  /// 极光渐变暗边（暗红近黑）。pink_light 暂复用 dark。
  static const Color auroraEdge = AppPalette.auroraEdge;

  /// 弹窗底。pink_light 用白底。
  static const Color dialogBackground =
      themeId == _pinkLight ? AppPalette.white100 : AppPalette.dialogDark;

  /// 主题壳主文字（深壳纯白；pink_light 深墨）。
  static const Color textOnDark =
      themeId == _pinkLight ? AppPalette.ink : AppPalette.white100;

  /// 实心浮层/卡片底（如「继续阅读」浮层）。pink_light 用白面板。
  static const Color surfaceMuted = themeId == _pinkLight
      ? AppPalette.white100
      : AppPalette.surfaceMutedDark;

  // 背景 tint 阶：主题壳基色的不同透明度（渐隐 / 毛玻璃底）。
  // 头图/封面「图上遮罩」不用这里（浅色下需恒暗），由 AppColors 单独按主题处理。
  static const Color bgTint00 =
      themeId == _pinkLight ? AppPalette.shellPinkT00 : AppPalette.shellDarkT00;
  static const Color bgTint35 =
      themeId == _pinkLight ? AppPalette.shellPinkT35 : AppPalette.shellDarkT35;
  static const Color bgTint45 =
      themeId == _pinkLight ? AppPalette.shellPinkT45 : AppPalette.shellDarkT45;
  static const Color bgTint55 =
      themeId == _pinkLight ? AppPalette.shellPinkT55 : AppPalette.shellDarkT55;
  static const Color bgTint60 =
      themeId == _pinkLight ? AppPalette.shellPinkT60 : AppPalette.shellDarkT60;
  static const Color bgTint80 =
      themeId == _pinkLight ? AppPalette.shellPinkT80 : AppPalette.shellDarkT80;
  static const Color bgTint90 =
      themeId == _pinkLight ? AppPalette.shellPinkT90 : AppPalette.shellDarkT90;

  static const String _pinkLight = 'pink_light';

  /// 浅色实验包判定（供 [AppColors] 翻转中性叠色 / ink 文字）。
  static const bool isLightExperiment = themeId == _pinkLight;

  // ══════════════════════════════════════════════════════════════
  // §B feature 品牌语义（跨主题恒定，引用 AppPalette 原色）
  // ══════════════════════════════════════════════════════════════

  // ── 浅色主题（预留）──
  static const Color backgroundLight = AppPalette.paperCool;
  static const Color textPrimary = AppPalette.ink;
  static const Color textSecondary = AppPalette.inkMuted;

  // ── VIP 粉紫系（福利 / 会员共用）──
  static const Color vipGradientStart = AppPalette.vipGradStart;
  static const Color vipGradientEnd = AppPalette.vipGradEnd;
  static const Color vipOnGradientText = AppPalette.vipOnGradText;
  static const Color vipCtaGradientStart = AppPalette.vipCtaStart;
  static const Color vipCtaGradientEnd = AppPalette.vipCtaEnd;
  static const Color vipCtaBorder = AppPalette.vipCtaBorder;
  static const Color vipSelectedBorder = AppPalette.vipSelectedBorder;
  static const Color vipBannerText = AppPalette.vipBannerText;

  // ── 伙伴页粉紫系（主色 = brandPink）──
  static const Color partnerPrimary = AppPalette.brandPink;
  static const Color partnerPrimaryLight = AppPalette.partnerLight;
  static const Color partnerPrimaryDark = AppPalette.partnerDark;

  // ── 福利金/橙系 ──
  static const Color goldMedium = AppPalette.goldMedium;
  static const Color goldDark = AppPalette.goldDark;
  static const Color goldText = AppPalette.goldText;
  static const Color accentOrange = AppPalette.orange;
  static const Color checkInYellow = AppPalette.checkInYellow;
  static const Color checkInHighlightHeader = AppPalette.checkInHeader;

  // ── 书籍详情悬浮促销条（Figma 1598:4319）──
  static const Color promoBarGradientStart = AppPalette.promoStart;
  static const Color promoBarGradientMid = AppPalette.promoMid;
  static const Color promoBarGradientEnd = AppPalette.promoEnd;
  static const Color promoSubtitle = AppPalette.promoSubtitle;
  static const Color promoRewardText = AppPalette.promoReward;

  // ── 中性辅助 ──
  static const Color textOnLightPanel = AppPalette.onLightPanel;
  static const Color originalPriceMuted = AppPalette.inkFaint;
  static const Color planOriginalPrice = AppPalette.grayStrike;
  static const Color subtitleMuted = AppPalette.graySubtitle;
  static const Color iconMuted = AppPalette.iconGray;
  static const Color iconMutedSecondary = AppPalette.iconGray2;
  static const Color rankingHeroTitle = AppPalette.rankingTitle;

  // ── 语义状态色（Design Token v1.0）──
  static const Color success = AppPalette.success;
  static const Color warning = AppPalette.warning;
  static const Color error = AppPalette.error;
  static const Color hotSaleBadge = AppPalette.hotSale;
  static const Color hotSaleBadgeText = AppPalette.hotSaleText;

  // ── 蓝色品牌预设（礼花粒子 / [AppColorScheme.brandBlue] 用）──
  static const Color brandBlueBackground = AppPalette.blueBg;
  static const Color brandBlueAccent = AppPalette.blueAccent;

  // ── Design Token v1.0 · 语义强调色扩展 ──
  static const Color premiumGold = AppPalette.premiumGold;
  static const Color info = AppPalette.info;
  static const Color fantasyPurple = AppPalette.fantasyPurple;
  static const Color energyCyan = AppPalette.energyCyan;
  static const Color growthBlue = AppPalette.growthBlue;
}
