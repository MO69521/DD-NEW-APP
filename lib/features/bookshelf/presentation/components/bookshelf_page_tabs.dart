import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/app_animated_tab_label.dart';
import '../../../../shared/components/elastic_tab_row.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../domain/entities/bookshelf_tab.dart';

/// 书架页顶部 Tab 切换（书架 / 阅读历史）。
///
/// 复用统一 [ElasticTabRow]（§3.5）：按文案实测宽度排布、指示线跟手，
/// 指示色随主题取 `context.appColors.accent`。
class BookshelfPageTabs extends StatelessWidget {
  const BookshelfPageTabs({
    super.key,
    required this.selected,
    required this.onSelected,
    this.swipeProgress,
  });

  final BookshelfTab selected;
  final ValueChanged<BookshelfTab> onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    const tabs = BookshelfTab.values;

    return ElasticTabRow(
      selectedIndex: tabs.indexOf(selected),
      swipeProgress: swipeProgress,
      indicatorColor: context.appColors.accent,
      children: [
        for (var i = 0; i < tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.md),
          _BookshelfTabItem(
            tab: tabs[i],
            index: i,
            selectedIndex: tabs.indexOf(selected),
            swipeProgress: swipeProgress,
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
    required this.index,
    required this.selectedIndex,
    this.swipeProgress,
    required this.onTap,
  });

  final BookshelfTab tab;
  final int index;
  final int selectedIndex;
  final ValueListenable<double>? swipeProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppPressable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Center(
          heightFactor: 1.0,
          child: AppAnimatedTabLabel(
            index: index,
            selectedIndex: selectedIndex,
            label: tab.label,
            activeStyle: AppTextStyles.tabActiveDark.copyWith(
              color: colors.textPrimary,
            ),
            inactiveStyle: AppTextStyles.tabInactiveDark.copyWith(
              color: colors.textMuted,
            ),
            swipeProgress: swipeProgress,
          ),
        ),
      ),
    );
  }
}
