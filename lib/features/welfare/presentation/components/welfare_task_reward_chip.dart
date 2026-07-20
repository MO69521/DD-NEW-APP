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

/// L3 组件 — 福利任务奖励标签。
///
/// 福利页所有行内奖励角标（VIP 签到奖励 / 看视频等任务行）统一此样式：
/// `taskRewardChipBg` 底 + `taskRewardChipText` 字，保证同页观感一致。
class WelfareTaskRewardChip extends StatelessWidget {
  const WelfareTaskRewardChip({super.key, required this.reward});

  final WelfareTaskReward reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.welfareTaskRewardChipHeight,
      padding: const EdgeInsets.only(left: AppSpacing.xs, right: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppWelfareColors.taskRewardChipBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RewardIcon(type: reward.type, isMuted: reward.isMuted),
          const SizedBox(width: AppSpacing.xxsHalf),
          AppText(
            reward.label,
            style: AppTextStyles.welfareTaskRewardChipLabel.copyWith(
              color: AppWelfareColors.taskRewardChipText,
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
