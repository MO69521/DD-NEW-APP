import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../shared/components/book_card_search_result.dart';
import '../../../../shared/components/book_cover_badge.dart';
import '../../domain/entities/category_book_item.dart';

/// L3 — 分类结果行：把 [CategoryBookItem] 映射到共享布局
/// [BookCardSearchResult]，注入角标与作者脚注。
class CategoryBookRow extends StatelessWidget {
  const CategoryBookRow({
    super.key,
    required this.item,
    this.onTap,
  });

  final CategoryBookItem item;
  final void Function(Book book)? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardSearchResult(
      coverAsset: item.book.coverAsset,
      title: item.book.title,
      meta: item.tags.join(' · '),
      description: item.description,
      footer: item.author,
      leadingBadge: BookCoverBadge(label: item.badgeLabel),
      onTap: onTap == null ? null : () => onTap!(item.book),
    );
  }
}
