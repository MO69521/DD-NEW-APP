import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/ranking_dimension.dart';

/// 左侧维度 Tab 单项（Figma 220:8571 等）：选中态左侧黄条 + 加粗放大文字。
class RankingDimensionRailItem extends StatelessWidget {
  const RankingDimensionRailItem({
    super.key,
    required this.dimension,
    required this.isSelected,
    required this.onTap,
  });

  final RankingDimension dimension;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.rankingDimensionItemPaddingHorizontal,
              vertical: AppSizes.rankingDimensionItemPaddingVertical,
            ),
            child: AppText(
              dimension.label,
              style: isSelected
                  ? AppTextStyles.rankingDimensionActive
                  : AppTextStyles.rankingDimensionInactive,
            ),
          ),
          if (isSelected)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  width: AppSizes.rankingDimensionIndicatorWidth,
                  height: AppSizes.rankingDimensionIndicatorHeight,
                  decoration: BoxDecoration(
                    color: AppColors.rankingDimensionIndicator,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
