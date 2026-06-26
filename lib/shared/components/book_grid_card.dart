import 'package:flutter/material.dart';

import 'book_card_variants.dart';

/// Level 2 — 网格竖向书籍卡片（封面 + 标题 + 标签）。
class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.onTap,
  });

  final String title;
  final String category;
  final String coverAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardVertical(
      title: title,
      category: category,
      coverAsset: coverAsset,
      onTap: onTap,
    );
  }
}
