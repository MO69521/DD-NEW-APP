import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import 'book_card_variants.dart';

/// Level 2 — 网格竖向书籍卡片（封面 + 标题 + 标签）。
class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverTag,
    this.onTap,
    this.heroTag,
  });

  final String title;
  final String category;
  final String coverAsset;
  final BookCoverTag? coverTag;
  final VoidCallback? onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return BookCardVertical(
      title: title,
      category: category,
      coverAsset: coverAsset,
      coverTag: coverTag,
      onTap: onTap,
      heroTag: heroTag,
    );
  }
}
