import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/book_list_tile.dart';
import '../../../../core/domain/entities/book.dart';

/// 榜单宫格书单（2 列 × 3 行，左图右文），最多展示 6 本。
class RankingBookGrid extends StatelessWidget {
  const RankingBookGrid({super.key, required this.books, this.onBookTap});

  final List<Book> books;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    final visibleBooks = books.take(AppSizes.rankingGridMaxItems).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 2;
        final coverWidth = AppSizes.rankingRowCoverWidth;
        // 保持封面纵横比，放大宽度时自动同步高度。
        final coverHeight = coverWidth / AppSizes.bookCoverRankingAspectRatio;
        final itemHeight = coverHeight;

        return GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: itemHeight,
          ),
          itemCount: visibleBooks.length,
          itemBuilder: (context, index) {
            final book = visibleBooks[index];
            return BookListTile(
              title: book.title,
              category: book.category,
              coverAsset: book.coverAsset,
              coverWidth: coverWidth,
              coverHeight: coverHeight,
              onTap: onBookTap == null ? null : () => onBookTap!(book),
            );
          },
        );
      },
    );
  }
}
