import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/ranking_channel.dart';

/// 频道分段控件（Figma 220:8489）：全部 / 女频 / 男频，玻璃态。
class RankingChannelSegmented extends StatelessWidget {
  const RankingChannelSegmented({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RankingChannel selected;
  final ValueChanged<RankingChannel> onSelected;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.rankingSegmentedOuter);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.rankingSegmentedBlurSigma,
          sigmaY: AppSizes.rankingSegmentedBlurSigma,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.rankingSegmentedOuterPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: borderRadius,
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: Row(
            children: [
              for (final channel in RankingChannel.values)
                Expanded(
                  child: _SegmentItem(
                    channel: channel,
                    isSelected: channel == selected,
                    onTap: () => onSelected(channel),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentItem extends StatelessWidget {
  const _SegmentItem({
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  final RankingChannel channel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.rankingSegmentedItemPaddingVertical,
        ),
        alignment: Alignment.center,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.navActiveBackground,
                borderRadius:
                    BorderRadius.circular(AppRadius.rankingSegmentedInner),
              )
            : null,
        child: AppText(
          channel.label,
          style: isSelected
              ? AppTextStyles.rankingChannelActive
              : AppTextStyles.rankingChannelInactive,
        ),
      ),
    );
  }
}
