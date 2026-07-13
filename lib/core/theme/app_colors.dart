import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_palette.dart';

/// 全局颜色 token（语义层），禁止在 UI 中直接使用 [Color] 字面量。
/// 原色真源在 [AppPalette]；本层给原色起全局语义名，并做深浅主题翻转。
abstract final class AppColors {
  // ── 中性色阶：白色透明度（深色态叠加语义名，指向 AppPalette）──
  static const Color white00 = AppPalette.white00;
  static const Color white04 = AppPalette.white04;
  static const Color white05 = AppPalette.white05;
  static const Color white06 = AppPalette.white06;
  static const Color white08 = AppPalette.white08;
  static const Color white20 = AppPalette.white20;
  static const Color white24 = AppPalette.white24;
  static const Color white30 = AppPalette.white30;
  static const Color white50 = AppPalette.white50;
  static const Color white60 = AppPalette.white60;
  static const Color white85 = AppPalette.white85;
  static const Color white100 = AppPalette.white100;

  // ── 中性色阶：黑色透明度（遮罩 / 蒙版语义名，指向 AppPalette）──
  static const Color black00 = AppPalette.black00;
  static const Color black04 = AppPalette.black04;
  static const Color black08 = AppPalette.black08;
  static const Color black30 = AppPalette.black30;
  static const Color black40 = AppPalette.black40;
  static const Color black60 = AppPalette.black60;
  static const Color black80 = AppPalette.black80;

  // ── 浅色实验包（THEME=pink_light）中性翻转开关与源值 ──
  // 深色态用白色叠加（whiteNN）做卡片/玻璃/分割，浅底会失效；浅色实验时
  // 这些语义 token 翻到浅底相应值（深墨 ink + 浅粉面 + 黑色低透明叠加）。
  // 默认深色 [_isLight]=false，所有翻转项走 else 分支，取值与改动前逐字节一致。
  static const bool _isLight = AppBrandColors.isLightExperiment;
  static const Color _inkPrimary = AppBrandColors.textPrimary; // #1A1A2E
  static const Color _inkMuted = AppBrandColors.textSecondary; // #6B7280
  static const Color _inkPlaceholder = AppBrandColors.originalPriceMuted; // #9B9B9B
  static const Color _lightCard = surface; // #FFFFFF
  static const Color _lightBorder = AppPalette.pinkBorder; // 浅粉卡片描边
  static const Color _lightDivider = divider; // #F3F4F6

  static const Color background = AppPalette.paperCool;
  static const Color surface = AppPalette.white100;

  static const Color textPrimary = AppPalette.ink;
  static const Color textSecondary = AppPalette.inkMuted;
  static const Color textOnPrimary = AppPalette.white100;

  static const Color border = AppPalette.hairline;
  static const Color divider = AppPalette.line;

  static const Color success = AppBrandColors.success;
  static const Color warning = AppBrandColors.warning;
  static const Color error = AppBrandColors.error;

  // Design Token v1.0 · 语义强调色扩展（源色见 AppBrandColors，暂未接入页面）
  static const Color premiumGold = AppBrandColors.premiumGold;
  static const Color info = AppBrandColors.info;
  static const Color fantasyPurple = AppBrandColors.fantasyPurple;
  static const Color energyCyan = AppBrandColors.energyCyan;
  static const Color growthBlue = AppBrandColors.growthBlue;

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

  /// 顶/底 Chrome 毛玻璃半透明底色（约 60% 不透明，弱化内容透出）。
  static const Color chromeBarScrim = bgTint60;

  /// 底部导航毛玻璃底色（约 90% 不透明，减少透出下方内容）。
  static const Color bottomNavScrim = bgTint90;

  /// 顶栏滚动后毛玻璃底色：更接近页面背景，避免头图文字透出干扰导航。
  static const Color topChromeBarScrolledScrim = bgTint80;
  static const Color topBarHeroScrimStart = black30;
  static const Color topBarHeroScrimEnd = black00;

  static const Color surfaceGlass = _isLight ? _lightCard : white04;
  static const Color surfaceCard = _isLight ? _lightCard : white04;

