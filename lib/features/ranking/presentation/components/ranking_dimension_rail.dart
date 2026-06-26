import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../domain/entities/ranking_dimension.dart';
import 'ranking_dimension_rail_item.dart';

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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final dimension in RankingDimension.values)
              RankingDimensionRailItem(
                dimension: dimension,
                isSelected: dimension == selected,
                onTap: () => onSelected(dimension),
              ),
          ],
        ),
      ),
    );
  }
}
