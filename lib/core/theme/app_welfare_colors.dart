import 'package:flutter/material.dart';

import 'app_brand_colors.dart';
import 'app_colors.dart';

/// 福利页专用色 token。品牌色引用 [AppBrandColors]、中性叠加色引用
/// [AppColors] 中性阶（单一真源）；仅福利页独有色保留字面量。
abstract final class AppWelfareColors {
  /// 浅色实验包判定：深色分支保持原值，浅色分支翻到浅底可读的实体语义 token。
  static const bool _isLight = AppBrandColors.isLightExperiment;

  static const Color vipBannerGradientStart = AppBrandColors.vipGradientStart;
  static const Color vipBannerGradientEnd = AppBrandColors.vipGradientEnd;
  static const Color vipBannerText = AppBrandColors.vipBannerText;
  static const Color vipCtaGradientStart = AppBrandColors.vipCtaGradientStart;
  static const Color vipCtaGradientEnd = AppBrandColors.vipCtaGradientEnd;

  /// 充值「会员免费领」角标底：`pink100Soft` 浅粉，全主题恒定（含 `pink_light`），不随浅色包翻转。
  static const Color vipFreeClaimBadgeBackground =
      vipCtaGradientEnd; // light-audit: keep-dark
  /// 充值「会员免费领」角标字：浅粉底上用深玫红（`magenta950`），全主题恒定。
  static const Color vipFreeClaimBadgeText = AppBrandColors.vipOnGradientText;
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
  static const Color checkInHighlightBorder =
      AppBrandColors.checkInHighlightHeader;
  // 今日卡头字（坐在主强调色上）：深色黄底配深字，浅色粉底翻白（onPrimary）。
  static const Color checkInTodayHeaderText = _isLight
      ? AppColors.onPrimary
      : AppBrandColors.textOnLightPanel;

  /// 今日可领奖励文字：走强调文字档（深色亮黄；浅色深黄/深粉，8% 黄底上可读）。
  static const Color checkInRewardTodayText = AppColors.accentText;
  // 普通签到日 / 里程碑气泡 / 累计卡底：深色 4% 白叠底，浅色翻为弱实体面。
  static const Color checkInDayBg = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white04;
  static const Color checkInDayHeader = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white04;
  // 弱描边：深色 4% 白、浅色浅粉，统一复用全局 borderSubtle（深色值不变）。
  static const Color checkInDayBorder = AppColors.borderSubtle;
  // 普通签到日文字：深色 60% 白、浅色二级墨字。
  static const Color checkInDayLabelMuted = _isLight
      ? AppColors.textSecondary
      : AppColors.white60;
  static const Color checkInCumulativeBg = checkInHighlightSurface;
  static const Color checkInCumulativeBorder = AppColors.white00;
  static const Color checkInCumulativeLabel = AppBrandColors.goldMedium;
  static const Color checkInCumulativeValue = AppBrandColors.goldDark;
  // 进度条轨道：深色 4% 白、浅色浅灰分割线。
  static const Color checkInProgressTrack = _isLight
      ? AppColors.divider
      : AppColors.white04;
  static const Color checkInProgressFill = Color(
    0xFFFD7E2F,
  ); // light-audit: keep-dark 进度橙，两态一致
  // 里程碑节点圆点：深色深底/深描边，浅色翻为浅灰点 + 纯白描边（确保可见）。
  static const Color checkInProgressDotFill = _isLight
      ? AppColors.border
      : Color(0xFF1B212A);
  static const Color checkInProgressDotStroke = _isLight
      ? AppColors
            .white100 // 浅色主题纯白描边
      : Color(0xFF121721);
  // 里程碑数值 / 文字：深色白字，浅色墨字（浅底可读）。
  static const Color checkInMilestoneAmount = _isLight
      ? AppColors.textPrimary
      : AppColors.white100;
  static const Color checkInMilestoneLabel = _isLight
      ? AppColors.textSecondary
      : AppColors.white60;
  static const Color checkInCtaSolid = AppBrandColors.checkInYellow;
  // 签到 CTA 文字/spinner（坐在主强调色上）：深色黄底深字，浅色粉底翻白。
  static const Color checkInCtaTextDark = _isLight
      ? AppColors.onPrimary
      : AppBrandColors.textOnLightPanel;
  static const Color checkInCtaSweepEdge = AppColors.white00;
  static const Color checkInCtaSweepHighlight = AppColors.white50;