  /// 骨架屏底色 / 扫光高光（深色复用中性白阶：底 8%、高光 24%；浅色用黑低透明）。
  static const Color shimmerBase = _isLight ? black04 : white08;
  static const Color shimmerHighlight = _isLight ? black08 : white24;
  static const Color surfaceMuted = AppBrandColors.surfaceMuted;
  static const Color auroraGlow = AppBrandColors.auroraGlow;
  static const Color auroraEdge = AppBrandColors.auroraEdge;
  static const Color dialogBackground = AppBrandColors.dialogBackground;
  static const Color accentYellow = AppBrandColors.accent;

  /// 主强调 4% 不透明度填充（开启 / 选中态大色块底色）：深色黄 4%，浅色实验粉 4%。
  static const Color accentYellow04 =
      _isLight ? AppPalette.brandPink04 : AppPalette.brandYellow04;

  /// 礼花 / 庆祝动效多彩粒子配色（节日色，取品牌多色）。
  static const List<Color> confettiPalette = [
    AppBrandColors.accent, // 黄
    AppBrandColors.vipGradientEnd, // 粉
    AppBrandColors.brandBlueAccent, // 蓝
    AppBrandColors.partnerPrimary, // 玫红
    AppBrandColors.accentOrange, // 橙
    AppBrandColors.success, // 绿
  ];

  static const Color textOnDark = _isLight ? _inkPrimary : white100;
  static const Color textOnDarkMuted = _isLight ? _inkMuted : white50;
  static const Color textOnDarkPlaceholder = _isLight ? _inkPlaceholder : white60;
  static const Color sectionActionIcon = _isLight ? _inkPlaceholder : white60;

  /// 热门搜索置顶热词强调色（复用品牌橙）。
  static const Color searchHotAccent = AppBrandColors.accentOrange;
  static const Color iconMuted = AppBrandColors.iconMuted;
  static const Color iconMutedSecondary = AppBrandColors.iconMutedSecondary;
  static const Color navActiveBackground = AppPalette.white100;
  static const Color navActiveText = AppPalette.shellDark;

  /// accent 色面上的文字 / 图标：深色态深墨（黄底上）；浅色实验态白（粉底上可读）。
  static const Color onAccent = _isLight ? white100 : navActiveText;
  static const Color navBarBackground = _isLight ? black04 : white20;
  static const Color topBarIconFrameBackground = white08;
  static const Color topBarIconFrameBorder = white04;
  static const Color borderGlass = _isLight ? _lightBorder : white04;
  static const Color dividerOnDark = _isLight ? _lightDivider : white08;
  static const Color discussionFilterSelectedBackground =
      _isLight ? accentYellow : white100;
  static const Color discussionFilterUnselectedText = white60;
  static const Color discussionItemReplyBackground = white06;
  static const Color discussionLikeIcon = white60;
  static const Color bookDetailUpdateDate = white50;
  static const Color bookDetailUpdateHighlight = AppPalette.bookUpdateHighlight;
  static const Color bookDetailUpdateDateHighlighted = bookDetailUpdateHighlight;
  static const Color bookDetailUpdateLine = white20;
  static const Color bookDetailUpdateDotBorder = white50;
  static const Color bookDetailUpdateDotBorderHighlighted = bookDetailUpdateHighlight;
  static const Color bookDetailUpdateDotInner = white100;
  static const Color bookDetailUpdateText = white85;
  static const Color bookDetailUpdateTextHighlighted = bookDetailUpdateHighlight;
  static const Color bookDetailUpdateSectionBackground = white05;

  // 书籍详情悬浮促销条 (Figma 1598:4319)
  static const Color bookDetailPromoGradientStart =
      AppBrandColors.promoBarGradientStart;
  static const Color bookDetailPromoGradientMid =
      AppBrandColors.promoBarGradientMid;
  static const Color bookDetailPromoGradientEnd =
      AppBrandColors.promoBarGradientEnd;
  static const Color bookDetailPromoTitle = white100;
  static const Color bookDetailPromoSubtitle = AppBrandColors.promoSubtitle;
  static const Color bookDetailPromoRewardText = AppBrandColors.promoRewardText;
  static const Color bookDetailPromoCloseIcon = white100;

  static const Color guessLikeCardBackground = white05;
  static const Color guessLikeTagBackground = white04;
  static const Color guessLikeTagBorder = white04;
  static const Color gradientFadeStart = bgTint00;
  static const Color gradientFadeMid = bgTint90;
  static const Color gradientFadeEnd = backgroundDark;
  static const Color coverBorder = black04;
  static const Color overlayScrim = black30;

