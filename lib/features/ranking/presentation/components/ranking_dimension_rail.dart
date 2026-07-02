import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_vertical_rail_switch.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/ranking_dimension.dart';

/// 左侧竖向维度切换栏（Figma 220:8570）。
class RankingDimensionRail extends StatelessWidget {
  const RankingDimensionRail({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RankingDimension selected;
  final ValueChanged<RankingDimension> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.rankingDimensionRailWidth,
      child: AppVerticalRailSwitch(
        itemCount: RankingDimension.values.length,
        selectedIndex: RankingDimension.values.indexOf(selected),
        onChanged: (index) => onSelected(RankingDimension.values[index]),
        itemSlotHeight: AppSizes.rankingDimensionItemSlotHeight,
        itemPaddingHorizontal: AppSizes.rankingDimensionItemPaddingHorizontal,
        itemPaddingVertical: AppSizes.rankingDimensionItemPaddingVertical,
        indicatorWidth: AppSizes.rankingDimensionIndicatorWidth,
        indicatorHeight: AppSizes.rankingDimensionIndicatorHeight,
        indicatorColor: AppColors.rankingDimensionIndicator,
        itemBuilder: (context, index, isSelected) {
          final dimension = RankingDimension.values[index];
          return AppText(
            dimension.label,
            style: isSelected
                ? AppTextStyles.rankingDimensionActive
                : AppTextStyles.rankingDimensionInactive,
          );
        },
      ),
    );
  }
}
