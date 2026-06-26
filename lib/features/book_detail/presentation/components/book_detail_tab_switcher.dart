import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
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
    final radius = BorderRadius.circular(AppRadius.bookDetailTabBar);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.bookDetailGlassBlurSigma,
          sigmaY: AppSizes.bookDetailGlassBlurSigma,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.bookDetailTabOuterPadding),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: radius,
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: Row(
            children: [
              for (final tab in BookDetailTab.values)
                _TabItem(
                  tab: tab,
                  selected: tab == selectedTab,
                  count: tab == BookDetailTab.discussion
                      ? discussionCount
                      : null,
                  onTap: () => onTabSelected(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final BookDetailTab tab;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.bookDetailTabItemPaddingVertical,
          ),
          decoration: selected
              ? BoxDecoration(
                  color: AppColors.navActiveBackground,
                  borderRadius: BorderRadius.circular(
                    AppRadius.bookDetailTabItem,
                  ),
                )
              : null,
          child: Row(
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
          ),
        ),
      ),
    );
  }
}
