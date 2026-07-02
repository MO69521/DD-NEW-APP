import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_segmented_switch.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_detail_tab.dart';

/// 详情 / 讨论 / 更新 Tab 切换器（Figma 209:7263）。
class BookDetailTabSwitcher extends StatelessWidget {
  const BookDetailTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.discussionCount,
  });

  final BookDetailTab selectedTab;
  final ValueChanged<BookDetailTab> onTabSelected;
  final int discussionCount;

  @override
  Widget build(BuildContext context) {
    return AppSegmentedSwitch(
      itemCount: BookDetailTab.values.length,
      selectedIndex: BookDetailTab.values.indexOf(selectedTab),
      onChanged: (index) => onTabSelected(BookDetailTab.values[index]),
      itemBuilder: (context, index, isSelected) {
        final tab = BookDetailTab.values[index];
        return _TabItemContent(
          tab: tab,
          selected: isSelected,
          count: tab == BookDetailTab.discussion ? discussionCount : null,
        );
      },
    );
  }
}

class _TabItemContent extends StatelessWidget {
  const _TabItemContent({
    required this.tab,
    required this.selected,
    this.count,
  });

  final BookDetailTab tab;
  final bool selected;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          tab.label,
          style: selected
              ? AppTextStyles.bookDetailTabSelected
              : AppTextStyles.bookDetailTabUnselected,
        ),
        if (count != null) ...[
          const SizedBox(width: AppSpacing.xxs),
          AppText(
            '($count)',
            style: selected
                ? AppTextStyles.bookDetailTabCountSelected
                : AppTextStyles.bookDetailTabCount,
          ),
        ],
      ],
    );
  }
}
