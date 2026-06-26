import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';
import '../../../../core/theme/app_theme_context.dart';

/// 书架页顶部 Tab 切换（书架 / 阅读历史）。
///
/// 视觉与交互模式对齐书城 [RankingTabs]，独立实现便于后续统一重构。
class BookshelfPageTabs extends StatelessWidget {
  const BookshelfPageTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final BookshelfTab selected;
  final ValueChanged<BookshelfTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = BookshelfTab.values;

    return Row(
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          _BookshelfTabItem(
            tab: tabs[i],
            isSelected: tabs[i] == selected,
            onTap: () => onSelected(tabs[i]),
          ),
        ],
      ],
    );
  }
}

class _BookshelfTabItem extends StatelessWidget {
  const _BookshelfTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final BookshelfTab tab;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            tab.label,
            style: (isSelected
                    ? AppTextStyles.tabActiveDark
                    : AppTextStyles.tabInactiveDark)
                .copyWith(
              color: isSelected ? colors.textPrimary : colors.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: AppSizes.tabIndicatorWidth,
            height: AppSizes.tabIndicatorHeight,
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.accent
                  : colors.accent.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ],
      ),
    );
  }
}
