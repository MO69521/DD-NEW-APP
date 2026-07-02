import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_segmented_switch.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/ranking_channel.dart';

/// 频道分段控件（Figma 1297:827）：全部 / 女频 / 男频。
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
    return AppSegmentedSwitch(
      itemCount: RankingChannel.values.length,
      selectedIndex: RankingChannel.values.indexOf(selected),
      onChanged: (index) => onSelected(RankingChannel.values[index]),
      outerRadius: AppRadius.rankingSegmentedOuter,
      innerRadius: AppRadius.rankingSegmentedInner,
      outerPadding: AppSizes.rankingSegmentedOuterPadding,
      itemPaddingVertical: AppSizes.rankingSegmentedItemPaddingVertical,
      blurSigma: AppSizes.rankingSegmentedBlurSigma,
      itemBuilder: (context, index, isSelected) {
        final channel = RankingChannel.values[index];
        return AppText(
          channel.label,
          style: isSelected
              ? AppTextStyles.rankingChannelActive
              : AppTextStyles.rankingChannelInactive,
        );
      },
    );
  }
}
