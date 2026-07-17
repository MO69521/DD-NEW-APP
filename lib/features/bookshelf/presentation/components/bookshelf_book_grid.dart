import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/book_card_surface.dart';
import '../../../../shared/components/book_grid_card.dart';
import 'bookshelf_selectable_book_card.dart';

/// 书架书籍 3 列网格，卡片样式对齐书城编辑推荐。
class BookshelfBookGrid extends StatelessWidget {
  const BookshelfBookGrid({
    super.key,
    required this.books,
    this.onBookTap,
    this.isManaging = false,
  });

  final List<Book> books;
  final ValueChanged<Book>? onBookTap;
  final bool isManaging;

  static const int crossAxisCount = 3;

  static double itemHeightForWidth(double maxWidth) {
    const totalSpacing = AppSpacing.md * (crossAxisCount - 1);
    final itemWidth = (maxWidth - totalSpacing) / crossAxisCount;
    // 封面贴齐卡面左/上/右边，文字区保留左右与底部内边距。
    final coverHeight = itemWidth / AppSizes.bookCoverGridAspectRatio;
    return coverHeight +
        AppSizes.bookGridCoverToTextGap +
        AppSizes.bookGridTextBlockHeight +
        BookCardSurface.padding;
  }

  static Widget sliver({
    required List<Book> books,
    required double gridWidth,
    void Function(Book book, Object coverHeroTag)? onBookTap,
    String? heroNamespace,
    bool isManaging = false,
    Set<String> selectedBookIds = const {},
    ValueChanged<Book>? onBookSelectionToggle,
  }) {
    if (books.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final itemHeight = itemHeightForWidth(gridWidth);

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: itemHeight,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final book = books[index];
        if (isManaging) {
          return BookshelfSelectableBookCard(
            key: ValueKey(book.id),
            book: book,
            isManaging: isManaging,
            isSelected: selectedBookIds.contains(book.id),
            onTap: () => onBookSelectionToggle?.call(book),
          );
        }

        // 书架 / 阅读历史两个 Tab 同时挂载，同一本书可能同时出现，
        // 故按 Tab 命名空间隔离 Hero 标签，避免同 tag 冲突。
        final heroTag = heroNamespace == null
            ? 'book-cover-${book.id}'
            : 'book-cover-$heroNamespace-${book.id}';
        return BookGridCard(
          key: ValueKey(book.id),
          title: book.title,
          category: book.category,
          coverAsset: book.coverAsset,
          coverTag: book.coverTag,
          onTap: onBookTap == null ? null : () => onBookTap(book, heroTag),
          heroTag: heroTag,
          showCardBackground: true,
        );
      }, childCount: books.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemHeight = itemHeightForWidth(constraints.maxWidth);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            mainAxisExtent: itemHeight,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookGridCard(
              title: book.title,
              category: book.category,
              coverAsset: book.coverAsset,
              coverTag: book.coverTag,
              onTap: onBookTap == null ? null : () => onBookTap!(book),
              showCardBackground: true,
            );
          },
        );
      },
    );
  }
}
