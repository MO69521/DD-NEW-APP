import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_timeline_reward_row.dart';
import 'welfare_task_timeline_styles.dart';

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

    final content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (node.showVideoIcon) ...[
          Icon(
            Icons.play_circle_fill_rounded,
            size: AppSizes.welfareTaskRewardIconSize,
            color: color,
          ),
          const SizedBox(width: AppSpacing.xxsHalf),
        ],
        Flexible(
          child: AppText(
            node.label,
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

    // 可领取：文案做成按钮样式（纯白 4% 底 + 胶囊圆角）。
    final cell = Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      decoration: node.isActive
          ? BoxDecoration(
              color: AppColors.surfaceCard,
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
