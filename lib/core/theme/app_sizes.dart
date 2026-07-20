/// 全局尺寸 token（Figma 精确值），禁止在 UI 组件内写死 layout 数值。
///
/// 说明：本文件是**尺寸 token 的唯一真源**（扁平数据集合，非 widget/逻辑），
/// 经确认豁免架构规范 §11「文件 > 300 行必须拆分」——与 `app_text_styles.dart` 同属
/// token registry 例外。Dart 无法将单个类跨文件拆分（`part` 不能向类追加成员），
/// 按 feature 拆分需引入多个类并迁移约 170 个文件的调用点，收益低于风险，故维持单文件。
/// 分组导航见 `design-system/README.md` §6.5。
abstract final class AppSizes {
  // ── 通用 ──
  static const double hairline = 0.5;
  static const double borderWidthEmphasis = 1.5;
  static const double iconSm = 14;
  static const double splashLogoSize = 100;

  // ── 通用按压反馈 (AppPressable) ──
  /// 手指按下时缩小到的比例。
  static const double tapPressScale = 0.94;

  /// 全宽列表行等大面积模块的柔和按下比例（缩放幅度更小，避免整行大幅位移）。
  static const double tapPressScaleSubtle = 0.97;

  /// 反弹时放大越过原尺寸的 overshoot 峰值比例。
  static const double tapPressReboundScale = 1.05;

  // ── 跑马灯 (AppMarqueeText) ──
  /// 文本溢出时横向滚动速度（px/s）。
  static const double marqueeSpeed = 40;

  /// 跑马灯循环时两段文本之间的间隔宽度。
  static const double marqueeGap = 48;

  /// 头图下拉回弹时的最大额外放大比例（视差 / 拉伸头图）。
  static const double heroParallaxFactor = 0.4;

  // ── 通用二级页顶栏 (AppTopBar) ──
  static const double topBarHeight = 44;
  static const double topBarCircleSize = 32;
  static const double topBarIconFrameSize = 32;
  static const double topBarIconFrameBlurSigma = 8;
  static const double topBarBackIconWidth = 14;
  static const double topBarBackIconHeight = 20;
  static const double topBarActionIconSize = 19;

  /// 右上角动作图标显示尺寸：无圆形底色，按原始设计尺寸展示（全局统一）。
  static const double topBarActionIconDisplaySize = 24;
  static const double topBarTitleMaxWidth = 220;

  // ── 通用按钮 (AppButton) ──
  static const double buttonPaddingHNormal = 24;
  static const double buttonPaddingVNormal = 16;
  static const double buttonPaddingHSmall = 16;
  static const double buttonPaddingVSmall = 8;
  static const double buttonLoadingIndicatorSize = 16;
  static const double buttonIconLabelGap = 8;
  static const double buttonIconLabelGapTight = 4;
  static const double digitCodeBoxMaxSize = 56;

  // ── 搜索栏 / 玻璃态胶囊 ──
  static const double searchBarHeight = 40;
  static const double glassBlurSigma = 4;

  /// 通用强玻璃模糊半径（重度磨砂，如任务卡 / 浮层）。
  static const double strongBlurSigma = 90;
  static const double statusBarPlaceholderHeight = 44;

  /// 顶部纹理层默认高度（全宽装饰，不占滚动布局）。
  static const double tabTopTextureHeight = 120;

  static const double bookstoreHeaderVerticalInset = 2;
  static const double chromeBarBlurSigma = 40;
  static const double bookstoreTopHeaderHeight = 44;
  static const double bookstoreSearchIconSize = 20;
  static const double bookstoreStickyHeaderHeight = bookstoreTopHeaderHeight;
  static const double bookstoreHeaderToFirstSectionGap = 8;
  static const double bookstoreLoadMoreTriggerOffset = 240;
  static const double bookstoreLoadingIndicatorSize = 20;
  static const double bookstoreLoadingIndicatorStrokeWidth = 2;
  static const double bookstoreRefreshAnimationSize = 50;

  // ── 底部导航 (Figma 353:1522 / 294:5130) ──
  static const double bottomNavBarHeight = 82;
  static const double bottomNavCapsuleWidth = 327;
  static const double bottomNavCapsuleHeight = 50;
  static const double bottomNavHorizontalInset = 24;
  static const double bottomNavBottomInset = 4;
  static const double bottomNavBlurSigma = 40;
  static const double bottomNavIconSize = 26;
  static const double bottomNavSelectedIconPeakScale = 1.18;
  static const double bottomNavSelectedIconDipScale = 0.92;
  static const double bottomNavItemHeight = 42;
  static const double bottomNavIconLabelGap = 2;
  static const double bottomNavItemContentTopInset = 0;
  static const double bottomNavItemContentBottomInset = 4;

