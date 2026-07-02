import 'package:flutter/material.dart';

/// 福利页专用色 token，避免污染 [AppColors]。
abstract final class AppWelfareColors {
  static const Color vipBannerGradientStart = Color(0xFFFFDDC1);
  static const Color vipBannerGradientEnd = Color(0xFFF393DC);
  static const Color vipBannerText = Color(0xFF310F29);
  static const Color vipCtaGradientStart = Color(0xFFFFEBD4);
  static const Color vipCtaGradientEnd = Color(0xFFFFD5DB);
  static const Color vipCtaBorder = Color(0xFFFF9CC7);
  static const Color vipCtaText = Color(0xFF740551);

  static const Color goldMedium = Color(0xFF935C1A);
  static const Color goldDark = Color(0xFFAA722E);
  static const Color goldText = Color(0xFF5D3A12);
  static const Color accentOrange = Color(0xFFFF7E32);

  static const Color checkInHighlightBg = Color(0xFFFFF7BF);
  static const Color checkInHighlightHeader = Color(0xFFFFDD47);
  static const Color checkInTodayHeaderText = Color(0xFF202020);
  static const Color checkInDayBg = Color(0x0A000000);
  static const Color checkInDayHeader = Color(0x0AFFFFFF);
  static const Color checkInDayBorder = Color(0x0AFFFFFF);
  static const Color checkInDayLabelMuted = Color(0x99FFFFFF);
  static const Color checkInCumulativeBg = Color(0xFFFFF9C6);
  static const Color checkInCumulativeBorder = Color(0xFFFFE8A2);
  static const Color checkInCumulativeLabel = Color(0xFF935C1A);
  static const Color checkInCumulativeValue = Color(0xFFAA722E);
  static const Color checkInProgressTrack = Color(0x0AFFFFFF);
  static const Color checkInProgressFill = Color(0xFFFD7E2F);
  static const Color checkInProgressDotFill = Color(0xFF1B212A);
  static const Color checkInProgressDotStroke = Color(0xFF121721);
  static const Color checkInMilestoneBubbleStart = Color(0xFFFFD443);
  static const Color checkInMilestoneBubbleEnd = Color(0xFFFFE847);
  static const Color checkInMilestoneAmount = Color(0xFF935C1A);
  static const Color checkInMilestoneLabel = Color(0x99FFFFFF);
  static const Color checkInCtaSolid = Color(0xFFFCE64D);
  static const Color checkInCtaTextDark = Color(0xFF202020);
  static const Color checkInCtaSweepEdge = Color(0x00FFFFFF);
  static const Color checkInCtaSweepHighlight = Color(0x80FFFFFF);

  static const Color subtitleMuted = Color(0xFF8C8C8C);
  static const Color hotSaleBadge = Color(0xFFFF6B6B);
  static const Color hotSaleBadgeText = Color(0xFFFFFEF4);
  static const Color rechargePriceBg = Color(0x0AFFFFFF);
  static const Color originalPriceMuted = Color(0xFF9B9B9B);
  static const Color moreBenefitsAction = Color(0xFFFFE847);

  static const Color taskDivider = Color(0x0AFFFFFF);
  static const Color taskActionBg = Color(0x14FFFFFF);
  static const Color taskActionHighlightBg = Color(0xFFFCE64D);
  static const Color taskActionHighlightText = Color(0xFF202020);
  static const Color taskRewardChipBg = Color(0x0AFFFFFF);
  static const Color taskRewardChipMutedBg = Color(0x0A000000);
  static const Color taskRewardChipText = Color(0xFFFFFFFF);
  static const Color taskRewardChipMutedText = Color(0x99FFFFFF);
  static const Color taskTimelineTrack = Color(0x14FFFFFF);
  static const Color taskTimelineFill = Color(0xFFFD7E2F);
  static const Color taskTimelineBubbleActive = Color(0xFFFFDD47);
  static const Color taskTimelineBubbleReached = Color(0x0AFFFFFF);
  static const Color taskTimelineDot = Color(0xFF1C2129);
  static const Color taskTimelineDotReached = Color(0xFFFD7E2F);
  static const Color taskTimelineDotBorder = Color(0xFF131720);
  static const Color taskVipBadgeBg = Color(0x26FCE64D);
  static const Color taskVipBadgeText = Color(0xFFFCE64D);
  static const Color taskPopularIconBg = Color(0xFFFF7E32);
  static const Color taskPopularGradientStart = Color(0xFFFF5065);
  static const Color taskPopularGradientEnd = Color(0xFFFFB06B);
  static const Color taskVipGradientBadgeText = Color(0xFF740551);
  static const Color taskProgressLabel = Color(0x99FFFFFF);
  // VIP 每日能量条：左→右由半透明白渐隐为全透明（Figma 559:23239）。
  static const Color vipEntryBadgeGradientStart = Color(0x52FFFFFF);
  static const Color vipEntryBadgeGradientEnd = Color(0x00FFFFFF);
  static const Color vipEntryBadgeText = Color(0xFF740551);
}
