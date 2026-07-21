import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_timeline_reward_row.dart';
import 'welfare_task_timeline_styles.dart';
import 'welfare_timeline_dot.dart';

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
            WelfareTimelineRewardRow(nodes: nodes),
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

  /// 首节点中心到末节点中心的标准进度区间。
  double get _trackWidth => totalWidth - AppSizes.welfareTaskTimelineNodeWidth;

  double _nodeCenterX(int index) {
    return _trackLeft +
        index * (AppSizes.welfareTaskTimelineNodeWidth + AppSpacing.xs);
  }

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);
    const lineTop =
        (AppSizes.welfareTaskTimelineProgressHeight -
            AppSizes.welfareTaskTimelineLineHeight) /
        2;
    const dotTop =
        (AppSizes.welfareTaskTimelineProgressHeight -
            AppSizes.welfareTaskTimelineDotSize) /
        2;

    return SizedBox(
      height: AppSizes.welfareTaskTimelineProgressHeight,
      child: Stack(
        children: [
          Positioned(
            left: 0,
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
            left: 0,
            top: lineTop,
            child: Container(
              // 左侧补齐半个节点宽，再按原节点中心区间计算进度，
              // 保持进度比例不变并与内容区左边界对齐。
              width: _trackLeft + _trackWidth * safeProgress,
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
              child: WelfareTimelineDot(
                isHighlighted: nodes[index].isReached || nodes[index].isActive,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineFooterRow extends StatelessWidget {
  const _TimelineFooterRow({required this.nodes});

  final List<WelfareTaskTimelineNode> nodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var index = 0; index < nodes.length; index++) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          SizedBox(
            width: AppSizes.welfareTaskTimelineNodeWidth,
            child: _TimelineFooterCell(node: nodes[index]),
          ),
        ],
      ],
    );
  }
}

class _TimelineFooterCell extends StatelessWidget {
  const _TimelineFooterCell({required this.node});

  final WelfareTaskTimelineNode node;

  @override
  Widget build(BuildContext context) {
    final color = welfareTimelineFooterColor(node);
    final label = node.isActive
        ? '去领取'
        : node.isReached
        ? '已领取'
        : node.label;
    final showVideoIcon =
        node.showVideoIcon && !node.isActive && !node.isReached;

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showVideoIcon) ...[
          Icon(
            Icons.play_circle_fill_rounded,
            size: AppSizes.welfareTaskRewardIconSize,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xxsHalf),
        ],
        Flexible(
          child: AppText(
            label,
            style: AppTextStyles.welfareSubtitle.copyWith(
              color: color,
              height: AppLineHeights.none,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    // 可领取：文案做成按钮样式（与行内奖励角标同底 + 胶囊圆角；
    // 原 surfaceCard 与福利卡片容器同色导致按钮底不可见）。
    final cell = Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: node.isActive
          ? BoxDecoration(
              color: AppWelfareColors.taskRewardChipBg,
              borderRadius: BorderRadius.circular(AppRadius.full),
            )
          : null,
      child: content,
    );

    // 已领取：整体降至 30% 不透明度。
    if (node.isReached) {
      return Opacity(
        opacity: AppSizes.welfareCheckInClaimedRewardOpacity,
        child: cell,
      );
    }
    return cell;
  }
}
