import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../shared/components/book_card_large_row.dart';

/// L3 — 榜单书行：映射到共享 [BookCardLargeRow]（大封面 + 标题/分类）。
class RankingBookRow extends StatelessWidget {
  const RankingBookRow({
    super.key,
    required this.book,
    this.onTap,
  });

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardLargeRow(
      coverAsset: book.coverAsset,
      title: book.title,
      meta: book.category,
      titleMaxLines: 2,
      onTap: onTap,
    );
  }
}