  // 首页「继续阅读」浮层卡片
  // 封面放大并溢出卡片顶部（悬浮抬起效果），配阴影
  static const double continueReadingCoverWidth = 40;
  static const double continueReadingCoverHeight = 50;
  static const double continueReadingCoverShadowBlur = 12;
  static const double continueReadingCloseIconSize = 16;
  // 背景层：放大封面（宽度撑满卡片、居中）叠加页面背景，做模糊 + 半透明
  static const double continueReadingBgBlurSigma = 60;
  static const double continueReadingBgImageOpacity = 0.9;

  // 首页「限时免费」倒计时数字块：1:1 正方形，居中容纳两位数
  static const double limitedFreeCountdownBoxSize = 18;

  // 我的页「我的成就」勋章模块
  static const double profileAchievementMedalSize = 52;
  static const double profileAchievementActionIconSize = 12;
  static const double homeIndicatorWidth = 134;
  static const double homeIndicatorHeight = 5;

  // ── 榜单 (Figma 456:12299) ──
  static const double tabIndicatorWidth = 24;
  static const double tabIndicatorHeight = 3;
  static const double tabSlotWidthSm = 55;
  static const double tabSlotWidthMd = 72;
  static const double rankingTabSlotWidth = 55;
  static const double rankingHeaderActionTopInset = 5;
  static const double rankingHeaderActionBottomInset = 4;
  static const double rankingFullListIconSize = 12;
  static const double rankingCarouselItemWidth = 132;
  static const int rankingCarouselMaxItems = 7;
  static const int rankingGridMaxItems = 6;
  static const double rankingRowCoverWidth = 74;
  static const double bookCoverRankingAspectRatio = 132 / 179;
  static const double rankingTopBadgeSize = 24;
  static const double rankingMutedBadgeSize = 20;
  static const double rankingCompactTextBlockHeight = 66;

  // ── 书籍封面 ──
  static const double bookCoverListWidth = 50;
  static const double bookCoverListHeight = 68;
  static const double bookCoverGridAspectRatio = 56 / 76;
  static const double bookGridTitleCategoryGap = 8;
  static const double bookGridTextBlockHeight = 56;
  static const double bookGridCoverToTextGap = 8;

  // ── 网格尺寸 ──
  static const double rankingGridDesignItemWidth = 151.5;
  static const double rankingGridItemHeight = bookCoverListHeight;
  static const double editorPickGridAspectRatio = 0.48;
  static const double guessLikeGridAspectRatio = 0.55;

  // ── 福利页 (Figma 294:4943) ──
  static const double welfareHeaderHeight = 44;

  /// 福利页头部装饰渐变高度（用户指定 300，较默认 [tabTopTextureHeight] 更高）。
  static const double welfareTabTopTextureHeight = 300;
  static const double welfareCurrencyBarHeight = 76;
  static const double welfareVipBannerHeight = 49;
  static const double welfareRechargeCardHeight = 140;
  static const double welfareRechargeIllustrationWidth = 76;
  static const double welfareRechargeHotBadgeWidth = 33;
  static const double welfareRechargeHotBadgeHeight = 18;
  static const double welfareRechargePriceButtonHeight = 28;
  static const double welfareCheckInMilestoneHeight = 70;
  static const double welfareCheckInProgressLineHeight = 4;
  static const double welfareCheckInProgressLineCenterY = 35;
  static const double welfareCheckInProgressLineTop =
      welfareCheckInProgressLineCenterY - welfareCheckInProgressLineHeight / 2;
  static const double welfareCheckInProgressDotSize = 12;
  static const double welfareCheckInProgressDotBorderWidth = 2;
  static const double welfareCheckInMilestoneBubbleHeight = 26;
  static const double welfareCheckInMilestoneBubbleAreaWidth = 46;
  static const double welfareCheckInMilestoneBubbleAreaWidthWide = 48;
  static const double welfareCheckInMilestoneBubbleAreaHeight = 41;
  static const double welfareCheckInMilestoneBubbleGraphicHeight = 21.6482;
  static const double welfareCheckInMilestoneDotTop = 24;
  static const double welfareCheckInDayHeaderPaddingTop = 5;
  static const double welfareCheckInDayHeaderPaddingBottom = 4;
  static const double welfareCheckInDayBodyPaddingVertical = 6;
  static const double welfareCheckInCumulativePadding = 8;
  static const double welfareCheckInCtaPaddingHorizontal = 28;
  static const double welfareCheckInCtaPaddingVertical = 14;
  static const double welfareCheckInChevronSize = 16;
  static const double welfareCheckInClaimedRewardOpacity = 0.3;

  /// 已签到日：奖励图标更淡（Figma 10%）。
  static const double welfareCheckInClaimedIconOpacity = 0.1;

  /// 签到成功弹窗头部：能量图标圆底与图标尺寸（Figma 1568:2048/2126）。
  static const double welfareCheckInSuccessBadgeSize = 66;
  static const double welfareCheckInSuccessBadgeIconSize = 40;

  // ── 新手基础信息收集弹窗 ──
  /// 性别头像圆底直径。
  static const double onboardingGenderAvatarSize = 80;

  /// 步骤内容视口固定高度（PageView 跟手切换需有界高度，取较高的步骤——
  /// 年龄步骤 4 个加高选项 + 标签，取整留余量避免溢出）。
  static const double onboardingStepViewportHeight = 288;

