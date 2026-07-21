import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import '../mappers/welfare_asset_mapper.dart';
import 'welfare_reward_bubble.dart';
import 'welfare_timeline_dot.dart';

/// L3 组件 — VIP 翻倍中的 7 日阅读福利进度卡（Figma 559:23119）。
class ReadingVipProgressSection extends StatelessWidget {
  const ReadingVipProgressSection({
    super.key,
    required this.task,
    required this.onInfoTap,
  });

  final WelfareTaskItem task;
  final VoidCallback onInfoTap;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText(
                task.title,
                style: AppTextStyles.welfareSectionTitle.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              AppPressable(
                onTap: onInfoTap,
                child: const Icon(
                  Icons.info_outline,
                  size: AppSizes.titleInfoIconSize,
                  color: AppWelfareColors.subtitleMuted,
                ),
              ),
              if (task.tagLabel != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _VipGradientBadge(label: task.tagLabel!),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            task.description,
            style: AppTextStyles.welfareSubtitle.copyWith(
              color: AppWelfareColors.subtitleMuted,
              height: AppLineHeights.none,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ReadingProgressTrack(task: task),
        ],
      ),
    );
  }
}

class _VipGradientBadge extends StatelessWidget {
  const _VipGradientBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.welfareTaskVipBadgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppWelfareColors.vipBannerGradientStart,
            AppWelfareColors.vipBannerGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Center(
        child: AppText(
          label,
          style: AppTextStyles.captionMd.copyWith(
            color: AppWelfareColors.vipCtaText,
          ),
        ),
      ),
    );
  }
}

class _ReadingProgressTrack extends StatelessWidget {
  const _ReadingProgressTrack({required this.task});

  final WelfareTaskItem task;

  // 气泡尾巴会下探与圆点相接（Figma 气泡底 y=92、圆点上沿 y=94），
  // 因此顶部仅预留到圆点上沿，即圆点在节点格内的上边距。
  static const double _badgeAreaHeight =
      (AppSizes.welfareTaskTimelineProgressHeight -
          AppSizes.welfareTaskTimelineDotSize) /
      2;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final nodes = task.timelineNodes;
        if (nodes.isEmpty) {
          return const SizedBox.shrink();
        }

        final progress = task.timelineProgress.clamp(0.0, 1.0);
        const cellHeight = AppSizes.welfareTaskTimelineProgressHeight;
        const lineHeight = AppSizes.welfareTaskTimelineLineHeight;
        const lineTop = _badgeAreaHeight + cellHeight / 2 - lineHeight / 2;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 进度轨道（底）
            Positioned(
              left: 0,
              right: 0,
              top: lineTop,
              child: Container(
                height: lineHeight,
                decoration: BoxDecoration(
                  color: AppWelfareColors.taskTimelineTrack,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            // 已完成填充
            Positioned(
              left: 0,
              top: lineTop,
              child: Container(
                width: constraints.maxWidth * progress,
                height: lineHeight,
                decoration: BoxDecoration(
                  color: AppWelfareColors.taskTimelineFill,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
            // 节点（圆点/限免卡 + 文案），圆点压在轨道上
            Padding(
              padding: const EdgeInsets.only(top: _badgeAreaHeight),
              child: Row(
                children: [
                  for (final node in nodes)
                    Expanded(child: _ReadingProgressNode(node: node)),
                ],
              ),
            ),
            // 浮动进度气泡（带向下尾巴，水平随进度定位）
            if ((task.timelineBadgeLabel ?? '').isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment(progress * 2 - 1, -1),
                  child: Transform.translate(
                    offset: const Offset(0, -AppSpacing.xxsHalf),
                    child: _ProgressBadge(label: task.timelineBadgeLabel!),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ReadingProgressNode extends StatelessWidget {
  const _ReadingProgressNode({required this.node});

  final WelfareTaskTimelineNode node;

  bool get _isFreeCard =>
      node.rewards.any((reward) => reward.type == CheckInRewardType.freeCard);

  @override
  Widget build(BuildContext context) {
    final labelColor = node.isActive
        ? AppWelfareColors.taskTimelineFill
        : AppWelfareColors.subtitleMuted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 圆点/限免卡：在轨道线高度内垂直居中
        SizedBox(
          height: AppSizes.welfareTaskTimelineProgressHeight,
          child: Center(
            child: _isFreeCard
                ? OverflowBox(
                    maxWidth: AppSizes.welfareReadingFreeCardWidth,
                    maxHeight: AppSizes.welfareReadingFreeCardHeight,
                    child: Transform.translate(
                      offset: const Offset(0, -AppSpacing.xs),
                      child: AppAssetImage(
                        assetPath: WelfareAssetMapper.checkInRewardIconAsset(
                          CheckInRewardType.freeCard,
                        ),
                        width: AppSizes.welfareReadingFreeCardWidth,
                        height: AppSizes.welfareReadingFreeCardHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : WelfareTimelineDot(
                    isHighlighted: node.isActive || node.isReached,
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppText(
          node.label,
          style: AppTextStyles.labelMedium.copyWith(
            color: labelColor,
            height: AppLineHeights.none,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// 浮动进度气泡：橙色底 + 白字 + 向下尾巴（复用通用气泡）。
class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return WelfareRewardBubble(
      background: AppWelfareColors.taskTimelineFill,
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        right: AppSpacing.xs,
        top: AppSpacing.xxsHalf,
        bottom: AppSpacing.xxsHalf + AppSizes.welfareTaskTimelineTailHeight,
      ),
      child: AppText(
        label,
        style: AppTextStyles.captionMd.copyWith(color: AppColors.white100),
      ),
    );
  }
}
