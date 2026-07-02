import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/book_grid_card.dart';
import '../../../../shared/components/section_header.dart';

/// L3 — 书籍详情页推荐书籍区块，复用首页网格书卡样式。
class BookDetailRecommendationSection extends StatelessWidget {
  const BookDetailRecommendationSection({
    super.key,
    required this.title,
    required this.books,
    this.actionLabel,
    this.actionIconAsset,
    this.onActionTap,
    this.onBookTap,
  });

  final String title;
  final List<Book> books;
  final String? actionLabel;
  final String? actionIconAsset;
  final VoidCallback? onActionTap;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionLabel: actionLabel,
          actionIconAsset: actionIconAsset ?? 'assets/icons/arrow_right.svg',
          onActionTap: onActionTap,
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 3;
            final totalSpacing = AppSpacing.md * (crossAxisCount - 1);
            final itemWidth =
                (constraints.maxWidth - totalSpacing) / crossAxisCount;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final book in books)
                  SizedBox(
                    width: itemWidth,
                    child: BookGridCard(
                      title: book.title,
                      category: book.category,
                      coverAsset: book.coverAsset,
                      coverTag: book.coverTag,
                      onTap: onBookTap == null ? null : () => onBookTap!(book),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