  /// 「— 选择性别 —」标签两侧短线长度。
  static const double onboardingSectionLabelLineWidth = 20;

  /// 统一分页指示点：圆点直径与选中点拉长宽度（会员轮播 / 新手引导共用）。
  static const double pageDotSize = 4;
  static const double pageDotActiveWidth = 8;
  static const double welfareCheckInClaimedCheckSize = 24;
  static const double welfareCheckInCtaHeight = 42;
  static const double welfareCheckInDayWideMinWidth = 132;
  static const double welfareCurrencyIconSize = 16;
  static const double welfareCurrencyArrowSize = 12;
  static const double welfareCurrencyDividerHeight = 15;
  static const double welfareCurrencyAmountFontSize = 24;
  static const double welfareCurrencyBlurSigma = 16;
  static const double welfareRechargeIllustrationHeight = 52;
  static const double welfareVipBadgeSize = 24;
  static const double welfareVipBadgeTextGap = 8;
  static const double welfareVipTextIconGap = 4;
  static const double welfareVipCtaPaddingHorizontal = 12;
  static const double welfareVipCtaPaddingVertical = 8;
  static const double welfareVipCtaBorderWidth = 0.8;
  static const double welfareRechargeInfoIconSize = 24;

  // ── 能量充值支付确认弹窗 ──
  static const double rechargePurchaseDialogEnergyIconSize = 16;
  static const double rechargePurchaseDialogPriceFontSize = 28;

  static const double welfareCheckInRewardIconSize = 24;
  static const double welfareCheckInSmallRewardIconSize = 12;
  static const double welfareTaskActionHeight = 30;
  static const double welfareTaskActionMinWidth = 74;
  static const double welfareTaskActionIconSize = 16;
  static const double welfareTaskRewardIconSize = 12;
  static const double welfareTaskRewardChipHeight = 18;
  static const double welfareTaskTimelineNodeWidth = 66;
  static const double welfareTaskTimelineProgressHeight = 36;
  // 限免卡切图为 72×72 方形画布，卡面本体仅占约 70×45 并带透明边距，
  // 故用方形展示框承载，使卡面渲染为 Figma 的 ≈32.5×20.4。
  static const double welfareReadingFreeCardWidth = 33;
  static const double welfareReadingFreeCardHeight = 33;
  static const double welfareTaskTimelineLineHeight = 4;
  static const double welfareTaskTimelineDotSize = 12;
  static const double welfareTaskTimelineDotBorderWidth = 2;
  static const double welfareTaskTimelineTailWidth = 10;
  static const double welfareTaskTimelineTailHeight = 4;
  static const double welfareTaskPopularIconSize = 16;
  static const double welfareTaskVipBadgeHeight = 18;
  static const double welfareTaskListVipBannerHeight = 66;

  /// 任务卡向上叠压 VIP 入口的高度：需 ≥ 任务卡圆角（`welfareCheckInSection`
  /// = 24），让 VIP 横幅的粉色延伸到任务卡圆角背后，避免两侧露出深色背景；
  /// 间距通过加大横幅底部内边距实现（见 `_TaskVipEntry`）。
  static const double welfareTaskCardOverlap = 24;

  /// 任务卡毛玻璃背景模糊半径（福利页 VIP 横幅叠压处）。
  static const double welfareTaskCardBlurSigma = 90;

  // ── 书架页 (Figma 220:9341 / 377:1909) ──
  static const double bookshelfHeaderHeight = 44;
  static const double bookshelfReadingBannerHeight = 54;
  static const double bookshelfBearIllustrationWidth = 64;
  static const double bookshelfBearIllustrationHeight = 46;
  static const double bookshelfBearIllustrationPaintHeight = 64;
  static const double bookshelfBearIllustrationLeftInset = 3;
  static const double bookshelfBearIllustrationTopInset = 8;
  static const double bookshelfReadingBannerContentInsetLeft = 72;
  static const double bookshelfHeaderToBannerGap = 18;
  static const double bookshelfBannerToGridGap = 24;
  static const double bookshelfClaimWelfareIconSize = 16;
  static const double bookshelfClaimWelfareCtaHeight = 30;
  static const double bookshelfClaimWelfareCtaPaddingHorizontal = 11;
  static const double bookshelfClaimWelfareCtaPaddingVertical = 7;
  static const double bookshelfManageActionFontSize = 14;

  /// 通用选择标记（[AppSelectionMark]）圆形直径与内部对勾尺寸（全局统一）。
  static const double selectionMarkSize = 20;
  static const double bookshelfSelectionCheckIconSize = 16;
  static const double selectionMarkCheckStrokeWidth = 1.6;
  static const double bookshelfEmptyBlockWidth = 200;
  static const double bookshelfEmptyIllustrationSize = 150;
  static const double bookshelfEmptyTopPadding = 18;
  static const double bookshelfEmptyIllustrationToTextGap = 18;
  static const double bookshelfEmptyTextToActionGap = 30;
  static const double bookshelfEmptyBottomPadding = 8;

