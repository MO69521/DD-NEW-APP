import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/category_book_item.dart';
import 'category_book_row.dart';

/// L3 — 分类结果列表（builder 渲染的 sliver，行间 16px 间距）。
class CategoryBookList extends StatelessWidget {
  const CategoryBookList({super.key, required this.items, this.onItemTap});

  final List<CategoryBookItem> items;
  final void Function(Book book)? onItemTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final row = CategoryBookRow(item: items[index], onTap: onItemTap);
          if (index == 0) return row;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              row,
            ],
          );
        }, childCount: items.length),
      ),
    );
  }
}
