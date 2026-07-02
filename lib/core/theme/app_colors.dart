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

  /// 顶/底 Chrome 毛玻璃半透明底色（约 45% 不透明，配合 blur 透出内容）。
  static const Color chromeBarScrim = Color(0x73090E17);

  /// 顶栏滚动后毛玻璃底色：更接近页面背景，避免头图文字透出干扰导航。
  static const Color topChromeBarScrolledScrim = Color(0xCC090E17);

  static const Color surfaceGlass = Color(0x14FFFFFF);
  static const Color surfaceCard = Color(0x0AFFFFFF);
  static const Color dialogBackground = Color(0xFF131820);
  static const Color accentYellow = Color(0xFFFFE847);
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
  static const Color dividerOnDark = Color(0x14FFFFFF);
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
  static const Color bookDetailCharFavBackground = Color(0x0AFFE847);
  static const Color guessLikeCardBackground = Color(0x0DFFFFFF);
  static const Color guessLikeTagBackground = Color(0x0AFFFFFF);
  static const Color guessLikeTagBorder = Color(0x0AFFFFFF);
  static const Color gradientFadeStart = Color(0x00090E17);
  static const Color gradientFadeMid = Color(0xE6090E17);
  static const Color gradientFadeEnd = Color(0xFF090E17);
  static const Color coverBorder = Color(0x0A000000);
  static const Color overlayScrim = Color(0x4D000000);

  /// 弹窗遮罩（80% 不透明黑，无背景模糊）。
  static const Color overlayScrim80 = Color(0xCC000000);

  /// 书架管理态封面遮罩（未选中，压暗封面突出选择框）。
  static const Color bookshelfManageCoverOverlay = Color(0x99000000);

  /// 书架管理态封面遮罩（已选中，略浅以保留选中反馈）。
  static const Color bookshelfManageCoverOverlaySelected = Color(0x66000000);

  /// 书架管理态未选中选择框描边（60% 白）。
  static const Color bookshelfSelectionMarkBorderUnselected = Color(0x99FFFFFF);

  /// 书架空态文案（Figma 1319:9953）。
  static const Color bookshelfEmptyText = Color(0xFF757575);

  /// 封面右上角状态角标「完结」半透明深底（Figma 1335:12223）。
  static const Color bookCoverTagCompletedScrim = Color(0x99000000);

  // 我的页头图 alpha 蒙版（Figma 400:2302 / 205:5742）
  static const Color profileHeroImageMaskOpaque = Color(0xFFFFFFFF);
  static const Color profileHeroImageMaskSoft = Color(0x3DFFFFFF);
  static const Color profileHeroImageMaskTransparent = Color(0x00FFFFFF);

  // 全局分段控件 (Figma 1297:827)
  static const Color segmentedSelectedFill = Color(0x14FFE847);
  static const Color segmentedSelectedBorder = accentYellow;
  static const Color segmentedSelectedText = accentYellow;
  static const Color segmentedUnselectedText = textOnDarkPlaceholder;

  // 榜单详情页 (Figma 220:8376)
  static const Color rankingHeroTitle = Color(0xFFFFFAD7);
  static const Color rankingHeroSubtitle = Color(0xE6FFFAD7);
  static const Color rankingSegmentedSelectedText = Color(0xFF202020);
  static const Color rankingCircleButtonBackground = Color(0x4D000000);
  static const Color rankingDimensionIndicator = accentYellow;

  // 头图背景图蒙版：顶部轻压暗、上部透出插画、底部融入暗色背景。
  static const Color rankingHeroScrimTop = Color(0x59090E17);
  static const Color rankingHeroScrimMid = Color(0x8C090E17);

  /// 固定头图已按最终视觉导出，不再额外降低透明度。
  static const double rankingHeroImageLayerOpacity = 1.0;

  // 书籍详情头图底部渐隐（375×190，长过渡避免生硬切边）。
  static const Color bookDetailHeroScrimClear = Color(0x00090E17);
  static const Color bookDetailHeroScrimLight = Color(0x1A090E17);
  static const Color bookDetailHeroScrimSoft = Color(0x66090E17);
  static const Color bookDetailHeroScrimMid = Color(0xA3090E17);
  static const Color bookDetailHeroScrimHeavy = Color(0xD9090E17);

  // 搜索页（深色态）
  /// 顶栏「搜索」动作文字色，沿用深色态强调色。
  static const Color searchActionText = accentYellow;

  /// 封面「连载 / 完结」角标：半透明深底 + 白字。
  static const Color searchStatusBadgeBackground = Color(0x99090E17);
  static const Color searchStatusBadgeText = textOnDark;

  /// 输入框光标色。
  static const Color searchCursor = accentYellow;

  /// 分类页次级筛选选中文字：比主分类弱一档，避免多行筛选同时抢焦点。
  static const Color categoryFilterSecondarySelectedText = Color(0xD9FFFFFF);
}
