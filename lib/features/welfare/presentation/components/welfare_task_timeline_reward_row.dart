import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import 'welfare_reward_bubble.dart';
import 'welfare_task_timeline_styles.dart';

/// 时间轴顶部奖励气泡行。
class WelfareTimelineRewardRow extends StatelessWidget {
  const WelfareTimelineRewardRow({super.key, required this.nodes});

  final List<WelfareTaskTimelineNode> nodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < nodes.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          SizedBox(
            width: AppSizes.welfareTaskTimelineNodeWidth,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _TimelineRewardPill(node: nodes[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _TimelineRewardPill extends StatelessWidget {
  const _TimelineRewardPill({required this.node});

  final WelfareTaskTimelineNode node;

  @override
  Widget build(BuildContext context) {
    if (node.rewards.isEmpty) {
      return const SizedBox.shrink();
    }

    final style = welfareTimelineNodeStyle(node);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < node.rewards.length; index++) ...[
          if (index > 0) const SizedBox(height: AppSpacing.xxs),
          _TimelineRewardRowItem(
            reward: node.rewards[index],
            textColor: style.text,
          ),
        ],
      ],
    );

    // 已领取只弱化内容，气泡背景保持实体可见。
    if (node.isReached) {
      content = Opacity(
        opacity: AppSizes.welfareCheckInClaimedRewardOpacity,
        child: content,
      );
    }

    return WelfareRewardBubble(
      background: style.background,
      border: style.border,
      child: content,
    );
  }
}

class _TimelineRewardRowItem extends StatelessWidget {
  const _TimelineRewardRowItem({required this.reward, required this.textColor});

  final WelfareTaskReward reward;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppAssetImage(
          assetPath: WelfareAssetMapper.taskRewardIconAsset(
            reward.type,
            isMuted: reward.isMuted,
          ),
          width: AppSizes.welfareTaskRewardIconSize,
          height: AppSizes.welfareTaskRewardIconSize,
        ),
        const SizedBox(width: AppSpacing.xxsHalf),
        AppText(
          reward.label,
          style: AppTextStyles.welfareTaskRewardChipLabel.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
