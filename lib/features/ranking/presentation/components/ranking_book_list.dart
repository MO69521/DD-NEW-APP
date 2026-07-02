import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import 'ranking_book_row.dart';

/// 右侧榜单书单：大封面书卡列表，行间分隔线。
class RankingBookList extends StatelessWidget {
  const RankingBookList({
    super.key,
    required this.books,
    this.bottomScrollPadding = 0,
    this.onBookTap,
  });

  final List<Book> books;
  final double bottomScrollPadding;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const EmptyState(title: '暂无榜单内容');
    }

    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final trailingPadding = bottomScrollPadding > 0
        ? bottomScrollPadding
        : AppSpacing.xl;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        top: AppSizes.rankingBookListTopPadding,
        right: AppSpacing.md,
        bottom: safeBottom + trailingPadding,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final row = RankingBookRow(
          book: books[index],
          onTap: onBookTap == null ? null : () => onBookTap!(books[index]),
        );
        if (index == 0) return row;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              height: AppSizes.hairline,
              thickness: AppSizes.hairline,
              color: AppColors.borderGlass,
            ),
            row,
          ],
        );
      },
    );
  }
}
