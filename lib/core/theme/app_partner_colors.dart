import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 伙伴页（探索）专用色 token：深色基底 + 粉色强调 + 紫色标签。
/// 品牌粉引用 [AppBrandColors]、中性 / 背景 tint 引用 [AppColors]；
/// 粉紫透明度 tint 等本页独有色保留字面量。
abstract final class AppPartnerColors {
  // ── 粉色强调系（主色 #FF4D88）──
  static const Color primary = AppBrandColors.partnerPrimary;
  static const Color primaryLight = AppBrandColors.partnerPrimaryLight;
  static const Color primaryDark = AppBrandColors.partnerPrimaryDark;
  static const Color primaryDisabled = Color(0x4DFF4D88);
  static const Color primaryMutedBg = Color(0x1FFF4D88);
  static const Color primarySubtleBg = Color(0x14FF4D88);
  static const Color textOnPrimary = AppColors.white100;

  // ── 紫色标签系（卡片人设 tag）──
  static const Color tagPurple = Color(0xFFB8A4FF);
  static const Color tagPurpleLight = Color(0xFFD4C8FF);
  static const Color tagPurpleMuted = Color(0xFF8B7EC8);
  static const Color tagPurpleBg = Color(0x24B8A4FF);
  static const Color tagPurpleBorder = Color(0x38B8A4FF);

  // ── 页面大背景：复用全局深色背景 ──
  static const Color pageBackgroundBottom = AppColors.backgroundDark;

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
  static const Color badgeUncollectedBg = AppColors.bgTint60;

  /// 封面叠加标题阴影。
  static const Color coverTitleShadow = Color(0x80000000);

  /// 卡片 pressed 遮罩。
  static const Color cardPressedOverlay = Color(0x1AFFFFFF);

  /// chip / 按钮 pressed 遮罩。
  static const Color chipPressedOverlay = AppColors.white20;

  // ── 消息 Tab ──
  /// 顶栏下方粉紫光晕渐变顶色。
  static const Color messageHeaderGlowTop = Color(0x4DFF4D88);

  /// 顶栏下方粉紫光晕渐变过渡色。
  static const Color messageHeaderGlowMid = Color(0x1FB8A4FF);

  /// 会话行分隔线。
  static const Color messageRowDivider = AppColors.white08;

  /// 好感度徽章背景。
  static const Color affectionBadgeBg = primary;

  // ── 互动 Tab ──
  static const Color interactionHeaderBg = Color(0x99331E25);

  static const Color interactionHeaderGradientEnd = AppColors.black00;

  static const Color interactionCharacterCardBg = Color(0x80090E17);

  static const Color interactionSideActionBg = Color(0x66090E17);

  static const Color interactionReviewButtonBg = Color(0xCC3D3428);

  static const Color interactionPageIndicatorBg = AppColors.bgTint60;

  static const Color interactionConfideButton = primary;

  static const Color interactionChatButton = Color(0xFFD4A853);

  static const Color interactionSceneBottomFade = AppColors.bgTint60;

  static const Color interactionAiPlotBadgeBg = AppBrandColors.partnerPrimary;
}
