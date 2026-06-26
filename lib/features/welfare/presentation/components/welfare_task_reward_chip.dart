import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';

/// 福利任务奖励标签视觉变体。
enum WelfareTaskRewardChipVariant { gold, surface }

/// L3 组件 — 福利任务奖励标签。
class WelfareTaskRewardChip extends StatelessWidget {
  const WelfareTaskRewardChip({
    super.key,
    required this.reward,
    this.variant = WelfareTaskRewardChipVariant.gold,
  });

  final WelfareTaskReward reward;
  final WelfareTaskRewardChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final isSurface = variant == WelfareTaskRewardChipVariant.surface;

    return Container(
      height: AppSizes.welfareTaskRewardChipHeight,
      padding: const EdgeInsets.only(
        left: AppSpacing.insetXs,
        right: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isSurface
            ? AppWelfareColors.taskRewardChipBg
            : AppWelfareColors.checkInCumulativeBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: isSurface
            ? null
            : Border.all(
                color: AppWelfareColors.checkInCumulativeBorder,
                width: AppSizes.hairline,
              ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RewardIcon(type: reward.type, isMuted: reward.isMuted),
          const SizedBox(width: AppSpacing.xxsHalf),
          AppText(
            reward.label,
            style: AppTextStyles.welfareTaskRewardChipLabel.copyWith(
              color: isSurface
                  ? AppWelfareColors.taskRewardChipText
                  : AppWelfareColors.goldMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardIcon extends StatelessWidget {
  const _RewardIcon({required this.type, required this.isMuted});

  final CheckInRewardType type;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: WelfareAssetMapper.taskRewardIconAsset(type, isMuted: isMuted),
      width: AppSizes.welfareTaskRewardIconSize,
      height: AppSizes.welfareTaskRewardIconSize,
    );
  }
}
