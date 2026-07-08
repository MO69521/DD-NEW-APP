import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import 'welfare_reward_bubble.dart';

/// 时间轴奖励节点三态视觉。
typedef _NodeStyle = ({Color background, Color? border, Color text});

_NodeStyle _nodeStyle(WelfareTaskTimelineNode node) {
  if (node.isActive) {
    return (
      background: AppWelfareColors.taskTimelineBubbleActive,
      border: AppWelfareColors.checkInCumulativeBorder,
      text: AppWelfareColors.checkInCtaTextDark,
    );
  }
  if (node.isReached) {
    return (
      background: AppWelfareColors.taskTimelineBubbleReached,
      border: null,
      text: AppColors.textOnDark,
    );
  }
  return (
    background: AppWelfareColors.checkInCumulativeBg,
    border: AppWelfareColors.checkInCumulativeBorder,
    text: AppWelfareColors.goldMedium,
  );
}

/// 时间轴底部文案颜色：当前可领橙色、已领白色、未达成/已过节点淡白。
Color _footerColor(WelfareTaskTimelineNode node, int index, int activeIndex) {
  if (node.isActive) {
    return AppWelfareColors.taskTimelineFill;
  }
  if (node.isReached) {
    return index < activeIndex
        ? AppWelfareColors.taskProgressLabel
        : AppColors.textOnDark;
  }
  return AppWelfareColors.taskProgressLabel;
}

int _activeNodeIndex(List<WelfareTaskTimelineNode> nodes) {
  for (var i = 0; i < nodes.length; i++) {
    if (nodes[i].isActive) return i;
  }
  return -1;
}

/// L3 组件 — 福利任务横向进度时间轴。
class WelfareTaskTimeline extends StatelessWidget {
  const WelfareTaskTimeline({
    super.key,
    required this.nodes,
    required this.progress,
  });

  final List<WelfareTaskTimelineNode> nodes;
  final double progress;

  /// 时间轴总宽 = 节点数 × 节点宽 + 节点间距，随节点数增长以支持横向滚动。
  double get _totalWidth =>
      nodes.length * AppSizes.welfareTaskTimelineNodeWidth +
      (nodes.length - 1) * AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    if (nodes.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: _totalWidth,
        child: Column(
          children: [
            _TimelineRewardRow(nodes: nodes),
            _TimelineProgressBar(
              nodes: nodes,
              progress: progress,
              totalWidth: _totalWidth,
            ),
            _TimelineFooterRow(nodes: nodes),
          ],
        ),
      ),
    );
  }
}

class _TimelineRewardRow extends StatelessWidget {
  const _TimelineRewardRow({required this.nodes});

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

    final style = _nodeStyle(node);

    return WelfareRewardBubble(
      background: style.background,
      border: style.border,
      child: Column(
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
      ),
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

class _TimelineProgressBar extends StatelessWidget {
  const _TimelineProgressBar({
    required this.nodes,
    required this.progress,
    required this.totalWidth,
  });

  final List<WelfareTaskTimelineNode> nodes;
  final double progress;
  final double totalWidth;

  double get _trackLeft => AppSizes.welfareTaskTimelineNodeWidth / 2;

  double get _trackWidth => totalWidth - AppSizes.welfareTaskTimelineNodeWidth;

  double _nodeCenterX(int index) {
    return _trackLeft +
        index * (AppSizes.welfareTaskTimelineNodeWidth + AppSpacing.xs);
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final lineTop =
        (AppSizes.welfareTaskTimelineProgressHeight -
            AppSizes.welfareTaskTimelineLineHeight) /
        2;
    final dotTop =
        (AppSizes.welfareTaskTimelineProgressHeight -
            AppSizes.welfareTaskTimelineDotSize) /
        2;

    return SizedBox(
      height: AppSizes.welfareTaskTimelineProgressHeight,
      child: Stack(
        children: [
          Positioned(
            left: _trackLeft,
            right: _trackLeft,
            top: lineTop,
            child: Container(
              height: AppSizes.welfareTaskTimelineLineHeight,
              decoration: BoxDecoration(
                color: AppWelfareColors.taskTimelineTrack,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          Positioned(
            left: _trackLeft,
            top: lineTop,
            child: Container(
              width: _trackWidth * safeProgress,
              height: AppSizes.welfareTaskTimelineLineHeight,
              decoration: BoxDecoration(
                color: AppWelfareColors.taskTimelineFill,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          for (var index = 0; index < nodes.length; index++)
            Positioned(
              left:
                  _nodeCenterX(index) - AppSizes.welfareTaskTimelineDotSize / 2,
              top: dotTop,
              child: _TimelineDot(node: nodes[index]),
            ),
        ],
      ),
    );
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({required this.node});

  final WelfareTaskTimelineNode node;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = node.isReached || node.isActive;

    return Container(
      width: AppSizes.welfareTaskTimelineDotSize,
      height: AppSizes.welfareTaskTimelineDotSize,
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppWelfareColors.taskTimelineDotReached
            : AppWelfareColors.taskTimelineDot,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppWelfareColors.taskTimelineDotBorder,
          width: AppSizes.welfareTaskTimelineDotBorderWidth,
        ),
      ),
    );
  }
}

class _TimelineFooterRow extends StatelessWidget {
  const _TimelineFooterRow({required this.nodes});

  final List<WelfareTaskTimelineNode> nodes;

  @override
  Widget build(BuildContext context) {
    final activeIndex = _activeNodeIndex(nodes);

    return SizedBox(
      height: AppSizes.welfareTaskTimelineFooterHeight,
      child: Row(
        children: [
          for (var index = 0; index < nodes.length; index++) ...[
            if (index > 0) const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: AppSizes.welfareTaskTimelineNodeWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (nodes[index].showVideoIcon) ...[
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: AppSizes.welfareTaskRewardIconSize,
                      color: _footerColor(nodes[index], index, activeIndex),
                    ),
                    const SizedBox(width: AppSpacing.xxsHalf),
                  ],
                  Flexible(
                    child: AppText(
                      nodes[index].label,
                      style: AppTextStyles.welfareSubtitle.copyWith(
                        color: _footerColor(nodes[index], index, activeIndex),
                        height: AppLineHeights.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
