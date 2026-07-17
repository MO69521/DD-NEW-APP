import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_palette.dart';

/// 全局颜色 token（语义层），禁止在 UI 中直接使用 [Color] 字面量。
/// 原色真源在 [AppPalette]；本层给原色起全局语义名，并做深浅主题翻转。
abstract final class AppColors {
  // ── 中性色阶：白色透明度（深色态叠加语义名，指向 AppPalette）──
  static const Color white00 = AppPalette.whiteAlpha00;
  static const Color white04 = AppPalette.whiteAlpha04;
  static const Color white05 = AppPalette.whiteAlpha05;
  static const Color white06 = AppPalette.whiteAlpha06;
  static const Color white08 = AppPalette.whiteAlpha08;
  static const Color white20 = AppPalette.whiteAlpha20;
  static const Color white24 = AppPalette.whiteAlpha24;
  static const Color white30 = AppPalette.whiteAlpha30;
  static const Color white50 = AppPalette.whiteAlpha50;
  static const Color white60 = AppPalette.whiteAlpha60;
  static const Color white85 = AppPalette.whiteAlpha85;
  static const Color white100 = AppPalette.whiteAlpha100;

  // ── 中性色阶：黑色透明度（遮罩 / 蒙版语义名，指向 AppPalette）──
  static const Color black00 = AppPalette.blackAlpha00;
  static const Color black04 = AppPalette.blackAlpha04;
  static const Color black08 = AppPalette.blackAlpha08;
  static const Color black30 = AppPalette.blackAlpha30;
  static const Color black40 = AppPalette.blackAlpha40;
  static const Color black60 = AppPalette.blackAlpha60;
  static const Color black80 = AppPalette.blackAlpha80;

  // ── 核心语义 token（跨组件复用职责）──
  // 组件底色 / 边线 / 文本优先走实体中性色；透明阶仅保留给遮罩、蒙版、扫光等 effect。
  static const bool _isLight = AppBrandColors.isLightExperiment;
  static const Color _inkPrimary = AppBrandColors.textPrimary; // #1A1A2E
  static const Color _inkMuted = AppBrandColors.textSecondary; // #6B7280
  static const Color _inkPlaceholder =
      AppBrandColors.originalPriceMuted; // #9B9B9B
  static const Color _lightCard = AppPalette.neutralWhite; // #FFFFFF
  // 浅色卡片描边：pink_light 浅粉 / yellow_light 中性浅灰（真源在 AppBrandColors）。
  static const Color _lightBorder = AppBrandColors.lightCardBorder;
  static const Color _lightDivider = AppPalette.neutralCool100; // #F3F4F6
  static const Color _darkTextPrimary = AppPalette.neutralWhite;
  static const Color _darkTextSecondary = AppPalette.neutralCool400;
  static const Color _darkTextTertiary = AppPalette.neutralCool500;
  static const Color _darkSurface = AppPalette.neutralCool900;
  static const Color _darkSurfaceSoft = AppPalette.neutralCool920;
  // 深色态描边统一改用 4% 纯白（whiteAlpha04）：低透明叠加、随底自然融合，
  // 替代原实体中性色 neutralCool800（全局边框同源，一处改全局生效）。
  static const Color _darkBorder = AppPalette.whiteAlpha04;
  static const Color _darkDivider = AppPalette.neutralCool820;

  static const Color primary = AppBrandColors.accent;
  // 主色上的文字/图标跟随强调色身份（粉底翻白、黄底深墨），而非浅色标志：
  // 避免 yellow_light 亮黄底上出现不可读的白字。
  static const Color onPrimary = AppBrandColors.onAccent;
  static const Color primarySoft = AppBrandColors.accentSoft04;

  static const Color background = AppBrandColors.backgroundDark;
  static const Color surface = _isLight ? _lightCard : _darkSurface;
  static const Color surfaceSoft = _isLight
      ? AppPalette.neutralCool50
      : _darkSurfaceSoft;
  static const Color surfaceElevated = AppBrandColors.dialogBackground;

  static const Color textPrimary = _isLight ? _inkPrimary : _darkTextPrimary;
  static const Color textSecondary = _isLight ? _inkMuted : _darkTextSecondary;
  static const Color textTertiary = _isLight
      ? _inkPlaceholder
      : _darkTextTertiary;
  static const Color textOnPrimary = onPrimary;

