import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookstore_top_tab.dart';

/// 书城顶栏一级 Tab（推荐 / 分类 / 排行）。
class BookstoreTopTabs extends StatelessWidget {
  const BookstoreTopTabs({
    super.key,
    required this.selected,
    this.onSelected,
  });

  final BookstoreTopTab selected;
  final ValueChanged<BookstoreTopTab>? onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = BookstoreTopTab.values;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          _BookstoreTopTabItem(
            tab: tabs[i],
            isSelected: tabs[i] == selected,
            onTap: onSelected == null ? null : () => onSelected!(tabs[i]),
          ),
        ],
      ],
    );
  }
}

class _BookstoreTopTabItem extends StatelessWidget {
  const _BookstoreTopTabItem({
    required this.tab,
    required this.isSelected,
    this.onTap,
  });

  final BookstoreTopTab tab;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AppText(
        tab.label,
        style: (isSelected
                ? AppTextStyles.tabActiveDark
                : AppTextStyles.tabInactiveDark)
            .copyWith(
          color: isSelected ? colors.textPrimary : colors.textMuted,
        ),
      ),
    );
  }
}
