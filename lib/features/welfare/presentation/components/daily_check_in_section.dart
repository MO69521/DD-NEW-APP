import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_calendar.dart';
import 'check_in_milestone_progress.dart';
import '../../../../core/theme/app_theme_context.dart';

/// L3 组件 — 每日签到整块（Figma 519:8475）。
class DailyCheckInSection extends StatelessWidget {
  const DailyCheckInSection({
    super.key,
    required this.summary,
    this.onCheckInTap,
  });

  final CheckInSummary summary;
  final VoidCallback? onCheckInTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.welfareCheckInSection),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            '每日签到',
            style: AppTextStyles.welfareSectionTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _CheckInSubtitle(
            totalDays: summary.totalDays,
            daysUntilNextReward: summary.daysUntilNextReward,
          ),
          const SizedBox(height: AppSpacing.lg),
          CheckInMilestoneProgress(
            totalDays: summary.totalDays,
            milestones: summary.milestones,
          ),
          const SizedBox(height: AppSpacing.lg),
          CheckInCalendar(days: summary.weekDays),
          const SizedBox(height: AppSpacing.lg),
          GestureDetector(
            onTap: onCheckInTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.welfareCheckInCtaPaddingHorizontal,
                vertical: AppSizes.welfareCheckInCtaPaddingVertical,
              ),
              decoration: BoxDecoration(
                color: AppWelfareColors.checkInCtaSolid,
                borderRadius: BorderRadius.circular(
                  AppRadius.welfareCheckInCta,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    '立即签到',
                    style: AppTextStyles.welfareCtaText.copyWith(
                      color: AppWelfareColors.checkInCtaTextDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxsHalf),
                  AppText(
                    '+${summary.todayRewardEnergy}能量',
                    style: AppTextStyles.welfareCtaText.copyWith(
                      color: AppWelfareColors.checkInCtaTextDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckInSubtitle extends StatelessWidget {
  const _CheckInSubtitle({
    required this.totalDays,
    required this.daysUntilNextReward,
  });

  final int totalDays;
  final int daysUntilNextReward;

  @override
  Widget build(BuildContext context) {
    final highlightStyle = AppTextStyles.welfareSubtitle.copyWith(
      color: AppWelfareColors.accentOrange,
    );

    return RichText(
      softWrap: true,
      text: TextSpan(
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
        ),
        children: [
          const TextSpan(text: '已累计签到 '),
          TextSpan(text: '$totalDays', style: highlightStyle),
          const TextSpan(text: ' 天，再签到 '),
          TextSpan(text: '$daysUntilNextReward', style: highlightStyle),
          const TextSpan(text: ' 天可领丰厚奖励'),
        ],
      ),
    );
  }
}