  // ── 封面右上角状态角标（Figma 1335:12223） ──
  static const double bookCoverTagInsetTop = 4;
  static const double bookCoverTagInsetRight = 4;

  /// 封面右上角状态角标背景模糊半径（全主题统一，压在封面上磨砂可读）。
  static const double bookCoverTagBlurSigma = 8;

  // ── 轻提示 Toast ──
  static const double toastPaddingHorizontal = 20;
  static const double toastPaddingVertical = 12;
  static const double toastHorizontalMargin = 48;

  /// Tab 左右滑动切换触发的最小水平速度（像素/秒）。
  static const double swipeTabVelocityThreshold = 200;

  // ── 我的页 (Figma 205:3998) ──
  static const double profileHeroHeight = 375;

  /// 无背景 Hero 区高度：余额条顶边 (200) + 叠入 Hero 的 overlap (24) = 224。
  static const double profileHeroCompactHeight = 224;

  /// 余额条向上叠入 Hero 渐变的视觉偏移（文档流仍在其下方）。
  static const double profileBalanceBarHeroOverlap = 24;

  /// 余额条与 VIP 横幅间距（Figma 697:12412 → 697:12468）。
  static const double profileBalanceBarToVipGap = 16;
  static const double profileAvatarSize = 72;
  static const double profileMessagesIconSize = 18;
  static const double profilePartnerAvatarSize = 24;
  static const double profilePartnerAvatarGap = 6;
  static const double profileShortcutIconSize = 28;
  static const double profileShortcutIconToLabelGap = 10;
  static const double profileShortcutItemHeight = 60;
  static const double profileShortcutRowGap = 30;
  static const double profileHeroUserInfoTop = 100;
  static const double profileHeroSettingsTop = 52;
  static const List<double> profileHeroImageMaskStops = [
    0.0,
    0.604723,
    0.801425,
    1.0,
  ];

  /// 全局二级页列表行最小高度（单行基准；带副标题/多行内容在此基础上自然增高）。
  static const double listRowMinHeight = 60;

  // ── 账号设置页 ──
  static const double accountSettingsAvatarSize = 40;
  static const double accountSettingsBindingIconSize = 24;

  // ── 我的消息页 ──
  static const double myMessagesEmptyIllustrationSize = 120;
  static const double myMessagesEmptyIconSize = 48;
  static const int myMessagesEmptyTopFlex = 2;
  static const int myMessagesEmptyBottomFlex = 3;

  /// 互动消息条目：发信人头像。
  static const double myMessagesAvatarSize = 36;

  /// 互动消息条目：书籍引用块小封面。
  static const double myMessagesBookRefCoverWidth = 40;
  static const double myMessagesBookRefCoverHeight = 52;

  /// 互动消息条目：引用书评左侧竖条宽度。
  static const double myMessagesQuoteBarWidth = 3;

  /// Tab 悬浮计数角标最小直径（顶部一级 Tab 通用，`AppTopTabBar` 复用）。
  static const double tabBadgeMinSize = 16;

  /// 已读通知整条置灰不透明度。
  static const double myMessagesReadOpacity = 0.45;

  // ── 我的卡包页 ──
  static const double cardPackEmptyIllustrationSize = 160;
  static const int cardPackEmptyTopFlex = 3;
  static const int cardPackEmptyBottomFlex = 4;

  // ── 设置页 ──
  static const double settingsLogoSize = 72;
  static const double appSwitchWidth = 50;
  static const double appSwitchHeight = 30;
  static const double appSwitchThumbSize = 24;
  static const double appSwitchInset = 3;

  // ── 榜单详情页头图（Figma 1297:741 完整榜单）──
  static const double rankingHeroDesignWidth = 375;
  static const double rankingHeroDesignHeight = 160;
  static const double rankingHeroAspectRatio =
      rankingHeroDesignWidth / rankingHeroDesignHeight;

  /// 头图插画蒙版可见高度（Figma 1297:826 mask 130）。
  static const double rankingHeroImageMaskHeight = 130;

  /// 插画相对头图容器的高度比例（Figma 234.38%）。
  static const double rankingHeroImageHeightScale = 2.3438;

  /// 插画相对头图容器的顶部偏移比例（Figma -127.76%）。
  static const double rankingHeroImageTopOffsetRatio = -1.2776;

  /// 标题块尺寸与定位。
  static const double rankingHeroTitleBlockHeight = 61;
  static const double rankingHeroTitleBlockCenterOffset = 47.5;
  static const double rankingHeroTitleMainHeight = 38;
  static const double rankingHeroSubtitleTop = 44;

  /// 分段控件吸附后距离顶部标题栏的视觉间距。
  static const double rankingStickyControlsTopGap = 8;

  /// 标题块相对屏幕顶边位置（Figma 1297:784，含状态栏与顶部导航区域）。
  static const double rankingHeroTitleBlockTop = 97.5;
  static const double rankingHeroTitleBlockBottom =
      rankingHeroTitleBlockTop + rankingHeroTitleBlockHeight;

