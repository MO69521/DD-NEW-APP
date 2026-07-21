import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../core/theme/app_icon_assets.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/welfare_models.dart';
import 'welfare_task_reward_chip.dart';
import 'welfare_vip_badge.dart';

/// L3 — 福利任务左侧文案块（标题 / 描述 / 奖励）。
class WelfareTaskTextBlock extends StatelessWidget {
  const WelfareTaskTextBlock({
    super.key,
    required this.task,
    this.descriptionHighlight,
  });

  final WelfareTaskItem task;
  final String? descriptionHighlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (task.showPopularIcon) ...[
              const _PopularIcon(),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: AppText(
                task.title,
                style: AppTextStyles.welfareSectionTitle.copyWith(
                  color: AppColors.textOnDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (task.progressLabel != null) ...[
              const SizedBox(width: AppSpacing.xs),
              AppText(
                task.progressLabel!,
                style: AppTextStyles.welfareTaskProgressLabel.copyWith(
                  color: AppWelfareColors.taskProgressLabel,
                ),
              ),
            ],
            if (task.tagLabel != null) ...[
              const SizedBox(width: AppSpacing.xs),
              WelfareVipBadge(label: task.tagLabel!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _TaskDescription(
          description: task.description,
          highlight: descriptionHighlight ?? task.descriptionHighlight,
        ),
        if (task.rewards.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final reward in task.rewards)
                WelfareTaskRewardChip(reward: reward),
            ],
          ),
        ],
      ],
    );
  }
}

class _PopularIcon extends StatelessWidget {
  const _PopularIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.welfareTaskPopularIconSize,
      height: AppSizes.welfareTaskPopularIconSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppWelfareColors.taskPopularGradientStart,
            AppWelfareColors.taskPopularGradientEnd,
          ],
        ),
      ),
      child: const Center(
        child: AppAssetImage(
          assetPath: AppIconAssets.hotFlame,
          width: AppSizes.welfareTaskRewardIconSize,
          height: AppSizes.welfareTaskRewardIconSize,
          color: AppColors.cornerBadgeText, // light-audit: keep-dark
        ),
      ),
    );
  }
}

class _TaskDescription extends StatelessWidget {
  const _TaskDescription({required this.description, this.highlight});

  final String description;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    if (highlight == null || highlight!.isEmpty) {
      return AppText(
        description,
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
          height: AppLineHeights.none,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.welfareSubtitle.copyWith(
          color: AppWelfareColors.subtitleMuted,
          height: AppLineHeights.normal,
        ),
        children: [
          TextSpan(text: description),
          TextSpan(
            text: highlight,
            style: AppTextStyles.welfareSubtitle.copyWith(
              color: AppWelfareColors.taskTimelineFill,
              height: AppLineHeights.normal,
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
