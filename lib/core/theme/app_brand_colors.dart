import 'package:flutter/material.dart';

/// 品牌原始色值（唯一 hex 来源）。
///
/// 换色系时优先改此文件；[AppColors]、[AppWelfareColors] 等语义 token
/// 应通过别名引用此处，避免同色多处定义。
abstract final class AppBrandColors {
  // ── 全局深色壳 ──
  static const Color backgroundDark = Color(0xFF090E17);
  static const Color accent = Color(0xFFFFED63);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── 浅色主题（预留）──
  static const Color backgroundLight = Color(0xFFF8F7FC);
  static const Color primaryPurple = Color(0xFF6B4EFF);
  static const Color primaryPurpleLight = Color(0xFF9B8AFF);
  static const Color primaryPurpleDark = Color(0xFF4A32CC);
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

  // ── 语义状态色 ──
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color hotSaleBadge = Color(0xFFFF6B6B);
  static const Color hotSaleBadgeText = Color(0xFFFFFEF4);

  // ── 蓝色品牌预设（[AppColorScheme.brandBlue] 用）──
  static const Color brandBlueBackground = Color(0xFF0A1628);
  static const Color brandBlueAccent = Color(0xFF4DA6FF);
}