  /// 频道分段相对屏幕顶边位置（Figma 1297:827）。
  static const double rankingSegmentedFrameTop = 176;

  /// 频道分段控件实际高度（outer padding×2 + item padding×2 + 14px 文本行高）。
  static const double rankingSegmentedHeight =
      rankingSegmentedOuterPadding * 2 +
      rankingSegmentedItemPaddingVertical * 2 +
      14;

  /// 频道分段底部到书单主体顶部的视觉间距。
  static const double rankingSegmentedToBodyGap = 16;

  /// 书单主体相对帧顶 Y，按分段控件实际高度 + 视觉间距推导。
  static const double rankingBodyFrameTop =
      rankingSegmentedFrameTop +
      rankingSegmentedHeight +
      rankingSegmentedToBodyGap;

  /// 频道分段宽度与水平居中偏移（Figma 351px，center +6px）。
  static const double rankingSegmentedDesignWidth = 351;
  static const double rankingSegmentedCenterOffsetX = 6;

  static const double rankingHeroTitleToSubtitleGap = 8;
  static const double rankingHeroDecorationGap = 8;

  static const double rankingTopBarHeight = 44;
  static const double rankingCircleButtonSize = 32;
  static const double rankingBackIconWidth = 14;
  static const double rankingBackIconHeight = 20;
  static const double rankingShareIconSize = 19;
  static const double rankingLaurelWidth = 20;
  static const double rankingLaurelHeight = 32;
  static const double rankingSubtitleLineWidth = 42;
  static const double rankingSubtitleLineHeight = 5;

  /// 头图背景蒙版渐变停靠点（顶部压暗 → 透出插画 → 底部融暗）。
  static const List<double> rankingHeroScrimStops = [0.0, 0.32, 0.72, 1.0];

  /// 头图底部融暗渐变停靠点。
  static const List<double> rankingHeroImageScrimStops = [0.0, 0.72, 0.9, 1.0];

  /// 头图封面人物焦点（归一化 0~1，宽屏裁切时保持面部区域）。
  static const double rankingHeroFocalX = 0.5;
  static const double rankingHeroFocalY = 0.32;

  /// 书籍封面作头图时的 [Alignment] 分量（Figma 1297:826 裁切区域）。
  static const double rankingHeroCoverAlignmentX = 0.5;
  static const double rankingHeroCoverAlignmentY = 0.35;

  /// 宽屏头图至少保留的封面顶部露出比例（含人物面部，约 15%~45% 区域）。
  static const double rankingHeroMinRevealHeightRatio = 0.38;

  static const double rankingSegmentedOuterPadding = 2;
  static const double rankingSegmentedItemPaddingVertical = 10;
  static const double rankingSegmentedBlurSigma = 12;

  static const double rankingDimensionRailWidth = 76;
  static const double rankingDimensionItemPaddingVertical = 16;
  static const double rankingDimensionItemPaddingHorizontal = 12;

  /// 右侧榜单列表顶部内边距；与左侧榜单维度导航顶端对齐。
  static const double rankingBookListTopPadding = 0;

  /// 单项占位高度（padding×2 + 选中态字号行高），供指示条滑动计算。
  static const double rankingDimensionItemSlotHeight = 52;
  static const double rankingDimensionIndicatorWidth = 3;
  static const double rankingDimensionIndicatorHeight = 16;

  // ── 书籍详情页 (Figma 183:1874) ──
  /// 顶部氛围头图设计尺寸 375×219，固定比例自适应屏宽。
  static const double bookDetailHeroDesignWidth = 375;
  static const double bookDetailHeroDesignHeight = 219;
  static const double bookDetailHeroAspectRatio =
      bookDetailHeroDesignWidth / bookDetailHeroDesignHeight;

  /// 头图与下方内容的垂直间距。
  static const double bookDetailContentHeroOverlap = 16;

  static const double bookDetailContentHInset = 12;
  static const double bookDetailSummaryCoverWidth = 96;
  static const double bookDetailSummaryCoverHeight = 128;
  static const double bookDetailSectionGap = 24;
  static const double bookDetailRecommendationActionIconSize = 16;
  static const double bookDetailGlassBlurSigma = 12;

  static const double bookDetailTopBarHeight = 44;
  static const double bookDetailCircleButtonSize = 32;
  static const double bookDetailBackIconWidth = 14;
  static const double bookDetailBackIconHeight = 20;
  static const double bookDetailShareIconSize = 19;

  static const double bookDetailAuthorAvatarSize = 16;

  static const double bookDetailStatsBarHeight = 73;
  static const double bookDetailStatsDividerHeight = 15;

  static const double bookDetailTabOuterPadding = 2;
  static const double bookDetailTabItemPaddingVertical = 10;

