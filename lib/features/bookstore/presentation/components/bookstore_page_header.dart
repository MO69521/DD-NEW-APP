import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../domain/entities/bookstore_top_tab.dart';
import 'bookstore_top_tabs.dart';

/// L3 — 书城顶栏：推荐 / 分类 / 排行同级 Tab + 搜索图标。
class BookstorePageHeader extends StatelessWidget {
  const BookstorePageHeader({
    super.key,
    required this.selectedTopTab,
    this.onTopTabSelected,
    this.onSearchTap,
  });

  final BookstoreTopTab selectedTopTab;
  final ValueChanged<BookstoreTopTab>? onTopTabSelected;
  final VoidCallback? onSearchTap;

  static const String searchIconAsset = 'assets/icons/search.svg';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.bookstoreTopHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            const SizedBox(width: AppSizes.topBarIconFrameSize),
            Expanded(
              child: Center(
                child: BookstoreTopTabs(
                  selected: selectedTopTab,
                  onSelected: onTopTabSelected,
                ),
              ),
            ),
            _SearchIconButton(onTap: onSearchTap),
          ],
        ),
      ),
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