  static const Color borderSubtle = _isLight ? _lightBorder : _darkBorder;
  static const Color border = AppPalette.neutralCool200;
  static const Color divider = _isLight ? _lightDivider : _darkDivider;

  static const Color success = AppBrandColors.success;
  static const Color warning = AppBrandColors.warning;
  static const Color error = AppBrandColors.error;

  // Design Token v1.0 · 语义强调色扩展（源色见 AppBrandColors，暂未接入页面）
  static const Color premiumGold = AppBrandColors.premiumGold;
  static const Color info = AppBrandColors.info;
  static const Color fantasyPurple = AppBrandColors.fantasyPurple;
  static const Color energyCyan = AppBrandColors.energyCyan;
  static const Color growthBlue = AppBrandColors.growthBlue;

  // ── 旧语义兼容别名 / 主题源色 ──
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

  /// 顶/底 Chrome 毛玻璃半透明底色（约 80% 不透明，弱化内容透出）。
  static const Color chromeBarScrim = bgTint80;

  /// 底部导航底色：浅色态纯白不透明（`white100`）；深色态与页面壳同色不透明
  /// （`backgroundDark`）。全主题底栏统一实心底，不磨砂透出背后内容。
  static const Color bottomNavScrim = _isLight ? white100 : backgroundDark;

  /// 底部导航「纹理需透出」时的叠色 scrim（约 60% 壳基色 tint）。
  /// 当前底栏默认用不透明 [bottomNavScrim] 盖住纹理；设计需透出时改接线此 token。
  static const Color bottomNavTextureScrim = bgTint60;

  /// 顶栏滚动后底色（仅 `AppPageChrome`，如书城等 Tab 页）：深色态毛玻璃（约 80% tint）；
  /// 浅色态纯白不透明（`white100`）。书详情顶栏走 `chromeBarScrim`，不受此影响、保持磨砂。
  static const Color topChromeBarScrolledScrim = _isLight ? white100 : bgTint80;
  static const Color topBarHeroScrimStart = black30;
  static const Color topBarHeroScrimEnd = black00;

  // ── 旧语义兼容别名：逐步迁移到 primary / surface / text* / border* / divider ──
  static const Color surfaceGlass = surface;
  static const Color surfaceCard = surface;

  /// 骨架屏底色 / 扫光高光（深色复用中性白阶：底 8%、高光 24%；浅色用黑低透明）。
  static const Color shimmerBase = _isLight ? black04 : white08;
  static const Color shimmerHighlight = _isLight ? black08 : white24;
  static const Color surfaceMuted = AppBrandColors.surfaceMuted;
  static const Color auroraGlow = AppBrandColors.auroraGlow;
  static const Color auroraEdge = AppBrandColors.auroraEdge;
  static const Color dialogBackground = surfaceElevated;
  static const Color accentYellow = primary;

  /// 主强调 4% 不透明度填充（开启 / 选中态大色块底色）：深色黄 4%，浅色实验粉 4%。
  static const Color accentYellow04 = primarySoft;

  /// 礼花 / 庆祝动效多彩粒子配色（节日色，取品牌多色）。
  static const List<Color> confettiPalette = [
    AppBrandColors.accent, // 黄
    AppBrandColors.vipGradientEnd, // 粉
    AppBrandColors.brandBlueAccent, // 蓝
    AppBrandColors.partnerPrimary, // 玫红
    AppBrandColors.accentOrange, // 橙
    AppBrandColors.success, // 绿
  ];

  static const Color textOnDark = textPrimary;
  static const Color textOnDarkMuted = textSecondary;
  static const Color textOnDarkPlaceholder = textTertiary;
  static const Color sectionActionIcon = textTertiary;

  /// 热门搜索置顶热词强调色（复用品牌橙）。
  static const Color searchHotAccent = AppBrandColors.accentOrange;

  /// 分页指示器未选中态颜色：深色态白 20%，浅色态浅灰（适配三主题）。
  static const Color pageDotInactive = _isLight
      ? AppPalette
            .neutralCool300 // #B2B3BA 浅灰，浅色主题可见
      : white20;

