import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/app_top_bar_text_button.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/bookshelf_tab.dart';
import 'bookshelf_page_tabs.dart';

/// 书架页固定顶栏：Tab 行 + 「管理」入口。
///
/// [AppTopBar] 的「居中内容 + 右侧文字动作」变体；blur/statusBar 由页面外层负责。
/// [isManaging] 时居中内容切换为标题、右侧动作切换为「完成」。
class BookshelfPageHeader extends StatelessWidget {
  const BookshelfPageHeader({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onManageTap,
    this.swipeProgress,
    this.isManaging = false,
  });

  final BookshelfTab selectedTab;
  final ValueChanged<BookshelfTab> onTabSelected;
  final VoidCallback onManageTap;
  final ValueListenable<double>? swipeProgress;
  final bool isManaging;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final Widget center = isManaging
        ? AppText(
            selectedTab == BookshelfTab.history ? '管理阅读历史' : '书架管理',
            style: AppTextStyles.titleMediumDark.copyWith(
              color: colors.textPrimary,
            ),
          )
        : BookshelfPageTabs(
            selected: selectedTab,
            onSelected: onTabSelected,
            swipeProgress: swipeProgress,
          );

    return AppTopBar(
      height: AppSizes.bookshelfHeaderHeight,
      horizontalPadding: AppSpacing.sm,
      chromeBlurEnabled: false,
      center: center,
      trailing: AppTopBarTextButton(
        onTap: onManageTap,
        label: isManaging ? '完成' : '管理',
        style: AppTextStyles.bookshelfManageAction.copyWith(
          color: colors.textPlaceholder,
        ),
      ),
    );
  }
}
