import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'check_in_calendar.dart';
import 'check_in_cta_button.dart';
import 'check_in_milestone_progress.dart';
import 'check_in_subtitle.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../core/theme/app_icon_assets.dart';

/// L3 组件 — 每日签到整块（Figma 1492:3474）。
///
/// 标题右侧 chevron 可折叠：展开显示累计进度 / 日历 / 签到按钮，
/// 折叠仅保留标题与副标题（默认展开）。
class DailyCheckInSection extends StatefulWidget {
  const DailyCheckInSection({
    super.key,
    required this.summary,
    this.checkedIn = false,
    this.onCheckInTap,
    this.onWatchVideoTap,
  });

  final CheckInSummary summary;

  /// 今日是否已签到；为 true 时底部按钮切换为「看视频再领星辰」。
  final bool checkedIn;
  final VoidCallback? onCheckInTap;
  final VoidCallback? onWatchVideoTap;

  @override
  State<DailyCheckInSection> createState() => _DailyCheckInSectionState();
}

class _DailyCheckInSectionState extends State<DailyCheckInSection>
    with AutomaticKeepAliveClientMixin {
  bool _expanded = true;

  @override
  bool get wantKeepAlive => true;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        border: Border.all(color: colors.borderGlass, width: AppSizes.hairline),
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
                  child: const AppIcon(
                    assetPath: AppIconAssets.chevronDown,
                    width: AppSizes.welfareCheckInChevronSize,
                    height: AppSizes.welfareCheckInChevronSize,
                    color: AppColors.textOnDarkPlaceholder,
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
                      CheckInCtaButton(
                        leadingLabel: widget.checkedIn ? '看视频' : '立即签到',
                        trailingLabel: widget.checkedIn
                            ? '再领${summary.videoExtraStardust}星辰'
                            : '+${summary.todayRewardEnergy}能量',
                        onTap: widget.checkedIn
                            ? widget.onWatchVideoTap
                            : widget.onCheckInTap,
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