  static const double bookDetailCatalogPaddingH = 12.5;
  static const double bookDetailCatalogPaddingV = 16.5;
  static const double bookDetailCatalogArrowSize = 12;
  static const double bookDetailCatalogDrawerWidthRatio = 0.78;
  static const double bookDetailCatalogDrawerCoverWidth = 48;
  static const double bookDetailCatalogDrawerCoverHeight = 64;
  static const double bookDetailCatalogDrawerHeaderPaddingH = 16;
  static const double bookDetailCatalogDrawerHeaderPaddingV = 16;
  static const double bookDetailCatalogChapterPaddingV = 14;
  static const double bookDetailCatalogLockIconSize = 16;

  static const double bookDetailCharCoverWidth = 132;
  static const double bookDetailCharCoverHeight = 179;
  static const double bookDetailCharacterHelpDialogWidthRatio = 0.84;
  static const double bookDetailCharacterHelpDialogMaxHeightRatio = 0.62;
  static const double bookDetailCharacterHelpCloseSize = 32;
  static const double bookDetailSectionHintIconSize = 12;
  static const double bookDetailDiscussionAvatarSize = 28;
  static const double bookDetailDiscussionListAvatarSize = 24;
  static const double bookDetailDiscussionBodyIndent = 40;
  static const double bookDetailDiscussionCardPadding = 12;
  static const double bookDetailDiscussionReplyPadding = 10;
  static const double bookDetailDiscussionLikeIconSize = 18;
  static const double bookDetailDiscussionFilterPaddingH = 16;
  static const double bookDetailDiscussionFilterPaddingV = 6;
  static const double bookDetailDiscussionListGap = 22;
  static const double bookDetailDiscussionShortListBottomReserveFactor = 0.55;
  static const double bookDiscussionDetailReplyAvatarSize = 24;
  static const double bookDiscussionDetailReplyItemGap = 14;
  static const double bookDiscussionDetailInputBarHeight = 52;
  static const double bookDiscussionDetailInputIconSize = 18;
  static const double bookDetailUpdateDateColumnWidth = 92;
  static const double bookDetailUpdateTimelineWidth = 16;
  static const double bookDetailUpdateDotOuterSize = 12;
  static const double bookDetailUpdateDotInnerSize = 4;
  static const double bookDetailUpdateDotBorderWidth = 1.5;
  static const double bookDetailUpdateLineWidth = 1;
  static const double bookDetailUpdateHeaderRowHeight = 24;
  static const double bookDetailUpdateItemGap = 20;
  static const double bookDetailUpdateSectionPadding = 12;

  static const double bookDetailBottomIconSize = 24;
  static const double bookDetailShelfActionIconWidth = 17.3298;
  static const double bookDetailShelfActionIconHeight = 14.7811;
  static const double bookDetailHeartActionIconWidth = 18.5769;
  static const double bookDetailHeartActionIconHeight = 16.3402;
  static const double bookDetailBottomItemHeight = 42;
  static const double bookDetailReadCtaPaddingH = 28;
  static const double bookDetailReadCtaPaddingV = 14;
  static const double bookDetailGiftBadgePaddingH = 2;

  // 悬浮促销条 (Figma 1598:4319)
  static const double bookDetailPromoIconSize = 38;
  static const double bookDetailPromoClaimHeight = 26;
  static const double bookDetailPromoClaimMinWidth = 72;
  static const double bookDetailPromoCloseSize = 12;
  static const double bookDetailPromoRewardTagWidth = 30;
  static const double bookDetailPromoRewardTagHeight = 21;
  static const double bookDetailPromoRewardTagLeft = 30;
  static const double bookDetailPromoRewardTagTopOverhang = 8;
  static const double bookDetailPromoRewardTextTop = 2;

  // ── 搜索页（深色态） ──
  static const double searchAppBarBackIconWidth = 14;
  static const double searchAppBarBackIconHeight = 20;
  static const double searchInputIconSize = 16;

  // ── 大封面横向书卡（分类 / 榜单 / 搜索 / 编辑推荐共用） ──
  static const double bookCardLargeCoverWidth = 96;
  static const double bookCardLargeCoverAspectRatio = 3 / 4;
  static const double bookCardLargeCoverHeight =
      bookCardLargeCoverWidth / bookCardLargeCoverAspectRatio;
  static const double bookCardLargeRowVerticalPadding = 16;
  static const double bookCardLargeCoverToTextGap = 12;
  static const double bookCardLargeTitleToMetaGap = 8;
  static const double bookCardLargeMetaToDescGap = 8;
  static const double bookCardLargeTitleToTrailingGap = 8;
  static const double bookCardLargeTrailingIconSize = 22;

  static const double searchEmptyIllustrationSize = 160;
  static const double searchEmptyIconSize = 56;
  static const int searchEmptyTopFlex = 3;
  static const int searchEmptyBottomFlex = 5;

  /// 富信息书卡：简介 → 作者脚注间距。
  static const double bookCardDescToFooterGap = 8;

  // ── 会员页 (Figma 1086:4182) ──
  static const double membershipHeroHeight = 300;

  /// 分页器及以下内容区整体上移量，与 hero 熊脚轻微重叠。
  static const double membershipLowerContentLift = 20;