  static const Color subtitleMuted = AppBrandColors.subtitleMuted;
  static const Color hotSaleBadge = AppBrandColors.hotSaleBadge;
  static const Color hotSaleBadgeText = AppColors.cornerBadgeText;

  /// 充值卡价格胶囊 / 非 VIP「免费领」按钮底：与「更多福利」一致，纯黑 4%，全主题统一。
  static const Color rechargePriceBg = AppColors.sectionMoreActionBackground;
  static const Color originalPriceMuted = AppBrandColors.originalPriceMuted;
  static const Color moreBenefitsAction = AppBrandColors.accent;

  static const Color taskDivider = _isLight
      ? AppColors.divider
      : AppColors.white04;
  static const Color taskActionBg = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white08;
  static const Color taskActionHighlightBg = AppBrandColors.checkInYellow;
  // 高亮任务按钮文字（坐在主强调色上）：深色黄底深字，浅色粉底翻白。
  static const Color taskActionHighlightText = _isLight
      ? AppColors.onPrimary
      : AppBrandColors.textOnLightPanel;
  static const Color taskRewardChipBg = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white04;
  static const Color taskRewardChipMutedBg = AppColors.black04;
  static const Color taskRewardChipText = _isLight
      ? AppColors.textPrimary
      : AppColors.white100;
  static const Color taskRewardChipMutedText = _isLight
      ? AppColors.textSecondary
      : AppColors.white60;
  static const Color taskTimelineTrack = _isLight
      ? AppColors.divider
      : AppColors.white08;
  static const Color taskTimelineFill = Color(
    0xFFFD7E2F,
  ); // light-audit: keep-dark 进度橙
  static const Color taskTimelineBubbleActive =
      AppBrandColors.checkInHighlightHeader;
  static const Color taskTimelineBubbleReached = _isLight
      ? AppColors.surfaceSoft
      : AppColors.white04;
  static const Color taskTimelineDot = _isLight
      ? AppColors.border
      : Color(0xFF1C2129);
  static const Color taskTimelineDotReached = Color(
    0xFFFD7E2F,
  ); // light-audit: keep-dark 已达节点橙
  static const Color taskTimelineDotBorder = _isLight
      ? AppColors
            .white100 // 浅色主题纯白描边，与签到节点统一
      : Color(0xFF131720);
  static const Color taskVipBadgeBg = AppColors.segmentedSelectedFill;
  static const Color taskVipBadgeText = AppBrandColors.checkInYellow;
  static const Color taskPopularIconBg = AppBrandColors.accentOrange;
  static const Color taskPopularGradientStart = Color(
    0xFFFF5065,
  ); // light-audit: keep-dark 热门角标渐变
  static const Color taskPopularGradientEnd = Color(
    0xFFFFB06B,
  ); // light-audit: keep-dark 热门角标渐变
  static const Color taskVipGradientBadgeText =
      AppBrandColors.vipOnGradientText;
  static const Color taskProgressLabel = _isLight
      ? AppColors.textSecondary
      : AppColors.white60;
  // VIP 每日能量条：左→右由半透明白渐隐为全透明（Figma 559:23239）。
  static const Color vipEntryBadgeGradientStart = Color(
    0x52FFFFFF,
  ); // light-audit: effect VIP 能量条白渐隐
  static const Color vipEntryBadgeGradientEnd = AppColors.white00;
  static const Color vipEntryBadgeText = AppBrandColors.vipOnGradientText;
}
