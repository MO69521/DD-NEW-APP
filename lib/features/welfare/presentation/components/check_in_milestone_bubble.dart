import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import 'welfare_reward_bubble.dart';

/// 单个里程碑：能量气泡（代码绘制，自适应不裁切）+ 节点 + 文案。
class CheckInMilestoneBubble extends StatelessWidget {
  const CheckInMilestoneBubble({
    super.key,
    required this.milestone,
    this.milestoneLabel,
  });

  final CheckInMilestone milestone;
  final String? milestoneLabel;

  @override
  Widget build(BuildContext context) {
    const lineCenterY = AppSizes.welfareCheckInProgressLineCenterY;
    const dotSize = AppSizes.welfareCheckInProgressDotSize;
    const iconContainerTop =
        lineCenterY - AppSizes.welfareCheckInMilestoneDotTop - dotSize / 2;
    const labelTop =
        iconContainerTop +
        AppSizes.welfareCheckInMilestoneBubbleAreaHeight +
        AppSpacing.xs;

    return SizedBox(
      height: AppSizes.welfareCheckInMilestoneHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: iconContainerTop,
            left: 0,
            right: 0,
            child: Center(
              child: _MilestoneBubble(amount: milestone.rewardAmount),
            ),
          ),
          Positioned(
            top: labelTop,
            left: 0,
            right: 0,
            child: AppText(
              milestoneLabel ?? '累签${milestone.requiredDays}天',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.welfareCheckInMilestoneLabel,
            ),
          ),
        ],
      ),
    );
  }
}

/// 里程碑能量气泡：与左侧累计签到卡同底（无描边），内容为能量图标 + 数值。
class _MilestoneBubble extends StatelessWidget {
  const _MilestoneBubble({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    return WelfareRewardBubble(
      background: AppWelfareColors.checkInDayBg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAssetImage(
            assetPath: WelfareAssetMapper.checkInMilestoneEnergyIconAsset(),
            width: AppSizes.welfareCheckInSmallRewardIconSize,
            height: AppSizes.welfareCheckInSmallRewardIconSize,
          ),
          const SizedBox(width: AppSpacing.xxsHalf),
          AppText(
            '$amount',
            style: AppTextStyles.welfareCheckInMilestoneAmount,
          ),
        ],
      ),
    );
  }
}
