import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/book_grid_card.dart';
import '../../../../shared/components/section_header.dart';
import '../../../../core/domain/entities/book.dart';

/// 书籍网格区块（标题 + 可选右侧动作 + 网格）。
class BookGridSection extends StatelessWidget {
  const BookGridSection({
    super.key,
    required this.title,
    required this.books,
    required this.crossAxisCount,
    this.actionLabel,
    this.onActionTap,
    this.onBookTap,
  });

  final String title;
  final List<Book> books;
  final int crossAxisCount;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionLabel: actionLabel,
          onActionTap: onActionTap,
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
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
                      onTap:
                          onBookTap == null ? null : () => onBookTap!(book),
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
