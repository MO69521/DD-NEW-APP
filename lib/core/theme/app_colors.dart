import 'package:flutter/material.dart';

import 'app_brand_colors.dart';

/// 全局颜色 token，禁止在 UI 中直接使用 [Color] 字面量。
abstract final class AppColors {
  // ── 中性色阶：白色透明度（深色态叠加，唯一真源）──
  // 语义色请指向这里，避免同一色值散落成多个硬编码字面量。
  static const Color white00 = Color(0x00FFFFFF);
  static const Color white04 = Color(0x0AFFFFFF);
  static const Color white05 = Color(0x0DFFFFFF);
  static const Color white06 = Color(0x0FFFFFFF);
  static const Color white08 = Color(0x14FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white24 = Color(0x3DFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white85 = Color(0xD9FFFFFF);
  static const Color white100 = Color(0xFFFFFFFF);

  // ── 中性色阶：黑色透明度（遮罩 / 蒙版，唯一真源）──
  static const Color black00 = Color(0x00000000);
  static const Color black04 = Color(0x0A000000);
  static const Color black08 = Color(0x14000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black40 = Color(0x66000000);
  static const Color black60 = Color(0x99000000);
  static const Color black80 = Color(0xCC000000);

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

  // Bookstore dark theme tokens（主题源色由 AppBrandColors 提供，支持换色系）
  static const Color backgroundDark = AppBrandColors.backgroundDark;

  // ── 背景 tint 阶：随基础背景色相变化（唯一真源在 AppBrandColors）──
  // 渐隐 / 毛玻璃底 / 头图蒙版统一走这里，末档 100% 复用 backgroundDark。
  static const Color bgTint00 = AppBrandColors.bgTint00;
  static const Color bgTint35 = AppBrandColors.bgTint35;
  static const Color bgTint45 = AppBrandColors.bgTint45;
  static const Color bgTint55 = AppBrandColors.bgTint55;
  static const Color bgTint60 = AppBrandColors.bgTint60;
  static const Color bgTint80 = AppBrandColors.bgTint80;
  static const Color bgTint90 = AppBrandColors.bgTint90;

  /// 顶/底 Chrome 毛玻璃半透明底色（约 45% 不透明，配合 blur 透出内容）。
  static const Color chromeBarScrim = bgTint45;

  /// 顶栏滚动后毛玻璃底色：更接近页面背景，避免头图文字透出干扰导航。
  static const Color topChromeBarScrolledScrim = bgTint80;
  static const Color topBarHeroScrimStart = black30;
  static const Color topBarHeroScrimEnd = black00;

  static const Color surfaceGlass = white08;
  static const Color surfaceCard = white04;
  static const Color surfaceMuted = AppBrandColors.surfaceMuted;
  static const Color auroraGlow = AppBrandColors.auroraGlow;
  static const Color auroraEdge = AppBrandColors.auroraEdge;
  static const Color dialogBackground = AppBrandColors.dialogBackground;
  static const Color accentYellow = AppBrandColors.accent;

  /// 礼花 / 庆祝动效多彩粒子配色（节日色，取品牌多色）。
  static const List<Color> confettiPalette = [
    AppBrandColors.accent, // 黄
    AppBrandColors.vipGradientEnd, // 粉
    AppBrandColors.brandBlueAccent, // 蓝
    AppBrandColors.partnerPrimary, // 玫红
    AppBrandColors.accentOrange, // 橙
    AppBrandColors.success, // 绿
  ];

  static const Color textOnDark = white100;
  static const Color textOnDarkMuted = white50;
  static const Color textOnDarkPlaceholder = white60;
  static const Color sectionActionIcon = white60;

  /// 热门搜索置顶热词强调色（复用品牌橙）。
  static const Color searchHotAccent = AppBrandColors.accentOrange;
  static const Color iconMuted = Color(0xFFB2B3BA);
  static const Color iconMutedSecondary = Color(0xFFABACB3);
  static const Color navActiveBackground = Color(0xFFFFFFFF);
  static const Color navActiveText = Color(0xFF090E17);
  static const Color navBarBackground = white20;
  static const Color topBarIconFrameBackground = black08;
  static const Color topBarIconFrameBorder = white04;
  static const Color borderGlass = white04;
  static const Color dividerOnDark = white08;
  static const Color discussionFilterSelectedBackground = white100;
  static const Color discussionFilterUnselectedText = white60;
  static const Color discussionItemReplyBackground = white06;
  static const Color discussionLikeIcon = white60;
  static const Color bookDetailUpdateDate = white50;
  static const Color bookDetailUpdateDateHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateLine = white20;
  static const Color bookDetailUpdateDotBorder = white50;
  static const Color bookDetailUpdateDotBorderHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateDotInner = white100;
  static const Color bookDetailUpdateText = white85;
  static const Color bookDetailUpdateTextHighlighted = Color(0xFFF0B16A);
  static const Color bookDetailUpdateSectionBackground = white05;
  static const Color bookDetailCharFavBackground = Color(0x0AFFE847);
  static const Color guessLikeCardBackground = white05;
  static const Color guessLikeTagBackground = white04;
  static const Color guessLikeTagBorder = white04;
  static const Color gradientFadeStart = bgTint00;
  static const Color gradientFadeMid = bgTint90;
  static const Color gradientFadeEnd = backgroundDark;
  static const Color coverBorder = black04;
  static const Color overlayScrim = black30;

  /// 弹窗遮罩（80% 不透明黑，无背景模糊）。
  static const Color overlayScrim80 = black80;

  /// 书架管理态封面遮罩（未选中，压暗封面突出选择框）。
  static const Color bookshelfManageCoverOverlay = black60;

  /// 书架管理态封面遮罩（已选中，略浅以保留选中反馈）。
  static const Color bookshelfManageCoverOverlaySelected = black40;

  /// 书架管理态未选中选择框描边（60% 白）。
  static const Color bookshelfSelectionMarkBorderUnselected = white60;

  /// 书架空态文案（Figma 1319:9953）。
  static const Color bookshelfEmptyText = Color(0xFF757575);

  /// 封面右上角状态角标「完结」半透明深底（Figma 1335:12223）。
  static const Color bookCoverTagCompletedScrim = black60;

  // 我的页头图 alpha 蒙版（Figma 400:2302 / 205:5742）
  static const Color profileHeroImageMaskOpaque = white100;
  static const Color profileHeroImageMaskSoft = white24;
  static const Color profileHeroImageMaskTransparent = white00;

  // 全局分段控件 (Figma 1297:827)
  static const Color segmentedSelectedFill = Color(0x14FFE847);
  static const Color segmentedSelectedBorder = accentYellow;
  static const Color segmentedSelectedText = accentYellow;
  static const Color segmentedUnselectedText = textOnDarkPlaceholder;

  // 榜单详情页 (Figma 220:8376)
  static const Color rankingHeroTitle = Color(0xFFFFFAD7);
  static const Color rankingHeroSubtitle = Color(0xE6FFFAD7);
  static const Color rankingSegmentedSelectedText = Color(0xFF202020);
  static const Color rankingCircleButtonBackground = black30;
  static const Color rankingDimensionIndicator = accentYellow;

  // 头图背景图蒙版：顶部轻压暗、上部透出插画、底部融入暗色背景。
  static const Color rankingHeroScrimTop = bgTint35;
  static const Color rankingHeroScrimMid = bgTint55;

  /// 固定头图已按最终视觉导出，不再额外降低透明度。
  static const double rankingHeroImageLayerOpacity = 1.0;

  // 搜索页（深色态）
  /// 顶栏「搜索」动作文字色，沿用深色态强调色。
  static const Color searchActionText = accentYellow;

  /// 封面「连载 / 完结」角标：半透明深底 + 白字。
  static const Color searchStatusBadgeBackground = bgTint60;
  static const Color searchStatusBadgeText = textOnDark;

  /// 输入框光标色。
  static const Color searchCursor = accentYellow;

  /// 分类页次级筛选选中文字：比主分类弱一档，避免多行筛选同时抢焦点。
  static const Color categoryFilterSecondarySelectedText = white85;
}
