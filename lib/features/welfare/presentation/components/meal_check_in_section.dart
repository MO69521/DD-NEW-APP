import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                _GoldEnergyRewardChip(amount: summary.rewardAmount),
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

class _GoldEnergyRewardChip extends StatelessWidget {
  const _GoldEnergyRewardChip({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.welfareTaskRewardChipHeight,
      padding: const EdgeInsets.only(left: AppSpacing.xs, right: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppWelfareColors.checkInCumulativeBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: AppWelfareColors.checkInCumulativeBorder,
          width: AppSizes.hairline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetImage(
            assetPath: WelfareAssetMapper.checkInMilestoneEnergyIconAsset(),
            width: AppSizes.welfareTaskRewardIconSize,
            height: AppSizes.welfareTaskRewardIconSize,
          ),
          const SizedBox(width: AppSpacing.xxsHalf),
          AppText(
            '$amount',
            style: AppTextStyles.captionMd.copyWith(
              color: AppWelfareColors.checkInMilestoneAmount,
              fontWeight: AppFontWeights.medium,
            ),
          ),
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
