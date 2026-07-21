import 'package:flutter/material.dart';

import '../../core/domain/entities/book_cover_tag.dart';
import '../../core/domain/entities/book_cover_bottom_badge.dart';
import 'book_card_variants.dart';

/// Level 2 — 网格竖向书籍卡片（封面 + 标题 + 标签）。
class BookGridCard extends StatelessWidget {
  const BookGridCard({
    super.key,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.coverTag,
    this.coverBottomBadge,
    this.onTap,
    this.heroTag,
    this.showCardBackground = false,
  });

  final String title;
  final String category;
  final String coverAsset;
  final BookCoverTag? coverTag;
  final BookCoverBottomBadge? coverBottomBadge;
  final VoidCallback? onTap;
  final Object? heroTag;

  /// 透传给 [BookCardVertical]：是否为整张卡片铺卡面底（默认关闭）。
  final bool showCardBackground;

  @override
  Widget build(BuildContext context) {
    return BookCardVertical(
      title: title,
      category: category,
      coverAsset: coverAsset,
      coverTag: coverTag,
      coverBottomBadge: coverBottomBadge,
      onTap: onTap,
      heroTag: heroTag,
      showCardBackground: showCardBackground,
    );
  }
}
