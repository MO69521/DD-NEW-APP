import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 伙伴页（探索）专用色 token：深色基底 + 粉色强调 + 紫色标签。
abstract final class AppPartnerColors {
  // ── 粉色强调系（主色 #FF4D88）──
  static const Color primary = Color(0xFFFF4D88);
  static const Color primaryLight = Color(0xFFFF7AA8);
  static const Color primaryDark = Color(0xFFE03D74);
  static const Color primaryDisabled = Color(0x4DFF4D88);
  static const Color primaryMutedBg = Color(0x1FFF4D88);
  static const Color primarySubtleBg = Color(0x14FF4D88);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── 紫色标签系（卡片人设 tag）──
  static const Color tagPurple = Color(0xFFB8A4FF);
  static const Color tagPurpleLight = Color(0xFFD4C8FF);
  static const Color tagPurpleMuted = Color(0xFF8B7EC8);
  static const Color tagPurpleBg = Color(0x24B8A4FF);
  static const Color tagPurpleBorder = Color(0x38B8A4FF);

  // ── 页面大背景（Figma 1022:1062，独立色体系）──
  /// 全屏渐变顶色：深酒红棕 #331E25。
  static const Color pageBackgroundTop = Color(0xFF331E25);

  /// 全屏渐变底色：深蓝黑 #090E17。
  static const Color pageBackgroundBottom = Color(0xFF090E17);

  // ── 深色中性系（复用全局）──
  static const Color background = pageBackgroundBottom;
  static const Color surfaceCard = AppColors.surfaceCard;
  static const Color surfaceGlass = AppColors.surfaceGlass;
  static const Color borderGlass = AppColors.borderGlass;
  static const Color textPrimary = AppColors.textOnDark;
  static const Color textSecondary = AppColors.textOnDarkMuted;
  static const Color textTertiary = AppColors.textOnDarkPlaceholder;
  static const Color iconMuted = AppColors.iconMuted;
  static const Color overlayScrim = AppColors.overlayScrim;

  // ── 角标 ──
  static const Color badgeUncollectedBg = Color(0x99090E17);

  /// 封面叠加标题阴影。
  static const Color coverTitleShadow = Color(0x80000000);

  /// 卡片 pressed 遮罩。
  static const Color cardPressedOverlay = Color(0x1AFFFFFF);

  /// chip / 按钮 pressed 遮罩。
  static const Color chipPressedOverlay = Color(0x33FFFFFF);
}