  /// 布局占位高度（hero 背景可溢出绘制）。
  static const double membershipHeroLayoutHeight =
      membershipHeroHeight - membershipLowerContentLift;

  /// hero 文案块距屏幕顶（含状态栏 44 + 标题栏 44 + 间距）。
  /// 下移让文案/头图整体避开顶栏「充值记录」按钮。
  static const double membershipHeroTextTop = 124;

  /// hero 右侧主视觉插画槽位（左文右图，右对齐贴边，Figma 1503:355）。
  /// top 略高于文案，与主张视觉居中呼应。
  static const double membershipHeroSlideImageTop = 80;
  static const double membershipHeroSlideImageWidth = 144;
  static const double membershipHeroSlideImageHeight = 200;

  static const double membershipDotsTop = 195;
  static const double membershipUserCardTop = 211;
  static const double membershipUserAvatarSize = 44;

  /// 会员用户卡毛玻璃模糊强度（较通用卡片更强，凸显头图/背景虚化）。
  static const double membershipUserCardBlurSigma = 40;
  static const double membershipPlanSelectedBorderWidth = 2;
  static const double membershipPlanUnselectedBorderWidth = 1;
  static const double membershipPlanSelectorGap = 16;
  static const double membershipBenefitIconCircle = 46;
  static const double membershipBenefitIcon = 30;
  static const double membershipBenefitIconLabelGap = 7;
  static const double membershipBenefitRowGap = 16;
  static const int membershipBenefitColumns = 4;

  /// 会员特权详情页顶部图标横向导航条高度（图标 + 文案）。
  static const double membershipBenefitNavHeight = 78;

  /// 会员特权详情页示例图占位内的图标尺寸。
  static const double membershipBenefitExampleIconSize = 48;

  /// 权益区切换单行布局的最小宽度；达到后 7 项均分容器总宽。
  static const double membershipBenefitGridMaxWidth = 420;
  static const double membershipCtaHeight = 42;
  static const double membershipCtaBreathScaleMin = 1;
  static const double membershipCtaBreathScaleMax = 1.04;

  /// 扫光高亮带宽度占按钮宽度比例。
  static const double membershipCtaSweepBandWidthRatio = 0.42;
  static const double membershipHeroToPlanGap = 15;
  static const double membershipPlanCardWidth = 150;
  static const double membershipPlanCardHeight = 167;
  static const double membershipPlanFooterHeight = 28;
  static const double membershipHeroCarouselTextHeight = 64;

  /// 横向滑动超过该距离才翻页（像素）。
  static const double membershipHeroSwipeDistanceThreshold = 48;

  /// 横向滑动速度超过该值才翻页（逻辑像素/秒）。
  static const double membershipHeroSwipeVelocityThreshold = 260;

  /// 单次拖动最多跟手距离（相对屏宽比例）。
  static const double membershipHeroMaxDragPageRatio = 0.92;

  /// 首尾页越界拖动的橡皮筋阻尼系数（越小越「拉不动」）。
  static const double membershipHeroRubberBandFriction = 0.52;
  static const double membershipBackIconWidth = 14;
  static const double membershipBackIconHeight = 20;

  // ── 伙伴页 / 探索（深色 + 粉紫主题） ──
  static const double partnerHeaderHeight = 44;
  static const double partnerTopAuroraHeight = 180;
  static const double partnerTopAuroraOpacity = 0.26;
  static const double partnerPageTitleFontSize = 22;
  static const double partnerTopTabFontSize = 16;
  static const double partnerSearchIconSize = 20;
  static const double partnerHeaderToCategoryGap = 12;
  static const double partnerCategoryChipHeight = 32;
  static const double partnerCategoryChipPaddingH = 8;
  static const double partnerCategoryChipSpacing = 8;
  static const double partnerCategoryToSortGap = 12;
  static const double partnerSortBarHeight = 36;
  static const double partnerSortIconSize = 14;
  static const double partnerNewBadgeWidth = 28;
  static const double partnerNewBadgeHeight = 14;
  static const double partnerFilterIconSize = 16;
  static const double partnerCharacterCoverAspectRatio = 132 / 179;

  /// Figma 卡片人物特写比例（880 × 1320）。
  static const double partnerCharacterPortraitAspectRatio = 880 / 1320;
  static const String partnerCharacterCoverBackgroundAsset =
      'assets/images/partner/card_cover_bg.png';
  static const double partnerCharacterCardPadding = 12;
  static const double partnerCharacterNameToQuoteGap = 4;
  static const double partnerCharacterQuoteToSubtitleGap = 4;
  static const double partnerCharacterSubtitleToFooterGap = 8;
  static const double partnerCharacterBadgePaddingH = 6;
  static const double partnerCharacterBadgePaddingV = 3;
  static const double partnerCharacterBadgeMinHeight = 16;
  static const double partnerTraitTagHeight = 22;
  static const double partnerTraitTagPaddingH = 6;
  static const double partnerTraitTagPaddingV = 3;
  static const double partnerTraitTagSpacing = 4;

