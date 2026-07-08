import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../domain/entities/search_result_item.dart';
import 'search_result_row.dart';

/// L3 — 搜索结果列表（builder 渲染，行间 16px 间距）。
class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.items,
    this.inShelfBookIds = const {},
    this.onItemTap,
    this.onAddToShelf,
  });

  final List<SearchResultItem> items;
  final Set<String> inShelfBookIds;
  final void Function(Book book)? onItemTap;
  final void Function(Book book)? onAddToShelf;

  static const double _bottomReserve = AppBottomNav.barHeight + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppLayout.chromeTopHeight(context) + AppSpacing.md,
        AppSpacing.md,
        _bottomReserve,
      ),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = items[index];
        return SearchResultRow(
          item: item,
          isInShelf: inShelfBookIds.contains(item.book.id),
          onTap: onItemTap,
          onAddToShelf: onAddToShelf,
        );
      },
    );
  }
}
