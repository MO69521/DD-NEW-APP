import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_membership_colors.dart';
import 'app_partner_colors.dart';
import 'app_sizes.dart';
import 'app_welfare_colors.dart';

/// 全局字体族 token。禁止在 UI 中写死 fontFamily 字符串。
abstract final class AppFontFamilies {
  /// 定制数字字体（TCloudNumber）。仅数字 / 标点 / 符号有字形，
  /// 其余字符（中文 / 字母）自动回退系统字体。
  ///
  /// 规则：**仅 ≥18px（`AppFontSizes.xl` 及以上）字号引用**，
  /// <18px 字号（含 16px `lg`）不引用，保持系统字体。
  ///
  /// 字重：字体注册桶整体上移一档（见 `pubspec.yaml`），数字字形比文本标称
  /// 字重轻一档；中文 / 字母回退按标称字重渲染，不受影响。
  static const String number = 'TCloudNumber';
}

/// 全局字号阶梯（type scale）。禁止再写死 fontSize 数值。
abstract final class AppFontSizes {
  static const double xxs = 9;
  static const double xs = 10;
  static const double md = 12;
  static const double base = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 24;
  static const double display = 32;
}

/// 全局行高阶梯（line-height）。收敛杂散取值到有限档位。
abstract final class AppLineHeights {
  static const double none = 1.0;
  static const double tight = 1.2;
  static const double normal = 1.4;
  static const double loose = 1.75;
}

/// 全局字重阶梯（font-weight）。禁止再写死 FontWeight.wXXX。
abstract final class AppFontWeights {
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight heavy = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}