  static const Color iconMuted = AppBrandColors.iconMuted;
  static const Color iconMutedSecondary = AppBrandColors.iconMutedSecondary;
  static const Color navActiveBackground = AppPalette.neutralWhite;
  static const Color navActiveText = AppPalette.neutralCool950;

  /// accent 色面上的文字 / 图标：深色态深墨（黄底上）；浅色实验态白（粉底上可读）。
  static const Color onAccent = onPrimary;
  static const Color navBarBackground = _isLight ? black04 : surface;
  // 顶栏圆形磨砂图标框底：深色态纯白 4%（whiteAlpha04）；浅色态头图偏亮，
  // 4% 几乎不可见，故提高到纯白 30%（white30）。配 BackdropFilter 呈磨砂玻璃。
  static const Color topBarIconFrameBackground = _isLight ? white30 : white04;
  // 磨砂图标框压在头图上，恒暗弱描边（两态皆低透明白）。
  static const Color topBarIconFrameBorder =
      _darkBorder; // light-audit: keep-dark
  static const Color borderGlass = borderSubtle;
  static const Color dividerOnDark = divider;
  static const Color discussionFilterSelectedBackground = _isLight
      ? accentYellow
      : white100;
  static const Color discussionFilterUnselectedText = textOnDarkPlaceholder;
  static const Color discussionItemReplyBackground = surfaceSoft;
  static const Color discussionLikeIcon = textOnDarkPlaceholder;
  static const Color bookDetailUpdateDate = textOnDarkMuted;
  static const Color bookDetailUpdateHighlight = AppPalette.tan400;
  static const Color bookDetailUpdateDateHighlighted =
      bookDetailUpdateHighlight;
  static const Color bookDetailUpdateLine = dividerOnDark;
  static const Color bookDetailUpdateDotBorder = textOnDarkMuted;
  static const Color bookDetailUpdateDotBorderHighlighted =
      bookDetailUpdateHighlight;
  static const Color bookDetailUpdateDotInner = textOnDark;
  static const Color bookDetailUpdateText = textOnDark;
  static const Color bookDetailUpdateTextHighlighted =
      bookDetailUpdateHighlight;
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

  // 猜你喜欢卡：浅色实验态卡片底为纯白实体面（surface）；深色态弱容器面（surfaceSoft）。
  static const Color guessLikeCardBackground = _isLight ? surface : surfaceSoft;
  static const Color guessLikeTagBackground = surface;
  static const Color guessLikeTagBorder = borderSubtle;
  static const Color gradientFadeStart = bgTint00;
  static const Color gradientFadeMid = bgTint90;
  static const Color gradientFadeEnd = backgroundDark;
  static const Color coverBorder = black04;
  static const Color overlayScrim = black30;

  /// 榜单名次角标（第 4 名起）深色底：60% 黑，保证白色名次数字清晰可读。
  static const Color rankingMutedBadgeScrim = black60;

  /// 榜单名次角标（第 4 名起）数字字色：全主题恒白（含浅粉/浅黄）。
  static const Color rankingMutedBadgeText = white100; // light-audit: keep-dark

  /// 按钮不可点击（禁用）态，全局统一（覆盖各变体）。主题感知：
  /// 深色态沿用弱实体面 + 三级字；浅色态用半透明强调色底（pink_light 玫粉 /
  /// yellow_light 黄）+ 85% 白字，避免深色块落在浅底弹窗上显得错误。
  static const Color buttonDisabledFill = _isLight
      ? AppBrandColors.accentDisabledFill
      : _darkSurface;
  static const Color buttonDisabledText = _isLight
      ? white85
      : _darkTextTertiary;

  /// 弹窗遮罩（80% 不透明黑，无背景模糊）。
  static const Color overlayScrim80 = black80;

  /// 书架管理态封面遮罩（未选中，压暗封面突出选择框）。
  static const Color bookshelfManageCoverOverlay = black60;

  /// 书架管理态封面遮罩（已选中，略浅以保留选中反馈）。
  static const Color bookshelfManageCoverOverlaySelected = black40;

  /// 书架管理态未选中选择框描边（压在封面缩略图上，随封面恒暗，不随页面主题翻）。
  static const Color bookshelfSelectionMarkBorderUnselected =
      _darkDivider; // light-audit: keep-dark

