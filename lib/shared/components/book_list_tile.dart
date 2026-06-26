import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';
import 'book_card_variants.dart';

/// Level 2 — 榜单紧凑横向书项（旧版 [BookCardHorizontal] 封装，保留供回滚）。
class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverWidth = AppSizes.bookCoverListWidth,
    this.coverHeight = AppSizes.bookCoverListHeight,
    this.onTap,
  });

  final String title;
  final String category;
  final String coverAsset;
  final double coverWidth;
  final double coverHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BookCardHorizontal(
      title: title,
      category: category,
      coverAsset: coverAsset,
      coverWidth: coverWidth,
      coverHeight: coverHeight,
      onTap: onTap,
    );
  }
}
