import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_milestone_progress.dart';
import 'reading_welfare_calendar.dart';

/// L3 组件 — 7 日阅读福利整块（Figma 519:8876）。
class ReadingWelfareSection extends StatelessWidget {
  const ReadingWelfareSection({
    super.key,
    required this.summary,
    this.onReadTap,
  });

  final ReadingWelfareSummary summary;
  final VoidCallback? onReadTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.welfareCheckInSection),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            '7日阅读福利',
            style: AppTextStyles.welfareSectionTitle.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          _ReadingWelfareSubtitle(summary: summary),
          const SizedBox(height: AppSpacing.md),
          CheckInMilestoneProgress(
            totalDays: summary.totalReadingMinutes,
            milestones: summary.progressMilestones,
            cumulativeBadgeTitle: '累计阅读',
            cumulativeBadgeValue: summary.cumulativeDisplayHours,
            milestoneLabels: summary.milestoneLabels,
          ),
          const SizedBox(height: AppSpacing.md),
          ReadingWelfareCalendar(days: summary.weekDays),
          const SizedBox(height: AppSpacing.md),
          GestureDetector(
            onTap: onReadTap,
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
              child: Center(
                child: AppText(
                  '去阅读',
                  style: AppTextStyles.welfareCtaText.copyWith(
                    color: AppWelfareColors.checkInCtaTextDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingWelfareSubtitle extends StatelessWidget {
  const _ReadingWelfareSubtitle({required this.summary});

  final ReadingWelfareSummary summary;

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
          TextSpan(text: summary.dateRangeText),
          const TextSpan(text: '，阅读时长满 '),
          TextSpan(text: '${summary.targetHours}', style: highlightStyle),
          const TextSpan(text: ' 小时，再阅读 '),
          TextSpan(
            text: '${summary.minutesUntilNextReward}',
            style: highlightStyle,
          ),
          const TextSpan(text: ' 分钟可领丰厚奖励'),
        ],
      ),
    );
  }
}
