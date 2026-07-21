import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_row.dart';
import 'welfare_vip_title_rotator.dart';

/// L3 组件 — 福利页底部任务列表（Figma 559:23234）。
class WelfareTaskListSection extends StatelessWidget {
  const WelfareTaskListSection({
    super.key,
    required this.summary,
    this.onTaskActionTap,
    this.onVipTap,
  });

  final WelfareTaskListSummary summary;
  final ValueChanged<WelfareTaskItem>? onTaskActionTap;
  final VoidCallback? onVipTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TaskVipEntry(entry: summary.vipEntry, onTap: onVipTap),
        // 任务卡向上叠压横幅，并对露出的渐变做毛玻璃模糊（Figma 559:23234）。
        Transform.translate(
          offset: const Offset(0, -AppSizes.welfareTaskCardOverlap),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              AppRadius.welfareCheckInSection,
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppSizes.welfareTaskCardBlurSigma,
                sigmaY: AppSizes.welfareTaskCardBlurSigma,
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: AppSpacing.sm,
                  right: AppSpacing.sm,
                  bottom: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(
                    AppRadius.welfareCheckInSection,
                  ),
                  border: Border.all(
                    color: AppColors.borderGlass,
                    width: AppSizes.hairline,
                  ),
                ),
                child: Column(
                  children: [
                    for (
                      var index = 0;
                      index < summary.tasks.length;
                      index++
                    ) ...[
                      if (index > 0) const _TaskDivider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: WelfareTaskRow(
                          task: summary.tasks[index],
                          onActionTap: onTaskActionTap,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskVipEntry extends StatelessWidget {
  const _TaskVipEntry({required this.entry, this.onTap});

  final WelfareTaskVipEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Container(
        // 横幅粉色向下延伸，在 VIP 徽标与任务卡之间保留紧凑间距，
        // 且延伸段被任务卡向上叠压覆盖（见 welfareTaskCardOverlap），两侧不露底。
        padding: const EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          top: AppSpacing.md,
          bottom: AppSpacing.xl + AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppWelfareColors.vipBannerGradientStart,
              AppWelfareColors.vipBannerGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.welfareVipBanner),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 标题列按内容收缩，能量条与标题同宽（Figma 559:23237 shrink-0）。
            Flexible(
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WelfareVipTitleRotator(
                      titles: entry.titles,
                      textStyle: AppTextStyles.welfareVipBannerLabel.copyWith(
                        color: AppWelfareColors.vipCtaText,
                        fontWeight: AppFontWeights.semibold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _VipEntryBadge(label: entry.tagLabel),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _VipEntryActionButton(label: entry.actionLabel, onTap: onTap),
          ],
        ),
      ),
    );
  }
}

class _VipEntryBadge extends StatelessWidget {
  const _VipEntryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        top: AppSpacing.xxs,
        bottom: AppSpacing.xxs,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppWelfareColors.vipEntryBadgeGradientStart,
            AppWelfareColors.vipEntryBadgeGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xs),
          bottomLeft: Radius.circular(AppRadius.xs),
        ),
      ),
      child: AppText(
        label,
        style: AppTextStyles.captionMd.copyWith(
          color: AppWelfareColors.vipEntryBadgeText,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _VipEntryActionButton extends StatelessWidget {
  const _VipEntryActionButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppWelfareColors.vipCtaGradientStart,
              AppWelfareColors.vipCtaGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(AppRadius.welfareVipCta),
          border: Border.all(
            color: AppWelfareColors.vipCtaBorder,
            width: AppSizes.welfareVipCtaBorderWidth,
          ),
        ),
        child: AppText(
          label,
          style: AppTextStyles.welfareCtaText.copyWith(
            color: AppWelfareColors.vipCtaText,
          ),
        ),
      ),
    );
  }
}

class _TaskDivider extends StatelessWidget {
  const _TaskDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.hairline,
      color: AppWelfareColors.taskDivider,
    );
  }
}
