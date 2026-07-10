import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
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
    final label = AppText(
      tab.label,
      style: selected
          ? AppTextStyles.bookDetailTabSelected
          : AppTextStyles.bookDetailTabUnselected,
    );

    // 讨论数改为右上角悬浮红点：overlay 不占布局宽度，Tab 文案保持居中对齐。
    if (count == null || count! <= 0) return label;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        label,
        Positioned(
          top: -AppSpacing.xxs,
          right: -AppSpacing.xs,
          child: Container(
            width: AppSizes.bookDetailTabBadgeDotSize,
            height: AppSizes.bookDetailTabBadgeDotSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.badgeCount,
            ),
          ),
        ),
      ],
    );
  }
}
