import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 伙伴页（探索）专用色 token：深色基底 + 粉色强调 + 紫色标签。
/// 品牌粉引用 [AppBrandColors]、中性 / 背景 tint 引用 [AppColors]；
/// 粉紫透明度 tint 等本页独有色保留字面量。
abstract final class AppPartnerColors {
  /// 浅色实验包判定：探索/消息普通面翻转；沉浸式互动场景（图上恒暗）不翻。
  static const bool _isLight = AppBrandColors.isLightExperiment;

  // ── 粉色强调系（主色 #FF4D88）──
  static const Color primary = AppBrandColors.partnerPrimary;
  static const Color primaryLight = AppBrandColors.partnerPrimaryLight;
  static const Color primaryDark = AppBrandColors.partnerPrimaryDark;
  static const Color primaryDisabled = Color(
    0x4DFF4D88,
  ); // light-audit: keep-dark 品牌粉 tint，两态皆可读
  static const Color primaryMutedBg = Color(
    0x1FFF4D88,
  ); // light-audit: keep-dark
  static const Color primarySubtleBg = Color(
    0x14FF4D88,
  ); // light-audit: keep-dark
  static const Color textOnPrimary = AppColors.white100;

  // ── 紫色标签系（卡片人设 tag，品牌恒定色，两态皆可读）──
  static const Color tagPurple = Color(0xFFB8A4FF); // light-audit: keep-dark
  static const Color tagPurpleLight = Color(
    0xFFD4C8FF,
  ); // light-audit: keep-dark
  static const Color tagPurpleMuted = Color(
    0xFF8B7EC8,
  ); // light-audit: keep-dark
  static const Color tagPurpleBg = Color(0x24B8A4FF); // light-audit: keep-dark
  static const Color tagPurpleBorder = Color(
    0x38B8A4FF,
  ); // light-audit: keep-dark

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
  static const Color coverTitleShadow = Color(
    0x80000000,
  ); // light-audit: effect 封面图上文字阴影

  /// 卡片 pressed 遮罩。
  static const Color cardPressedOverlay = Color(
    0x1AFFFFFF,
  ); // light-audit: effect 按压高光遮罩

  /// chip / 按钮 pressed 遮罩。
  static const Color chipPressedOverlay = AppColors.white20;

  // ── 消息 Tab ──
  /// 顶栏下方粉紫光晕渐变顶色。
  static const Color messageHeaderGlowTop = Color(
    0x4DFF4D88,
  ); // light-audit: keep-dark 装饰粉紫光晕

  /// 顶栏下方粉紫光晕渐变过渡色。
  static const Color messageHeaderGlowMid = Color(
    0x1FB8A4FF,
  ); // light-audit: keep-dark 装饰粉紫光晕

  /// 会话行分隔线：深色 8% 白 / 浅色分割线（消息面在实体面上）。
  static const Color messageRowDivider = _isLight
      ? AppColors.divider
      : AppColors.white08;

  /// 好感度徽章背景。
  static const Color affectionBadgeBg = primary;

  // ── 互动 Tab（沉浸式场景：基于角色立绘大图，图上暗遮罩恒暗，不随页面主题翻）──
  static const Color interactionHeaderBg = Color(
    0x99331E25,
  ); // light-audit: keep-dark 沉浸场景

  static const Color interactionHeaderGradientEnd = AppColors.black00;

  static const Color interactionCharacterCardBg = Color(
    0x80090E17,
  ); // light-audit: keep-dark 沉浸场景

  static const Color interactionSideActionBg = Color(
    0x66090E17,
  ); // light-audit: keep-dark 沉浸场景

  static const Color interactionReviewButtonBg = Color(
    0xCC3D3428,
  ); // light-audit: keep-dark 沉浸场景

  static const Color interactionPageIndicatorBg = AppColors.bgTint60;

  static const Color interactionConfideButton = primary;

  static const Color interactionChatButton = Color(
    0xFFD4A853,
  ); // light-audit: keep-dark 沉浸场景金按钮

  static const Color interactionSceneBottomFade = AppColors.bgTint60;

  static const Color interactionAiPlotBadgeBg = AppBrandColors.partnerPrimary;
}
