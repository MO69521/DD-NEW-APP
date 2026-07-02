import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../domain/entities/category_filter.dart';
import 'category_filter_chip.dart';

/// L3 — 筛选区：多组可换行的单选标签。
class CategoryFilterSection extends StatelessWidget {
  const CategoryFilterSection({
    super.key,
    required this.groups,
    required this.selectedIndexFor,
    this.onSelect,
  });

  final List<CategoryFilterGroup> groups;
  final int Function(String groupId) selectedIndexFor;
  final void Function(String groupId, int index)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var g = 0; g < groups.length; g++) ...[
          if (g == 1) ...[
            const SizedBox(height: AppSizes.categoryFilterDividerTopGap),
            const _CategoryFilterDivider(),
            const SizedBox(height: AppSizes.categoryFilterDividerBottomGap),
          ] else if (g > 1)
            const SizedBox(height: AppSizes.categoryFilterGroupSpacing),
          _FilterGroupRow(
            group: groups[g],
            selectedIndex: selectedIndexFor(groups[g].id),
            emphasis: g == 0
                ? CategoryFilterChipEmphasis.primary
                : CategoryFilterChipEmphasis.secondary,
            onSelect: onSelect,
          ),
        ],
      ],
    );
  }
}

class _CategoryFilterDivider extends StatelessWidget {
  const _CategoryFilterDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: AppSizes.hairline,
      child: ColoredBox(color: AppColors.dividerOnDark),
    );
  }
}

class _FilterGroupRow extends StatelessWidget {
  const _FilterGroupRow({
    required this.group,
    required this.selectedIndex,
    required this.emphasis,
    this.onSelect,
  });

  final CategoryFilterGroup group;
  final int selectedIndex;
  final CategoryFilterChipEmphasis emphasis;
  final void Function(String groupId, int index)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.categoryFilterChipSpacing,
      runSpacing: AppSizes.categoryFilterChipRunSpacing,
      children: [
        for (var i = 0; i < group.options.length; i++)
          CategoryFilterChip(
            label: group.options[i],
            selected: i == selectedIndex,
            emphasis: emphasis,
            onTap: onSelect == null ? null : () => onSelect!(group.id, i),
          ),
      ],
    );
  }
}
