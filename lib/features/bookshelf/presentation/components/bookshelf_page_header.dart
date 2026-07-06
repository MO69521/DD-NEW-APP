import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/app_top_bar_text_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';
import 'bookshelf_page_tabs.dart';

/// 书架页固定顶栏：Tab 行 + 「管理」入口。
class BookshelfPageHeader extends StatelessWidget {
  const BookshelfPageHeader({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onManageTap,
    this.isManaging = false,
  });

  final BookshelfTab selectedTab;
  final ValueChanged<BookshelfTab> onTabSelected;
  final VoidCallback onManageTap;
  final bool isManaging;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (isManaging) {
      return SizedBox(
        height: AppSizes.bookshelfHeaderHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AppText(
                  selectedTab == BookshelfTab.history ? '管理阅读历史' : '书架管理',
                  style: AppTextStyles.titleMediumDark.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: AppTopBarTextButton(
                  onTap: onManageTap,
                  label: '完成',
                  style: AppTextStyles.bookshelfManageAction.copyWith(
                    color: colors.textPlaceholder,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: AppSizes.bookshelfHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: BookshelfPageTabs(
                selected: selectedTab,
                onSelected: onTabSelected,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: AppTopBarTextButton(
                onTap: onManageTap,
                label: '管理',
                style: AppTextStyles.bookshelfManageAction.copyWith(
                  color: colors.textPlaceholder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
