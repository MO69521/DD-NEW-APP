import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_calendar.dart';
import 'check_in_milestone_progress.dart';
import 'check_in_subtitle.dart';
import '../../../../core/theme/app_theme_context.dart';

/// L3 组件 — 每日签到整块（Figma 1492:3474）。
///
/// 标题右侧 chevron 可折叠：展开显示累计进度 / 日历 / 签到按钮，
/// 折叠仅保留标题与副标题（默认展开）。
class DailyCheckInSection extends StatefulWidget {
  const DailyCheckInSection({
    super.key,
    required this.summary,
    this.onCheckInTap,
  });

  final CheckInSummary summary;
  final VoidCallback? onCheckInTap;

  @override
  State<DailyCheckInSection> createState() => _DailyCheckInSectionState();
}

class _DailyCheckInSectionState extends State<DailyCheckInSection> {
  bool _expanded = true;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final summary = widget.summary;
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
          AppPressable(
            onTap: _toggle,
            pressScale: AppSizes.tapPressScaleSubtle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
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
                      CheckInSubtitle(
                        totalDays: summary.totalDays,
                        daysUntilNextReward: summary.daysUntilNextReward,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AnimatedRotation(
                  turns: _expanded ? 0 : 0.5,
                  duration: AppDurations.normal,
                  child: AppIcon(
                    assetPath: 'assets/icons/chevron_down.svg',
                    width: AppSizes.welfareCheckInChevronSize,
                    height: AppSizes.welfareCheckInChevronSize,
                    color: AppColors.white60,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: AppDurations.normal,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        onTap: widget.onCheckInTap,
                      ),
                    ],
                  )
                : const SizedBox(width: double.infinity),
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathScale,
      child: AppPressable(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.welfareCheckInCta),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppWelfareColors.checkInCtaSolid,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: SweepHighlightOverlay(
                    highlightColor: AppWelfareColors.checkInCtaSweepHighlight,
                    edgeColor: AppWelfareColors.checkInCtaSweepEdge,
                  ),
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

