import 'package:flutter/material.dart';

/// 全局颜色 token，禁止在 UI 中直接使用 [Color] 字面量。
abstract final class AppColors {
  static const Color primary = Color(0xFF6B4EFF);
  static const Color primaryLight = Color(0xFF9B8AFF);
  static const Color primaryDark = Color(0xFF4A32CC);

  static const Color background = Color(0xFFF8F7FC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Bookstore dark theme tokens
  static const Color backgroundDark = Color(0xFF090E17);
  static const Color surfaceGlass = Color(0x14FFFFFF);
  static const Color surfaceCard = Color(0x0AFFFFFF);
  static const Color accentYellow = Color(0xFFFFED63);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0x80FFFFFF);
  static const Color textOnDarkPlaceholder = Color(0x99FFFFFF);
  static const Color sectionActionIcon = Color(0x99FFFFFF);
  static const Color iconMuted = Color(0xFFB2B3BA);
  static const Color iconMutedSecondary = Color(0xFFABACB3);
  static const Color navActiveBackground = Color(0xFFFFFFFF);
  static const Color navActiveText = Color(0xFF090E17);
  static const Color navBarBackground = Color(0x33FFFFFF);
  static const Color borderGlass = Color(0x0AFFFFFF);
  static const Color discussionFilterSelectedBackground = Color(0xFFFFFFFF);
  static const Color discussionFilterUnselectedText = Color(0x99FFFFFF);
  static const Color discussionItemReplyBackground = Color(0x0FFFFFFF);
  static const Color discussionLikeIcon = Color(0x99FFFFFF);
  static const Color bookDetailUpdateDate = Color(0x80FFFFFF);
  static const Color bookDetailUpdateDateHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateLine = Color(0x33FFFFFF);
  static const Color bookDetailUpdateDotBorder = Color(0x80FFFFFF);
  static const Color bookDetailUpdateDotBorderHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateDotInner = Color(0xFFFFFFFF);
  static const Color bookDetailUpdateText = Color(0xD9FFFFFF);
  static const Color bookDetailUpdateTextHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateSectionBackground = Color(0x0DFFFFFF);
  static const Color guessLikeCardBackground = Color(0x0DFFFFFF);
  static const Color guessLikeTagBackground = Color(0x0AFFFFFF);
  static const Color guessLikeTagBorder = Color(0x0AFFFFFF);
  static const Color gradientFadeStart = Color(0x00090E17);
  static const Color gradientFadeMid = Color(0xE6090E17);
  static const Color gradientFadeEnd = Color(0xFF090E17);
  static const Color coverBorder = Color(0x0A000000);
  static const Color overlayScrim = Color(0x4D000000);

  // 我的页头图 alpha 蒙版（Figma 400:2302 / 205:5742）
  static const Color profileHeroImageMaskOpaque = Color(0xFFFFFFFF);
  static const Color profileHeroImageMaskSoft = Color(0x3DFFFFFF);
  static const Color profileHeroImageMaskTransparent = Color(0x00FFFFFF);

  // 榜单详情页 (Figma 220:8376)
  static const Color rankingHeroTitle = Color(0xFFFFFAD7);
  static const Color rankingHeroSubtitle = Color(0xE6FFFAD7);
  static const Color rankingSegmentedSelectedText = Color(0xFF202020);
  static const Color rankingCircleButtonBackground = Color(0x4D000000);
  static const Color rankingDimensionIndicator = Color(0xFFFFED63);

  // 头图背景图蒙版：顶部轻压暗、上部透出插画、底部融入暗色背景。
  static const Color rankingHeroScrimTop = Color(0x59090E17);
  static const Color rankingHeroScrimMid = Color(0x8C090E17);

  // 搜索页（深色态）
  /// 顶栏「搜索」动作文字色，沿用深色态强调色。
  static const Color searchActionText = accentYellow;

  /// 封面「连载 / 完结」角标：半透明深底 + 白字。
  static const Color searchStatusBadgeBackground = Color(0x99090E17);
  static const Color searchStatusBadgeText = textOnDark;

  /// 输入框光标色。
  static const Color searchCursor = accentYellow;
}
