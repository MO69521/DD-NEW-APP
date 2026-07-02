import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
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
          _AnimatedCheckInCta(
            rewardEnergy: summary.todayRewardEnergy,
            onTap: onCheckInTap,
          ),
        ],
      ),
    );
  }
}

class _AnimatedCheckInCta extends StatefulWidget {
  const _AnimatedCheckInCta({required this.rewardEnergy, this.onTap});

  final int rewardEnergy;
  final VoidCallback? onTap;

  @override
  State<_AnimatedCheckInCta> createState() => _AnimatedCheckInCtaState();
}

class _AnimatedCheckInCtaState extends State<_AnimatedCheckInCta>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final AnimationController _sweepController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _sweepController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaSweep,
    )..repeat();
    _breathScale =
        Tween<double>(
          begin: AppSizes.membershipCtaBreathScaleMin,
          end: AppSizes.membershipCtaBreathScaleMax,
        ).animate(
          CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _breathController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathScale,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.welfareCheckInCta),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppWelfareColors.checkInCtaSolid,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: _CheckInCtaSweepOverlay(animation: _sweepController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.welfareCheckInCtaPaddingHorizontal,
                    vertical: AppSizes.welfareCheckInCtaPaddingVertical,
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
                        '+${widget.rewardEnergy}能量',
                        style: AppTextStyles.welfareCtaText.copyWith(
                          color: AppWelfareColors.checkInCtaTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckInCtaSweepOverlay extends StatelessWidget {
  const _CheckInCtaSweepOverlay({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth = constraints.maxWidth;
              final bandWidth =
                  buttonWidth * AppSizes.membershipCtaSweepBandWidthRatio;
              final travelDistance = buttonWidth + bandWidth;
              final offsetX = -bandWidth + travelDistance * animation.value;

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Container(
                      width: bandWidth,
                      height: constraints.maxHeight,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppWelfareColors.checkInCtaSweepEdge,
                            AppWelfareColors.checkInCtaSweepHighlight,
                            AppWelfareColors.checkInCtaSweepEdge,
                          ],
                          stops: [0, 0.5, 1],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
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
