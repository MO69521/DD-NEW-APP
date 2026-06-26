import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 单个筛选标签：选中 = 白字加粗 + 黄色下划线。
class CategoryFilterChip extends StatelessWidget {
  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            label,
            style: selected
                ? AppTextStyles.categoryFilterSelected
                : AppTextStyles.categoryFilterUnselected,
          ),
          const SizedBox(
            height: AppSizes.categoryFilterChipLabelToUnderlineGap,
          ),
          Container(
            width: AppSizes.categoryFilterUnderlineWidth,
            height: AppSizes.categoryFilterUnderlineHeight,
            decoration: BoxDecoration(
              color: selected ? AppColors.accentYellow : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
          ),
        ],
      ),
    );
  }
}