/// 全局文字样式 token，禁止在 UI 中写死 fontSize / fontWeight。
abstract final class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: AppFontSizes.display,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.semibold,
    color: AppColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.semibold,
    color: AppColors.textPrimary,
    height: AppLineHeights.normal,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textPrimary,
    height: AppLineHeights.normal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textSecondary,
    height: AppLineHeights.normal,
  );

  /// 大按钮主文案字重（AppButton normal、福利签到 CTA、会员开通 CTA 等）。
  static const FontWeight buttonLabelBold = AppFontWeights.bold;

  /// 大按钮 14px 主文案基准。
  static const TextStyle buttonLabel14 = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: buttonLabelBold,
    height: AppLineHeights.none,
  );

  /// 大按钮 16px 主文案基准。
  static TextStyle get buttonLabel16 =>
      buttonLabel14.copyWith(fontSize: bodyLarge.fontSize);

  static const TextStyle labelMedium = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textSecondary,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookshelfEmptyMessage = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookshelfEmptyText,
    height: AppLineHeights.none,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle captionMd = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle captionSm = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle captionMicro = TextStyle(
    fontSize: AppFontSizes.xxs,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle displaySm = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textPrimary,
    height: AppLineHeights.none,
  );

  static TextStyle get sectionTitleDark => titleMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.semibold,
  );

  /// 深色页面通用标题（18px）。
  static TextStyle get titleMediumDark => titleMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.semibold,
  );

  /// 深色页面通用正文（14px）。
  static TextStyle get bodyMediumDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.regular,
  );

  /// 深色页面通用次级正文（14px）。
  static TextStyle get bodyMediumDarkMuted => bodyMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.regular,
  );

  /// 深色页面通用标签文本（12px）。
  static TextStyle get labelMediumDark => labelMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.medium,
  );

  /// 深色页面通用说明文本（11px）。
  static TextStyle get captionMdDarkMuted => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.medium,
  );

  /// 登录协议说明文本：11px 字号 + 8px 行间距。
  static TextStyle get authAgreementDarkMuted => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.medium,
    height: AppLineHeights.loose,
  );

  static const TextStyle tabActiveDark = TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle tabInactiveDark = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static TextStyle get bookTitleDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.normal,
  );

  static TextStyle get bookGridTitleDark => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.regular,
    // Grid cards are tighter than list tiles; use denser line-height.
    height: AppLineHeights.tight,
  );

  static TextStyle get bookTagDark => labelMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  /// 「猜你喜欢」卡片摘要文案（12px，2 行展示）。
  static TextStyle get bookGuessLikeSummaryDark => labelMedium.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.loose,
  );

  /// 「猜你喜欢」标签胶囊文案（11px）。
  static TextStyle get bookGuessLikeTagDark => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    fontWeight: AppFontWeights.regular,
  );

  static TextStyle get linkSmallDark => labelMedium.copyWith(
    color: AppColors.accentYellow,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get authAgreementLinkDark => authAgreementDarkMuted.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.medium,
  );

  static TextStyle get searchPlaceholderDark => bodyMedium.copyWith(
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static TextStyle get navLabelActiveDark => captionSm.copyWith(
    fontWeight: AppFontWeights.medium,
    // 选中态标签用主文字色（浅色主题深墨、深色主题纯白），三主题经 textPrimary 分支解析。
    color: AppColors.textPrimary,
  );

  static TextStyle get navLabelInactiveDark => captionSm.copyWith(
    fontWeight: AppFontWeights.regular,
    color: AppColors.iconMutedSecondary,
  );

  static TextStyle get welfareSectionTitle => const TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareCurrencyAmount => const TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareSubtitle => const TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.normal,
  );

  static TextStyle get welfareCtaText => buttonLabel14;

  static TextStyle get welfareTaskProgressLabel => const TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareTaskRewardChipLabel => const TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareCheckInDayLabel =>
      captionMd.copyWith(color: AppColors.textOnDark);

  static TextStyle get welfareCheckInDayLabelMuted =>
      captionMd.copyWith(color: AppWelfareColors.checkInDayLabelMuted);

  static TextStyle get welfareCheckInDayLabelToday => captionMd.copyWith(
    color: AppWelfareColors.checkInTodayHeaderText,
    fontWeight: AppFontWeights.medium,
  );

  static TextStyle get welfareCheckInReward => captionMd.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.medium,
  );

  static TextStyle get welfareCheckInRewardToday => captionMd.copyWith(
    color: AppWelfareColors.checkInRewardTodayText,
    fontWeight: AppFontWeights.medium,
  );

  static TextStyle get welfareHotSaleBadge => captionMicro.copyWith(
    color: AppWelfareColors.hotSaleBadgeText,
    fontWeight: AppFontWeights.semibold,
  );

  /// 能量充值卡片主数量（Figma 697:12514 · 13px Regular）。
  static TextStyle get welfareRechargeEnergyAmount => labelSm.copyWith(
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  /// 能量充值卡片划线原价（Figma · 10px #9B9B9B）。
  static TextStyle get welfareRechargeOriginalAmount => captionSm.copyWith(
    fontWeight: AppFontWeights.regular,
    color: AppWelfareColors.originalPriceMuted,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppWelfareColors.originalPriceMuted,
    height: AppLineHeights.none,
  );

  /// 能量充值价格按钮 ¥ 符号（Figma · 10px Medium）。
  static TextStyle get welfareRechargePriceSymbol => captionSm.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.medium,
    height: AppLineHeights.none,
  );

  /// 能量充值价格按钮数字（Figma · 16px Medium）。
  static TextStyle get welfareRechargePriceAmount => buttonLabel16.copyWith(
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  /// 免费领取卡片 CTA 文案（「VIP领取」/「免费领」）：较价格数字小一档（14px），
  /// 中文文案在窄卡内视觉不至于过大。
  static TextStyle get welfareRechargeClaimCta =>
      welfareRechargePriceAmount.copyWith(fontSize: AppFontSizes.base);

  /// 能量充值「更多福利」入口（Figma · 12px #FFE847）。
  static TextStyle get welfareRechargeMoreAction => captionMd.copyWith(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppWelfareColors.moreBenefitsAction,
    height: AppLineHeights.none,
  );

  /// 能量充值支付弹窗标题（购买 + 赠送）。
  static TextStyle get rechargePurchaseDialogTitle => bodyMedium.copyWith(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  /// 能量充值支付弹窗大号价格。
  static TextStyle get rechargePurchaseDialogPrice => headlineMedium.copyWith(
    fontSize: AppSizes.rechargePurchaseDialogPriceFontSize,
    fontWeight: AppFontWeights.semibold,
    color: AppWelfareColors.accentOrange,
    height: AppLineHeights.tight,
  );

  /// 能量充值支付弹窗协议区文案。
  static TextStyle get rechargePurchaseDialogAgreement => captionMd.copyWith(
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.normal,
  );

  /// 能量充值支付弹窗协议链接。
  static TextStyle get rechargePurchaseDialogAgreementLink =>
      rechargePurchaseDialogAgreement.copyWith(color: AppColors.textOnDark);

  static TextStyle get welfareCheckInCumulativeLabel => labelMedium.copyWith(
    color: AppWelfareColors.checkInCumulativeLabel,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareCheckInCumulativeValue => const TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.bold,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareCheckInMilestoneLabel => captionMd.copyWith(
    color: AppWelfareColors.checkInMilestoneLabel,
    fontWeight: AppFontWeights.regular,
  );

  static TextStyle get welfareCheckInMilestoneAmount => labelMedium.copyWith(
    color: AppWelfareColors.checkInMilestoneAmount,
    fontWeight: AppFontWeights.medium,
    height: AppLineHeights.none,
  );

  static TextStyle get bookshelfReadingMinutes =>
      displaySm.copyWith(color: AppColors.textOnDark);

  static TextStyle get bookshelfReadingLabel => bodyMedium.copyWith(
    color: AppColors.textOnDarkPlaceholder,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get bookshelfManageAction => bodyMedium.copyWith(
    color: AppColors.textOnDarkPlaceholder,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get bookshelfClaimWelfareCta => const TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.onAccent,
    height: AppLineHeights.tight,
  );

  static TextStyle get profileNickname => const TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static TextStyle get profileUserId => bodyMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareVipBannerLabel => bodyMedium.copyWith(
    color: AppWelfareColors.vipBannerText,
    fontWeight: AppFontWeights.medium,
    height: AppLineHeights.none,
  );

  static TextStyle get welfareVipCtaLabel =>
      labelSm.copyWith(color: AppWelfareColors.vipCtaText);

  static TextStyle get profileShortcutLabel => labelMedium.copyWith(
    color: AppColors.textOnDark,
    fontWeight: AppFontWeights.regular,
    height: AppLineHeights.none,
  );

  // 榜单详情页 (Figma 220:8376)
  static const TextStyle rankingHeroTitle = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.heavy,
    color: AppColors.rankingHeroTitle,
    height: AppLineHeights.none,
    letterSpacing: 1.56,
  );

  static const TextStyle rankingHeroSubtitle = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.semibold,
    color: AppColors.rankingHeroSubtitle,
    height: AppLineHeights.none,
    letterSpacing: 1.2,
  );

  static const TextStyle rankingDimensionActive = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle rankingDimensionInactive = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle rankingChannelActive = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.segmentedSelectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle rankingChannelInactive = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.segmentedUnselectedText,
    height: AppLineHeights.none,
  );

  // 书籍详情页 (Figma 183:1874) — 颜色复用现有 token。
  static const TextStyle bookDetailTitle = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailTag = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailAuthor = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  /// 书籍详情摘要卡：标签行 / 连载数据行。
  static const TextStyle bookDetailSummaryMeta = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.tight,
  );

  /// 书籍详情摘要卡标题（左图右文，较顶栏叠字略小）。
  static const TextStyle bookDetailSummaryTitle = TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.semibold,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailStatValue = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailStatLabel = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailTabSelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.segmentedSelectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailTabUnselected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.segmentedUnselectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailTabCount = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.segmentedUnselectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailTabCountSelected = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.segmentedSelectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailBlockTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailSectionTitle = TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailIntroBody = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textPrimary,
    height: AppLineHeights.loose,
  );

  static const TextStyle bookDetailCatalogMeta = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailCatalogDrawerTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.tight,
  );

  static const TextStyle bookDetailCatalogChapterTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailSectionHint = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailCharName = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailReadCta = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.rankingSegmentedSelectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailBottomLabel = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.regular,
    color: AppColors.iconMutedSecondary,
    height: AppLineHeights.none,
  );

  // 悬浮促销条 (Figma 1598:4319)。设计标题 13，复用 base(14) 档位。
  static const TextStyle bookDetailPromoTitle = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.bold,
    color: AppColors.bookDetailPromoTitle,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailPromoSubtitle = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookDetailPromoSubtitle,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailPromoReward = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.bold,
    color: AppColors.bookDetailPromoRewardText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailGiftBadge = TextStyle(
    fontSize: AppFontSizes.xxs,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailPlaceholder = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailDiscussionFilterSelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.onAccent,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionFilterUnselected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.discussionFilterUnselectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionAuthor = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionMeta = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionLike = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionTag = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailDiscussionBody = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.loose,
  );

  static const TextStyle bookDetailDiscussionReplyPreview = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailDiscussionReplyAction = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailUpdateDate = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookDetailUpdateDate,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailUpdateDateHighlighted = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.bookDetailUpdateDateHighlighted,
    height: AppLineHeights.none,
  );

  static const TextStyle bookDetailUpdateTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookDetailUpdateText,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailUpdateTitleHighlighted = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.bookDetailUpdateTextHighlighted,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailUpdateDetail = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookDetailUpdateText,
    height: AppLineHeights.normal,
  );

  static const TextStyle bookDetailUpdateDetailHighlighted = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.bookDetailUpdateTextHighlighted,
    height: AppLineHeights.normal,
  );

  // 搜索页（深色态）
  static const TextStyle searchInputText = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle searchActionLabel = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.searchActionText,
    height: AppLineHeights.none,
  );

  /// 大封面横向书卡标题（分类 / 榜单 / 搜索 / 编辑推荐共用）。
  static const TextStyle bookCardLargeTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.normal,
  );

  /// 大封面横向书卡简介。
  static const TextStyle bookCardLargeDescription = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.normal,
  );

  /// 封面右上角状态角标文字（Figma 1335:12223）；颜色随变体覆盖。
  static const TextStyle bookCoverTagLabel = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  /// 轻提示 Toast 文案（主黄底 + 深色字，加粗，无下划线）。
  static const TextStyle toastMessage = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.bold,
    color: AppColors.onAccent,
    height: AppLineHeights.normal,
    decoration: TextDecoration.none,
  );

  static const TextStyle searchEmptyCaption = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static const TextStyle searchStatusBadge = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.regular,
    color: AppColors.searchStatusBadgeText,
    height: AppLineHeights.none,
  );

  /// 书卡底部作者/脚注小字（共享富信息书卡）。
  static const TextStyle bookCardFooter = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  // ── 会员页 (Figma 927:725) ──
  // 设计字体 YouSheBiaoTiHei 工程未内置，降级为系统粗体显示字重。
  static const TextStyle membershipHeroEnergyLabel = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipHeroEnergyAmount = TextStyle(
    fontSize: AppFontSizes.display,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipHeroSubtitle = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipUserName = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipUserSubtitle = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipPlanTitle = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipPlanCurrencySymbol = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipPlanPrice = TextStyle(
    fontSize: AppFontSizes.display,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.heavy,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipPlanOriginalPrice = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppMembershipColors.planOriginalPrice,
    height: AppLineHeights.none,
    decoration: TextDecoration.lineThrough,
    decorationColor: AppMembershipColors.planOriginalPrice,
  );

  static const TextStyle membershipPlanFooter = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipRenewHint = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipCtaLabel = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: AppLineHeights.none,
  );

  /// CTA 内价格的 ¥ 符号（10px Bold，较价格数字更小，底对齐）。
  static const TextStyle membershipCtaPriceSymbol = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: AppLineHeights.none,
  );

  /// CTA 内价格数字（14px Bold）。
  static const TextStyle membershipCtaPriceValue = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: buttonLabelBold,
    color: AppMembershipColors.ctaText,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipAgreement = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDark,
    height: AppLineHeights.tight,
  );

  static const TextStyle membershipSectionTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.medium,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipBenefitLabel = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  static const TextStyle membershipStatementBody = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.loose,
  );

  static const TextStyle membershipAppBarAction = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkMuted,
    height: AppLineHeights.none,
  );

  // 分类页（深色态）
  static const TextStyle categoryFilterSelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.semibold,
    color: AppColors.textOnDark,
    height: AppLineHeights.none,
  );

  static const TextStyle categoryFilterSecondarySelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppColors.categoryFilterSecondarySelectedText,
    height: AppLineHeights.none,
  );

  static const TextStyle categoryFilterUnselected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.none,
  );

  // 伙伴页 / 探索（深色 + 粉紫主题）
  static const TextStyle partnerPageTitle = TextStyle(
    fontSize: AppFontSizes.xxl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerTopTabActive = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerTopTabInactive = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerCategoryChipSelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.primary,
    height: AppLineHeights.normal,
  );

  static const TextStyle partnerCategoryChipUnselected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppColors.textOnDarkPlaceholder,
    height: AppLineHeights.normal,
  );

  static const TextStyle partnerSortActive = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.primary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerSortInactive = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerFilterLabel = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerCoverTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerCharacterName = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerCharacterQuote = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.normal,
  );

  static const TextStyle partnerCharacterSubtitle = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textTertiary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerTraitTag = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.tagPurple,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerFollowerCount = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textTertiary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerCollectionBadge = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerCollectionBadgeMuted = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerNotificationBadge = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerNewBadge = TextStyle(
    fontSize: AppFontSizes.xxs,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerFilterSheetTitle = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerFilterSheetOption = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerFilterSheetOptionSelected = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.primary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerMessageCharacterName = TextStyle(
    fontSize: AppFontSizes.lg,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerMessagePreview = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerMessageTimestamp = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textTertiary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerAffectionBadge = TextStyle(
    fontSize: AppFontSizes.xs,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionCharacterName = TextStyle(
    fontSize: AppFontSizes.xl,
    fontFamily: AppFontFamilies.number,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerInteractionUpgradeHint = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textSecondary,
    height: AppLineHeights.tight,
  );

  static const TextStyle partnerInteractionSideActionLabel = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.regular,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionBottomActionLabel = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionChatActionLabel = TextStyle(
    fontSize: AppFontSizes.base,
    fontWeight: AppFontWeights.bold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionAiPlotBadge = TextStyle(
    fontSize: AppFontSizes.xxs,
    fontWeight: AppFontWeights.semibold,
    color: AppPartnerColors.textOnPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionPageIndicator = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );

  static const TextStyle partnerInteractionReviewLabel = TextStyle(
    fontSize: AppFontSizes.md,
    fontWeight: AppFontWeights.medium,
    color: AppPartnerColors.textPrimary,
    height: AppLineHeights.none,
  );
}
