import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_reward_chip.dart';

/// L3 组件 — 吃饭签到简行（Figma 559:23066）。
class MealCheckInSection extends StatelessWidget {
  const MealCheckInSection({
    super.key,
    required this.summary,
    this.onVipClaimTap,
  });

  final MealCheckInSummary summary;
  final VoidCallback? onVipClaimTap;

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
        border: Border.all(
          color: AppColors.borderGlass,
          width: AppSizes.hairline,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      summary.title,
                      style: AppTextStyles.welfareSectionTitle.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    AppText(
                      summary.progressLabel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textOnDarkMuted,
                        height: AppLineHeights.none,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppText(
                  summary.subtitle,
                  style: AppTextStyles.welfareSubtitle.copyWith(
                    color: AppWelfareColors.subtitleMuted,
                    height: AppLineHeights.none,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                // 与任务行奖励角标统一样式（taskRewardChipBg 底），不再单独用金色底。
                WelfareTaskRewardChip(
                  reward: WelfareTaskReward(
                    type: CheckInRewardType.energy,
                    label: '${summary.rewardAmount}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _VipClaimButton(onTap: onVipClaimTap),
        ],
      ),
    );
  }
}

class _VipClaimButton extends StatelessWidget {
  const _VipClaimButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'VIP领取',
      variant: AppButtonVariant.vip,
      size: AppButtonSize.small,
      onPressed: onTap,
    );
  }
}
