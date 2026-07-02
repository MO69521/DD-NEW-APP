import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/widgets/app_icon.dart';
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
            SizedBox(width: AppSizes.bookstoreSearchIconSize),
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

class _SearchIconButton extends StatefulWidget {
  const _SearchIconButton({this.onTap});

  final VoidCallback? onTap;

  @override
  State<_SearchIconButton> createState() => _SearchIconButtonState();
}

class _SearchIconButtonState extends State<_SearchIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AppIcon(
        assetPath: BookstorePageHeader.searchIconAsset,
        width: AppSizes.bookstoreSearchIconSize,
        height: AppSizes.bookstoreSearchIconSize,
        color: _pressed ? colors.accent : colors.textMuted,
      ),
    );
  }
}
