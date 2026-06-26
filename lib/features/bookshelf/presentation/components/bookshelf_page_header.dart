import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/theme/app_theme_context.dart';
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
    return SizedBox(
      height: AppSizes.bookshelfHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BookshelfPageTabs(
                selected: selectedTab,
                onSelected: onTabSelected,
              ),
            ),
            GestureDetector(
              onTap: onManageTap,
              behavior: HitTestBehavior.opaque,
              child: AppText(
                isManaging ? '完成' : '管理',
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
