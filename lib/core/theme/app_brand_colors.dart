import 'package:flutter/material.dart';

/// 品牌原始色值（唯一 hex 来源）。
///
/// 换色系时优先改此文件；[AppColors]、[AppWelfareColors] 等语义 token
/// 应通过别名引用此处，避免同色多处定义。
abstract final class AppBrandColors {
  // ── 主题色系接缝（build-time 选择，预留）──
  // 当前仅深色系。出新色系时：按 [themeId] 给下面的源色加分支，
  // 例如 `static const Color backgroundDark =
  //   themeId == 'blue' ? Color(0xFF0A1628) : Color(0xFF090E17);`，
  // 再构建时传 `--dart-define=THEME=blue` 即整包换色（AppColors 与
  // 语义层 AppColorScheme 都引用这些源色，无需改任何调用点）。
  static const String themeId = String.fromEnvironment(
    'THEME',
    defaultValue: 'dark',
  );

  // ── 全局深色壳（主题源色）──
  static const Color backgroundDark = Color(0xFF090E17);
  static const Color accent = Color(0xFFFFE847);

  /// 极光渐变亮核（暖米金）。
  static const Color auroraGlow = Color(0xFFFFF2C6);

  /// 极光渐变暗边（暗红近黑）。
  static const Color auroraEdge = Color(0xFF1D0B10);
  static const Color dialogBackground = Color(0xFF131820);
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// 深青灰实心浮层/卡片底（如「继续阅读」浮层）。
  static const Color surfaceMuted = Color(0xFF262B33);

  // 背景 tint 阶：基础背景色不同透明度（供渐隐 / 毛玻璃 / 头图蒙版）。
  static const Color bgTint00 = Color(0x00090E17);
  static const Color bgTint35 = Color(0x59090E17);
  static const Color bgTint45 = Color(0x73090E17);
  static const Color bgTint55 = Color(0x8C090E17);
  static const Color bgTint60 = Color(0x99090E17);
  static const Color bgTint80 = Color(0xCC090E17);
  static const Color bgTint90 = Color(0xE6090E17);

  // ── 浅色主题（预留）──
  static const Color backgroundLight = Color(0xFFF8F7FC);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);

  // ── VIP 粉紫系（福利 / 会员共用）──
  static const Color vipGradientStart = Color(0xFFFFDDC1);
  static const Color vipGradientEnd = Color(0xFFF393DC);
  static const Color vipOnGradientText = Color(0xFF740551);
  static const Color vipCtaGradientStart = Color(0xFFFFEBD4);
  static const Color vipCtaGradientEnd = Color(0xFFFFD5DB);
  static const Color vipCtaBorder = Color(0xFFFF9CC7);
  static const Color vipSelectedBorder = Color(0xFFE541BC);
  static const Color vipBannerText = Color(0xFF310F29);

  // ── 伙伴页粉紫系 ──
  static const Color partnerPrimary = Color(0xFFFF4D88);
  static const Color partnerPrimaryLight = Color(0xFFFF7AA8);
  static const Color partnerPrimaryDark = Color(0xFFE03D74);
  static const Color partnerPageBackgroundTop = Color(0xFF331E25);

  // ── 福利金/橙系 ──
  static const Color goldMedium = Color(0xFF935C1A);
  static const Color goldDark = Color(0xFFAA722E);
  static const Color goldText = Color(0xFF5D3A12);
  static const Color accentOrange = Color(0xFFFF7E32);
  static const Color checkInYellow = Color(0xFFFCE64D);
  static const Color checkInHighlightHeader = Color(0xFFFFDD47);

  // ── 中性辅助 ──
  static const Color textOnLightPanel = Color(0xFF202020);
  static const Color originalPriceMuted = Color(0xFF9B9B9B);
  static const Color planOriginalPrice = Color(0xFF919191);
  static const Color subtitleMuted = Color(0xFF8C8C8C);
  static const Color iconMuted = Color(0xFFB2B3BA);
  static const Color iconMutedSecondary = Color(0xFFABACB3);
  static const Color rankingHeroTitle = Color(0xFFFFFAD7);

  // ── 语义状态色（Design Token v1.0）──
  static const Color success = Color(0xFF39D98A);
  static const Color warning = Color(0xFFFFA940);
  static const Color error = Color(0xFFFF667F);
  static const Color hotSaleBadge = Color(0xFFFF6B6B);
  static const Color hotSaleBadgeText = Color(0xFFFFFEF4);

  // ── 蓝色品牌预设（[AppColorScheme.brandBlue] 用）──
  static const Color brandBlueBackground = Color(0xFF0A1628);
  static const Color brandBlueAccent = Color(0xFF4DA6FF);

  // ── Design Token v1.0 · 语义强调色扩展 ──
  // 新增源色，暂未接入具体页面，供后续 feature 语义 token 引用。
  static const Color premiumGold = Color(0xFFF9C74F); // VIP Theme（会员金主题）
  static const Color info = Color(0xFF59AEFF); // 信息 / 提示
  static const Color fantasyPurple = Color(0xFF9C87FF); // 奇幻紫
  static const Color energyCyan = Color(0xFF42DDFF); // 能量青
  static const Color growthBlue = Color(0xFF7E95FF); // 成长蓝
}