  /// 书架空态文案（Figma 1319:9953）。
  static const Color bookshelfEmptyText = AppPalette.neutralGray700;

  /// 封面右上角状态角标「完结 / 连载」半透明深底（Figma 1335:12223；压在封面上，浅色实验态恒暗）。
  static const Color bookCoverTagCompletedScrim =
      black60; // light-audit: keep-dark

  /// 封面角标「完结 / 连载」字色：纯白实体（压在封面上，浅色实验态恒白）。
  static const Color bookCoverTagCompletedText =
      white100; // light-audit: keep-dark

  /// 封面角标「完结 / 连载」描边：纯黑 4%（`hairline` 0.5px 由组件指定宽度）。
  static const Color bookCoverTagCompletedBorder =
      black04; // light-audit: keep-dark

  /// 封面角标「更新」描边：纯白 4%（`hairline` 0.5px 由组件指定宽度）。
  static const Color bookCoverTagUpdatedBorder =
      white04; // light-audit: keep-dark

  /// 卡片彩色角标字色（充值「热」/ 免费领取「0/300每日」/ 会员标等）：全主题恒白。
  static const Color cornerBadgeText = white100; // light-audit: keep-dark

  /// 区块右侧胶囊操作入口底（「更多福利」「完整榜单」等）：纯黑 4%，全主题统一。
  static const Color sectionMoreActionBackground = black04;

  // 我的页头图 alpha 蒙版（Figma 400:2302 / 205:5742）
  static const Color profileHeroImageMaskOpaque = white100;
  static const Color profileHeroImageMaskSoft = white24;
  static const Color profileHeroImageMaskTransparent = white00;

  // 全局分段控件 (Figma 1297:827)：随主强调 8%（dark/yellow_light 黄 8%、pink_light 粉 8%）。
  static const Color segmentedSelectedFill = AppBrandColors.accentSoft08;
  // 选中态去描边（全局统一）：仅靠 fill + 文字色区分选中
  static const Color segmentedSelectedBorder = white00;
  static const Color segmentedSelectedText = accentYellow;
  static const Color segmentedUnselectedText = textOnDarkPlaceholder;

  // 榜单详情页 (Figma 220:8376)
  static const Color rankingHeroTitle = AppBrandColors.rankingHeroTitle;
  static const Color rankingHeroSubtitle = AppPalette.cream200Alpha90;
  static const Color rankingSegmentedSelectedText =
      AppBrandColors.textOnLightPanel;
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
  static const Color searchStatusBadgeBackground = _isLight
      ? black60
      : bgTint60;
  static const Color searchStatusBadgeText = textOnDark;

  /// 输入框光标色。
  static const Color searchCursor = accentYellow;

  /// 分类页次级筛选选中文字：比主分类弱一档，避免多行筛选同时抢焦点。
  static const Color categoryFilterSecondarySelectedText = textOnDark;

  // 我的消息（互动消息列表）——语义均复用既有色值，未引入新色。
  /// Tab 未读数字红点底（复用 error 红）。
  static const Color badgeCount = error;

  /// 「作者」标识底（复用品牌黄）。
  static const Color authorBadgeBackground = accentYellow;

  /// 「作者」标识字（accent 徽底上的字：深色态深墨 / 浅色态白）。
  static const Color authorBadgeText = onAccent;

  /// 消息条目内书籍引用块底。
  static const Color myMessagesBookRefBackground = surfaceSoft;

  /// 消息条目内引用书评左侧竖条。
  static const Color myMessagesQuoteBar = divider;

  /// 通知「NEW / 未读」标识（复用品牌橙）。
  static const Color myMessagesNoticeBadge = searchHotAccent;

  // 书城「继续阅读」浮层：全主题保持深色壳样式（不随浅色包翻转）。
  static const Color continueReadingCardBackground =
      AppPalette.neutralCool800; // light-audit: keep-dark
  static const Color continueReadingCardBorder =
      AppPalette.whiteAlpha04; // light-audit: keep-dark
  static const Color continueReadingCaptionText =
      AppPalette.neutralCool500; // light-audit: keep-dark
  static const Color continueReadingTitleText =
      AppPalette.neutralWhite; // light-audit: keep-dark
  static const Color continueReadingCloseIcon =
      AppPalette.neutralCool400; // light-audit: keep-dark
}
