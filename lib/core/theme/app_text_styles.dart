import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_membership_colors.dart';
import 'app_partner_colors.dart';
import 'app_sizes.dart';
import 'app_welfare_colors.dart';

/// 全局文字样式 token，禁止在 UI 中写死 fontSize / fontWeight。
abstract final class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// 大按钮主文案字重（AppButton normal、福利签到 CTA、会员开通 CTA 等）。
  static const FontWeight buttonLabelBold = FontWeight.w700;

  /// 大按钮 14px 主文案基准。
  static const TextStyle buttonLabel14 = TextStyle(
    fontSize: 14,
    fontWeight: buttonLabelBold,
    height: 1.0,
  );

  /// 大按钮 16px 主文案基准。
  static TextStyle get buttonLabel16 =>
      buttonLabel14.copyWith(fontSize: bodyLarge.fontSize);

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle bookshelfEmptyMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.bookshelfEmptyText,
    height: 1.0,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle captionMd = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle captionSm = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle captionMicro = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle displaySm = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static TextStyle get sectionTitleDark => titleMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w600,
  );

  /// 深色页面通用标题（18px）。
  static TextStyle get titleMediumDark => titleMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w600,
  );

  /// 深色页面通用正文（14px）。
  static TextStyle get bodyMediumDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
  );

  /// 深色页面通用次级正文（14px）。
  static TextStyle get bodyMediumDarkMuted => bodyMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: FontWeight.w400,
  );

  /// 深色页面通用标签文本（12px）。
  static TextStyle get labelMediumDark => labelMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w500,
  );

  /// 深色页面通用说明文本（11px）。
  static TextStyle get captionMdDarkMuted => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle tabActiveDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle tabInactiveDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static TextStyle get bookTitleDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bookGridTitleDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
    // Grid cards are tighter than list tiles; use denser line-height.
    height: 1.3,
  );

  static TextStyle get bookTagDark => labelMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  /// 「猜你喜欢」卡片摘要文案（12px，2 行展示）。
  static TextStyle get bookGuessLikeSummaryDark => labelMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: FontWeight.w400,
    height: 1.75,
  );

  /// 「猜你喜欢」标签胶囊文案（11px）。
  static TextStyle get bookGuessLikeTagDark => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get linkSmallDark => labelMedium.copyWith(
    color: AppColors.accentYellow,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static TextStyle get searchPlaceholderDark =>
      bodyMedium.copyWith(color: AppColors.textOnDarkPlaceholder, height: 1.0);

  static TextStyle get navLabelActiveDark => captionSm.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
  );

  static TextStyle get navLabelInactiveDark => captionSm.copyWith(
    fontWeight: FontWeight.w400,
    color: AppColors.iconMutedSecondary,
  );

  static TextStyle get welfareSectionTitle => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static TextStyle get welfareCurrencyAmount => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static TextStyle get welfareSubtitle => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.5,
  );

  static TextStyle get welfareCtaText => buttonLabel14;

  static TextStyle get welfareTaskProgressLabel =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.0);

  static TextStyle get welfareTaskRewardChipLabel =>
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.0);

  static TextStyle get welfareCheckInDayLabel =>
      captionMd.copyWith(color: AppColors.textOnDark);

  static TextStyle get welfareCheckInDayLabelMuted =>
      captionMd.copyWith(color: AppWelfareColors.checkInDayLabelMuted);

  static TextStyle get welfareCheckInDayLabelToday => captionMd.copyWith(
    color: AppWelfareColors.checkInTodayHeaderText,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get welfareCheckInReward => captionMd.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get welfareCheckInRewardToday => captionMd.copyWith(
    color: AppWelfareColors.goldText,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get welfareHotSaleBadge => captionMicro.copyWith(
    color: AppWelfareColors.hotSaleBadgeText,
    fontWeight: FontWeight.w600,
  );

  /// 能量充值卡片主数量（Figma 697:12514 · 13px Regular）。
  static TextStyle get welfareRechargeEnergyAmount => labelSm.copyWith(
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  /// 能量充值卡片划线原价（Figma · 10px #9B9B9B）。
  static TextStyle get welfareRechargeOriginalAmount => captionSm.copyWith(
    fontWeight: FontWeight.w400,
    color: AppWelfareColors.originalPriceMuted,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppWelfareColors.originalPriceMuted,
    height: 1.0,
  );

  /// 能量充值价格按钮 ¥ 符号（Figma · 10px Medium）。
  static TextStyle get welfareRechargePriceSymbol => captionSm.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  /// 能量充值价格按钮数字（Figma · 16px Medium）。
  static TextStyle get welfareRechargePriceAmount => buttonLabel16.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  /// 能量充值「更多福利」入口（Figma · 12px #FFE847）。
  static TextStyle get welfareRechargeMoreAction => captionMd.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppWelfareColors.moreBenefitsAction,
    height: 1.0,
  );

  /// 能量充值支付弹窗标题（购买 + 赠送）。
  static TextStyle get rechargePurchaseDialogTitle => bodyMedium.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.4,
  );

  /// 能量充值支付弹窗大号价格。
  static TextStyle get rechargePurchaseDialogPrice => headlineMedium.copyWith(
    fontSize: AppSizes.rechargePurchaseDialogPriceFontSize,
    fontWeight: FontWeight.w600,
    color: AppWelfareColors.accentOrange,
    height: 1.2,
  );

  /// 能量充值支付弹窗协议区文案。
  static TextStyle get rechargePurchaseDialogAgreement =>
      captionMd.copyWith(color: AppColors.textOnDarkMuted, height: 1.4);

  /// 能量充值支付弹窗协议链接。
  static TextStyle get rechargePurchaseDialogAgreementLink =>
      rechargePurchaseDialogAgreement.copyWith(color: AppColors.textOnDark);

  static TextStyle get welfareCheckInCumulativeLabel => labelMedium.copyWith(
    color: AppWelfareColors.checkInCumulativeLabel,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static TextStyle get welfareCheckInCumulativeValue =>
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, height: 1.0);

  static TextStyle get welfareCheckInMilestoneLabel => captionMd.copyWith(
    color: AppWelfareColors.checkInMilestoneLabel,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get welfareCheckInMilestoneAmount => labelMedium.copyWith(
    color: AppWelfareColors.checkInMilestoneAmount,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  static TextStyle get bookshelfReadingMinutes =>
      displaySm.copyWith(color: AppColors.textOnDark);

  static TextStyle get bookshelfReadingLabel => bodyMedium.copyWith(
    color: AppColors.textOnDarkPlaceholder,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static TextStyle get bookshelfManageAction => bodyMedium.copyWith(
    color: AppColors.textOnDarkPlaceholder,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  static TextStyle get bookshelfClaimWelfareCta => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.navActiveText,
    height: 1.15,
  );

  static TextStyle get profileNickname => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
    shadows: [
      Shadow(color: Color(0x59000000), offset: Offset(0, 1), blurRadius: 1.5),
    ],
  );

  static TextStyle get profileUserId => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
    height: 1.0,
    shadows: const [
      Shadow(color: Color(0x59000000), offset: Offset(0, 1), blurRadius: 1.5),
    ],
  );

  static TextStyle get welfareVipBannerLabel => bodyMedium.copyWith(
    color: AppWelfareColors.vipBannerText,
    fontWeight: FontWeight.w500,
    height: 1.0,
  );

  static TextStyle get welfareVipCtaLabel =>
      labelSm.copyWith(color: AppWelfareColors.vipCtaText);

  static TextStyle get profileShortcutLabel => labelMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
    height: 1.0,
  );

  // 榜单详情页 (Figma 220:8376)
  static const TextStyle rankingHeroTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.rankingHeroTitle,
    height: 1.0,
    letterSpacing: 1.56,
  );

  static const TextStyle rankingHeroSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.rankingHeroSubtitle,
    height: 1.0,
    letterSpacing: 1.2,
  );

  static const TextStyle rankingDimensionActive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle rankingDimensionInactive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle rankingChannelActive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.segmentedSelectedText,
    height: 1.0,
  );

  static const TextStyle rankingChannelInactive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.segmentedUnselectedText,
    height: 1.0,
  );

  // 书籍详情页 (Figma 183:1874) — 颜色复用现有 token。
  static const TextStyle bookDetailTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.45,
  );

  static const TextStyle bookDetailTag = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle bookDetailAuthor = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  /// 书籍详情摘要卡：标签行 / 连载数据行。
  static const TextStyle bookDetailSummaryMeta = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.35,
  );

  /// 书籍详情摘要卡标题（左图右文，较顶栏叠字略小）。
  static const TextStyle bookDetailSummaryTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.4,
  );

  static const TextStyle bookDetailStatValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailStatLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle bookDetailTabSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.segmentedSelectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailTabUnselected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.segmentedUnselectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailTabCount = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.segmentedUnselectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailTabCountSelected = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.segmentedSelectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailBlockTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailSectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailIntroBody = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.9,
  );

  static const TextStyle bookDetailCatalogMeta = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle bookDetailCatalogDrawerTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.35,
  );

  static const TextStyle bookDetailCatalogChapterTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.4,
  );

  static const TextStyle bookDetailSectionHint = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static const TextStyle bookDetailCharName = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.5,
  );

  static const TextStyle bookDetailCharFav = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accentYellow,
    height: 1.0,
  );

  static const TextStyle bookDetailReadCta = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.rankingSegmentedSelectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailBottomLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.iconMutedSecondary,
    height: 1.0,
  );

  static const TextStyle bookDetailGiftBadge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailPlaceholder = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.5,
  );

  static const TextStyle bookDetailDiscussionFilterSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.navActiveText,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionFilterUnselected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.discussionFilterUnselectedText,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionAuthor = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionMeta = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionLike = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionTag = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle bookDetailDiscussionBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.7,
  );

  static const TextStyle bookDetailDiscussionReplyPreview = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.5,
  );

  static const TextStyle bookDetailDiscussionReplyAction = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static const TextStyle bookDetailUpdateDate = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.bookDetailUpdateDate,
    height: 1.0,
  );

  static const TextStyle bookDetailUpdateDateHighlighted = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.bookDetailUpdateDateHighlighted,
    height: 1.0,
  );

  static const TextStyle bookDetailUpdateTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.bookDetailUpdateText,
    height: 1.45,
  );

  static const TextStyle bookDetailUpdateTitleHighlighted = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.bookDetailUpdateTextHighlighted,
    height: 1.45,
  );

  static const TextStyle bookDetailUpdateDetail = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.bookDetailUpdateText,
    height: 1.45,
  );

  static const TextStyle bookDetailUpdateDetailHighlighted = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.bookDetailUpdateTextHighlighted,
    height: 1.45,
  );

  // 搜索页（深色态）
  static const TextStyle searchInputText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle searchActionLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.searchActionText,
    height: 1.0,
  );

  /// 大封面横向书卡标题（分类 / 榜单 / 搜索 / 编辑推荐共用）。
  static const TextStyle bookCardLargeTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.4,
  );

  /// 大封面横向书卡简介。
  static const TextStyle bookCardLargeDescription = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.6,
  );

  /// 封面右上角状态角标文字（Figma 1335:12223）；颜色随变体覆盖。
  static const TextStyle bookCoverTagLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  /// 轻提示 Toast 文案（主黄底 + 深色字，加粗，无下划线）。
  static const TextStyle toastMessage = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.navActiveText,
    height: 1.4,
    decoration: TextDecoration.none,
  );

  static const TextStyle searchEmptyCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle searchStatusBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.searchStatusBadgeText,
    height: 1.0,
  );

  /// 书卡底部作者/脚注小字（共享富信息书卡）。
  static const TextStyle bookCardFooter = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  // ── 会员页 (Figma 927:725) ──
  // 设计字体 YouSheBiaoTiHei 工程未内置，降级为系统粗体显示字重。
  static const TextStyle membershipHeroEnergyLabel = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipHeroEnergyAmount = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipHeroSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipUserName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipUserSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  static const TextStyle membershipPlanTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipPlanCurrencySymbol = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipPlanPrice = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipPlanOriginalPrice = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppMembershipColors.planOriginalPrice,
    height: 1.0,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppMembershipColors.planOriginalPrice,
  );

  static const TextStyle membershipPlanFooter = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipRenewHint = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipCtaLabel = TextStyle(
    fontSize: 14,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: 1.0,
  );

  /// CTA 内价格的 ¥ 符号（10px Bold，较价格数字更小，底对齐）。
  static const TextStyle membershipCtaPriceSymbol = TextStyle(
    fontSize: 10,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: 1.0,
  );

  /// CTA 内价格数字（14px Bold）。
  static const TextStyle membershipCtaPriceValue = TextStyle(
    fontSize: 14,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: 1.0,
  );

  static const TextStyle membershipAgreement = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  static const TextStyle membershipSectionTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle membershipBenefitLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  static const TextStyle membershipStatementBody = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.75,
  );

  static const TextStyle membershipAppBarAction = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkMuted,
    height: 1.0,
  );

  // 分类页（深色态）
  static const TextStyle categoryFilterSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.0,
  );

  static const TextStyle categoryFilterSecondarySelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.categoryFilterSecondarySelectedText,
    height: 1.0,
  );

  static const TextStyle categoryFilterUnselected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 1.0,
  );

  // 伙伴页 / 探索（深色 + 粉紫主题）
  static const TextStyle partnerPageTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerTopTabActive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerTopTabInactive = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle partnerCategoryChipSelected = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.primary,
    height: 18 / 13,
  );

  static const TextStyle partnerCategoryChipUnselected = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnDarkPlaceholder,
    height: 18 / 13,
  );

  static const TextStyle partnerSortActive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.primary,
    height: 1.0,
  );

  static const TextStyle partnerSortInactive = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle partnerFilterLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle partnerCoverTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle partnerCharacterName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle partnerCharacterQuote = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle partnerCharacterSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textTertiary,
    height: 1.3,
  );

  static const TextStyle partnerTraitTag = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.tagPurple,
    height: 1.0,
  );

  static const TextStyle partnerFollowerCount = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textTertiary,
    height: 1.0,
  );

  static const TextStyle partnerCollectionBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerCollectionBadgeMuted = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.textSecondary,
    height: 1.0,
  );

  static const TextStyle partnerNotificationBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerNewBadge = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerFilterSheetTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerFilterSheetOption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerFilterSheetOptionSelected = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.primary,
    height: 1.0,
  );

  static const TextStyle partnerMessageCharacterName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle partnerMessagePreview = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textSecondary,
    height: 1.3,
  );

  static const TextStyle partnerMessageTimestamp = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textTertiary,
    height: 1.0,
  );

  static const TextStyle partnerAffectionBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionCharacterName = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle partnerInteractionUpgradeHint = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textSecondary,
    height: 1.2,
  );

  static const TextStyle partnerInteractionSideActionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionBottomActionLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionChatActionLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionAiPlotBadge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppPartnerColors.textOnPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionPageIndicator = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );

  static const TextStyle partnerInteractionReviewLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppPartnerColors.textPrimary,
    height: 1.0,
  );
}