  /// 榜单名次角标（第 4 名起）深色底：60% 黑，保证白色名次数字清晰可读。
  static const Color rankingMutedBadgeScrim = black60;

  /// 按钮不可点击（禁用）态：4% 纯白填充 + 30% 白字，全局统一（覆盖各变体）。
  static const Color buttonDisabledFill = white04;
  static const Color buttonDisabledText = white30;

  /// 弹窗遮罩（80% 不透明黑，无背景模糊）。
  static const Color overlayScrim80 = black80;

  /// 书架管理态封面遮罩（未选中，压暗封面突出选择框）。
  static const Color bookshelfManageCoverOverlay = black60;

  /// 书架管理态封面遮罩（已选中，略浅以保留选中反馈）。
  static const Color bookshelfManageCoverOverlaySelected = black40;

  /// 书架管理态未选中选择框描边（60% 白）。
  static const Color bookshelfSelectionMarkBorderUnselected = white20;

  /// 书架空态文案（Figma 1319:9953）。
  static const Color bookshelfEmptyText = AppPalette.emptyGray;

  /// 封面右上角状态角标「完结」半透明深底（Figma 1335:12223）。
  static const Color bookCoverTagCompletedScrim = black60;

  // 我的页头图 alpha 蒙版（Figma 400:2302 / 205:5742）
  static const Color profileHeroImageMaskOpaque = white100;
  static const Color profileHeroImageMaskSoft = white24;
  static const Color profileHeroImageMaskTransparent = white00;

  // 全局分段控件 (Figma 1297:827)：深色黄 8%，浅色实验粉 8%（随主强调）。
  static const Color segmentedSelectedFill =
      _isLight ? AppPalette.brandPink14 : AppPalette.brandYellow14;
  // 选中态去描边（全局统一）：仅靠 fill + 文字色区分选中
  static const Color segmentedSelectedBorder = white00;
  static const Color segmentedSelectedText = accentYellow;
  static const Color segmentedUnselectedText = textOnDarkPlaceholder;

  // 榜单详情页 (Figma 220:8376)
  static const Color rankingHeroTitle = AppBrandColors.rankingHeroTitle;
  static const Color rankingHeroSubtitle = AppPalette.rankingSubtitle;
  static const Color rankingSegmentedSelectedText = AppBrandColors.textOnLightPanel;
  static const Color rankingCircleButtonBackground = black30;
  static const Color rankingDimensionIndicator = accentYellow;

  // 头图背景图蒙版（图上遮罩，双职责已拆分）：深色态随主题壳基色渐隐；
  // 浅色实验态改用黑色低透明，保证头图上白色文字仍可读（不随浅背景变浅）。
  static const Color rankingHeroScrimTop = _isLight ? black30 : bgTint35;
  static const Color rankingHeroScrimMid = _isLight ? black40 : bgTint55;

  /// 固定头图已按最终视觉导出，不再额外降低透明度。
  static const double rankingHeroImageLayerOpacity = 1.0;

  // 搜索页（深色态）
  /// 顶栏「搜索」动作文字色，沿用深色态强调色。
  static const Color searchActionText = accentYellow;

  /// 封面「连载 / 完结」角标：半透明深底 + 白字（图上遮罩，浅色实验态恒暗保可读）。
  static const Color searchStatusBadgeBackground = _isLight ? black60 : bgTint60;
  static const Color searchStatusBadgeText = textOnDark;

  /// 输入框光标色。
  static const Color searchCursor = accentYellow;

  /// 分类页次级筛选选中文字：比主分类弱一档，避免多行筛选同时抢焦点。
  static const Color categoryFilterSecondarySelectedText = white85;

  // 我的消息（互动消息列表）——语义均复用既有色值，未引入新色。
  /// Tab 未读数字红点底（复用 error 红）。
  static const Color badgeCount = error;

  /// 「作者」标识底（复用品牌黄）。
  static const Color authorBadgeBackground = accentYellow;

  /// 「作者」标识字（accent 徽底上的字：深色态深墨 / 浅色态白）。
  static const Color authorBadgeText = onAccent;

  /// 消息条目内书籍引用块底。
  static const Color myMessagesBookRefBackground = white05;

  /// 消息条目内引用书评左侧竖条。
  static const Color myMessagesQuoteBar = white20;

  /// 通知「NEW / 未读」标识（复用品牌橙）。
  static const Color myMessagesNoticeBadge = searchHotAccent;

}
