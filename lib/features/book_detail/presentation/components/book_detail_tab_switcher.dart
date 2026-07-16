import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_segmented_switch.dart';
import '../../../../shared/components/app_tab_count_badge.dart';
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
    const tabs = BookDetailTab.values;
    final discussionIndex = tabs.indexOf(BookDetailTab.discussion);

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / tabs.length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            AppSegmentedSwitch(
              itemCount: tabs.length,
              selectedIndex: tabs.indexOf(selectedTab),
              onChanged: (index) => onTabSelected(tabs[index]),
              itemBuilder: (context, index, isSelected) {
                return _TabItemContent(tab: tabs[index], selected: isSelected);
              },
            ),
            if (discussionCount > 0)
              Positioned(
                top: -AppSpacing.xs,
                left:
                    itemWidth * discussionIndex + itemWidth / 2 + AppSpacing.xs,
                child: AppTabCountBadge(count: discussionCount),
              ),
          ],
        );
      },
    );
  }
}

class _TabItemContent extends StatelessWidget {
  const _TabItemContent({required this.tab, required this.selected});

  final BookDetailTab tab;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AppText(
      tab.label,
      style: selected
          ? AppTextStyles.bookDetailTabSelected
          : AppTextStyles.bookDetailTabUnselected,
    );
  }
}
