import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../domain/entities/bookstore_top_tab.dart';
import 'bookstore_top_tabs.dart';

/// L3 — 书城顶栏：推荐 / 分类 / 排行同级 Tab + 搜索图标。
///
/// [AppTopBar] 的「居中 Tab + 右侧动作」变体；blur/statusBar 由页面外层负责。
class BookstorePageHeader extends StatelessWidget {
  const BookstorePageHeader({
    super.key,
    required this.selectedTopTab,
    this.onTopTabSelected,
    this.onSearchTap,
    this.swipeProgress,
  });

  final BookstoreTopTab selectedTopTab;
  final ValueChanged<BookstoreTopTab>? onTopTabSelected;
  final VoidCallback? onSearchTap;
  final ValueListenable<double>? swipeProgress;

  static const String searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      height: AppSizes.bookstoreTopHeaderHeight,
      horizontalPadding: AppSpacing.sm,
      chromeBlurEnabled: false,
      center: BookstoreTopTabs(
        selected: selectedTopTab,
        onSelected: onTopTabSelected,
        swipeProgress: swipeProgress,
      ),
      trailing: _SearchIconButton(onTap: onSearchTap),
    );
  }
}

class _SearchIconButton extends StatelessWidget {
  const _SearchIconButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTopBarIconButton(
      onTap: onTap,
      iconAsset: BookstorePageHeader.searchIconAsset,
      iconWidth: AppSizes.bookstoreSearchIconSize,
      iconHeight: AppSizes.bookstoreSearchIconSize,
    );
  }
}
