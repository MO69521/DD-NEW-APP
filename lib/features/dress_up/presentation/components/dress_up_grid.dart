import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/dress_up_item.dart';
import 'dress_up_item_card.dart';

/// L3 — 装扮项 3 列宫格。
class DressUpGrid extends StatelessWidget {
  const DressUpGrid({
    super.key,
    required this.items,
    this.selectedItemId,
    this.onItemTap,
  });

  final List<DressUpItem> items;
  final String? selectedItemId;
  final ValueChanged<DressUpItem>? onItemTap;

  static const int _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.md;
        final available = constraints.maxWidth - AppSpacing.md * 2;
        final itemWidth =
            (available - spacing * (_crossAxisCount - 1)) / _crossAxisCount;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Wrap(
            spacing: spacing,
            runSpacing: AppSpacing.lg,
            children: [
              for (final item in items)
                SizedBox(
                  width: itemWidth,
                  child: DressUpItemCard(
                    item: item,
                    isSelected: item.id == selectedItemId,
                    onTap: onItemTap == null ? null : () => onItemTap!(item),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
