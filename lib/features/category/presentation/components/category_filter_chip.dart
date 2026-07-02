import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

enum CategoryFilterChipEmphasis { primary, secondary }

/// L3 — 单个筛选标签：支持主分类强强调与次级筛选轻强调。
class CategoryFilterChip extends StatelessWidget {
  const CategoryFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.emphasis = CategoryFilterChipEmphasis.primary,
    this.showUnderline = true,
    this.onTap,
  });

  final String label;
  final bool selected;
  final CategoryFilterChipEmphasis emphasis;
  final bool showUnderline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final selectedStyle = switch (emphasis) {
      CategoryFilterChipEmphasis.primary =>
        AppTextStyles.categoryFilterSelected,
      CategoryFilterChipEmphasis.secondary =>
        AppTextStyles.categoryFilterSecondarySelected,
    };
    final showsUnderline = emphasis == CategoryFilterChipEmphasis.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            label,
            style: selected
                ? selectedStyle
                : AppTextStyles.categoryFilterUnselected,
          ),
          if (showsUnderline && showUnderline) ...[
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
        ],
      ),
    );
  }
}
