import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../../../shared/components/book_card_large_row.dart';
import '../../domain/entities/search_recommendation_item.dart';

/// L3 — 搜索默认推荐行：映射到共享 [BookCardLargeRow]，布局与分类列表一致。
class SearchRecommendationRow extends StatelessWidget {
  const SearchRecommendationRow({super.key, required this.item, this.onTap});

  final SearchRecommendationItem item;
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
      padding: EdgeInsets.zero,
      heroTag: 'book-cover-${item.book.id}',
      onTap: onTap == null ? null : () => onTap!(item.book),
    );
  }
}
