import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../../../shared/components/book_card_large_row.dart';
import '../../domain/entities/category_book_item.dart';

/// L3 — 分类结果行：映射到共享 [BookCardLargeRow]。
class CategoryBookRow extends StatelessWidget {
  const CategoryBookRow({super.key, required this.item, this.onTap});

  final CategoryBookItem item;
  final void Function(Book book)? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardLargeRow(
      coverAsset: item.book.coverAsset,
      title: item.book.title,
      meta: item.tags.join(' · '),
      description: item.description,
      footer: item.author,
      coverTag: BookCoverTag.fromLabel(item.badgeLabel),
      onTap: onTap == null ? null : () => onTap!(item.book),
    );
  }
}