  /// 与 [AppTextStyles.partnerCharacterName] 行高一致（15 × 1.3）。
  static const double partnerCharacterNameLineHeight = 19.5;

  /// 与 [AppTextStyles.partnerCharacterQuote] 行高一致（13 × 1.4）。
  static const double partnerCharacterQuoteLineHeight = 18.2;

  /// 与 [AppTextStyles.partnerCharacterSubtitle] 行高一致（12 × 1.3）。
  static const double partnerCharacterSubtitleLineHeight = 15.6;

  /// 封面以下正文区高度（padding + 三行文案 + 标签行）。
  static const double partnerCharacterBodyHeight =
      partnerCharacterCardPadding * 2 +
      partnerCharacterNameLineHeight +
      partnerCharacterNameToQuoteGap +
      partnerCharacterQuoteLineHeight +
      partnerCharacterQuoteToSubtitleGap +
      partnerCharacterSubtitleLineHeight +
      partnerCharacterSubtitleToFooterGap +
      partnerTraitTagHeight;

  /// 探索页角色卡总高度（封面 + 正文区）。
  static double partnerCharacterCardHeight(double cardWidth) {
    return cardWidth / partnerCharacterCoverAspectRatio +
        partnerCharacterBodyHeight;
  }

  static const double partnerLoadMoreTriggerOffset = 240;
  static const double partnerLoadingIndicatorSize = 20;
  static const double partnerLoadingIndicatorStrokeWidth = 2;
  static const double partnerFilterSheetOptionHeight = 48;

  // 消息 Tab
  static const double partnerMessageAvatarSize = 52;
  static const double partnerMessageRowMinHeight = 72;
  static const double partnerMessageAffectionBadgeHeight = 18;
  static const double partnerMessageAffectionIconSize = 10;
  static const double partnerMessageAffectionBadgePaddingH = 6;
  static const double partnerMessageUnreadBadgeMinSize = 16;
  static const double partnerMessageUnreadBadgePaddingH = 4;
  static const double partnerMessageHeaderGradientHeight = 100;
  static const double partnerHeaderToMessageListGap = 4;
  static const double partnerMessageAvatarToContentGap = 12;
  static const double partnerMessageNameToPreviewGap = 4;
  static const double partnerMessageTimestampMinWidth = 48;

  // 互动 Tab
  static const double partnerInteractionSideActionSize = 44;
  static const double partnerInteractionSideActionIconSize = 22;
  static const double partnerInteractionSideActionSpacing = 14;
  static const double partnerInteractionSideActionLabelGap = 4;
  static const double partnerInteractionConfideActionSize = 56;
  static const double partnerInteractionChatActionSize = 72;
  static const double partnerInteractionBottomActionGap = 8;
  static const double partnerInteractionReviewButtonHeight = 32;
  static const double partnerInteractionReviewButtonPaddingH = 12;
  static const double partnerInteractionCharacterCardPaddingH = 12;
  static const double partnerInteractionCharacterCardPaddingV = 8;
  static const double partnerInteractionCharacterCardRadius = 12;
  static const double partnerInteractionPageIndicatorPaddingH = 10;
  static const double partnerInteractionPageIndicatorPaddingV = 4;
  static const double partnerInteractionSceneBottomFadeHeight = 120;
  static const double partnerInteractionOverlayHorizontalInset = 12;
  static const double partnerInteractionOverlayTopInset = 8;
  static const double partnerInteractionOverlayBelowHeaderGap = 8;
  static const double partnerInteractionOverlayBottomInset = 96;

  /// 顶栏（状态栏 + Tab）高度，用于全屏背景下 overlay 避让。
  static double partnerInteractionHeaderOverlayHeight(double statusBarHeight) {
    return statusBarHeight + partnerHeaderHeight;
  }

  // ── 分类页（深色态） ──
  static const double categoryFilterGroupSpacing = 20;
  static const double categoryFilterDividerTopGap = 14;
  static const double categoryFilterDividerBottomGap = 16;
  static const double categoryFilterChipSpacing = 16;
  static const double categoryFilterChipRunSpacing = 14;
  static const double categoryFilterChipLabelToUnderlineGap = 4;
  static const double categoryFilterUnderlineWidth = 16;
  static const double categoryFilterUnderlineHeight = 3;
  static const double categoryFilterSectionVerticalPadding = 16;
  static const double categoryHeaderToFilterGap = 8;

  // ── 帮助与反馈页 ──
  static const double helpFeedbackTabBarReserveHeight = 40;
  static const double helpFeedbackInputMinHeight = 48;
  static const double helpFeedbackDescriptionMinHeight = 164;
  static const double helpFeedbackUploadRemoveIconSize = 14;
  static const int helpFeedbackDescriptionMaxLines = 6;
  static const int helpFeedbackDescriptionMaxLength = 300;

  // ── 分享底部弹层 ──
  /// 分享渠道圆形图标底直径。
  static const double shareSheetChannelSize = 48;

  /// 分享渠道图标字形尺寸。
  static const double shareSheetChannelIconSize = 24;
}
