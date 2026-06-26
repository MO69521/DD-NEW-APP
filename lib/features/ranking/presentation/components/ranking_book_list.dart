import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import 'ranking_book_row.dart';

/// 右侧榜单书单（Figma 220:8549）：可滚动列表。
class RankingBookList extends StatelessWidget {
  const RankingBookList({
    super.key,
    required this.books,
    this.onBookTap,
  });

  final List<Book> books;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const EmptyState(title: '暂无榜单内容');
    }

    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        right: AppSpacing.md,
        bottom: bottomInset + AppSpacing.xl,
      ),
      itemCount: books.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final book = books[index];
        return RankingBookRow(
          book: book,
          onTap: onBookTap == null ? null : () => onBookTap!(book),
        );
      },
    );
  }
}
