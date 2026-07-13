import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 福利页专用色 token。品牌色引用 [AppBrandColors]、中性叠加色引用
/// [AppColors] 中性阶（单一真源）；仅福利页独有色保留字面量。
abstract final class AppWelfareColors {
  static const Color vipBannerGradientStart = AppBrandColors.vipGradientStart;
  static const Color vipBannerGradientEnd = AppBrandColors.vipGradientEnd;
  static const Color vipBannerText = AppBrandColors.vipBannerText;
  static const Color vipCtaGradientStart = AppBrandColors.vipCtaGradientStart;
  static const Color vipCtaGradientEnd = AppBrandColors.vipCtaGradientEnd;
  static const Color vipCtaBorder = AppBrandColors.vipCtaBorder;
  static const Color vipCtaText = AppBrandColors.vipOnGradientText;

  static const Color goldMedium = AppBrandColors.goldMedium;
  static const Color goldDark = AppBrandColors.goldDark;
  static const Color goldText = AppBrandColors.goldText;
  static const Color accentOrange = AppBrandColors.accentOrange;

  /// 签到高亮面（今日卡体 / 里程碑气泡 / 奖励 chip）：主强调 8% 叠深底。
  static const Color checkInHighlightSurface = AppColors.segmentedSelectedFill;
  static const Color checkInHighlightBg = checkInHighlightSurface;
  static const Color checkInHighlightHeader = AppBrandColors.checkInYellow;

  /// 今日卡描边（主强调黄）。
  static const Color checkInHighlightBorder = AppBrandColors.checkInHighlightHeader;
  static const Color checkInTodayHeaderText = AppBrandColors.textOnLightPanel;

  /// 今日可领奖励文字（主黄）。
  static const Color checkInRewardTodayText = AppBrandColors.checkInYellow;
  static const Color checkInDayBg = AppColors.white04;
  static const Color checkInDayHeader = AppColors.white04;
  static const Color checkInDayBorder = AppColors.white04;
  static const Color checkInDayLabelMuted = AppColors.white60;
  static const Color checkInCumulativeBg = checkInHighlightSurface;
  static const Color checkInCumulativeBorder = AppColors.white00;
  static const Color checkInCumulativeLabel = AppBrandColors.goldMedium;
  static const Color checkInCumulativeValue = AppBrandColors.goldDark;
  static const Color checkInProgressTrack = AppColors.white04;
  static const Color checkInProgressFill = Color(0xFFFD7E2F);
  static const Color checkInProgressDotFill = Color(0xFF1B212A);
  static const Color checkInProgressDotStroke = Color(0xFF121721);
  static const Color checkInMilestoneBubbleStart = Color(0xFFFFD443);
  static const Color checkInMilestoneBubbleEnd = AppBrandColors.accent;
  static const Color checkInMilestoneAmount = AppColors.white100;
  static const Color checkInMilestoneLabel = AppColors.white60;
  static const Color checkInCtaSolid = AppBrandColors.checkInYellow;
  static const Color checkInCtaTextDark = AppBrandColors.textOnLightPanel;
  static const Color checkInCtaSweepEdge = AppColors.white00;
  static const Color checkInCtaSweepHighlight = AppColors.white50;

  static const Color subtitleMuted = AppBrandColors.subtitleMuted;
  static const Color hotSaleBadge = AppBrandColors.hotSaleBadge;
  static const Color hotSaleBadgeText = AppBrandColors.hotSaleBadgeText;
  static const Color rechargePriceBg = AppColors.white04;
  static const Color originalPriceMuted = AppBrandColors.originalPriceMuted;
  static const Color moreBenefitsAction = AppBrandColors.accent;

  static const Color taskDivider = AppColors.white04;
  static const Color taskActionBg = AppColors.white08;
  static const Color taskActionHighlightBg = AppBrandColors.checkInYellow;
  static const Color taskActionHighlightText = AppBrandColors.textOnLightPanel;
  static const Color taskRewardChipBg = AppColors.white04;
  static const Color taskRewardChipMutedBg = AppColors.black04;
  static const Color taskRewardChipText = AppColors.white100;
  static const Color taskRewardChipMutedText = AppColors.white60;
  static const Color taskTimelineTrack = AppColors.white08;
  static const Color taskTimelineFill = Color(0xFFFD7E2F);
  static const Color taskTimelineBubbleActive = AppBrandColors.checkInHighlightHeader;
  static const Color taskTimelineBubbleReached = AppColors.white04;
  static const Color taskTimelineDot = Color(0xFF1C2129);
  static const Color taskTimelineDotReached = Color(0xFFFD7E2F);
  static const Color taskTimelineDotBorder = Color(0xFF131720);
  static const Color taskVipBadgeBg = AppColors.segmentedSelectedFill;
  static const Color taskVipBadgeText = AppBrandColors.checkInYellow;
  static const Color taskPopularIconBg = AppBrandColors.accentOrange;
  static const Color taskPopularGradientStart = Color(0xFFFF5065);
  static const Color taskPopularGradientEnd = Color(0xFFFFB06B);
  static const Color taskVipGradientBadgeText = AppBrandColors.vipOnGradientText;
  static const Color taskProgressLabel = AppColors.white60;
  // VIP 每日能量条：左→右由半透明白渐隐为全透明（Figma 559:23239）。
  static const Color vipEntryBadgeGradientStart = Color(0x52FFFFFF);
  static const Color vipEntryBadgeGradientEnd = AppColors.white00;
  static const Color vipEntryBadgeText = AppBrandColors.vipOnGradientText;
}
