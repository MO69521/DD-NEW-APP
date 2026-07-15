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
    this.heroNamespace,
    this.titleContentGap = AppSpacing.lg,
  });

  final String title;
  final List<Book> books;
  final int crossAxisCount;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  /// 标题行与网格间距；卡内区块（如编辑推荐）传 `AppSpacing.md` 与榜单一致。
  final double titleContentGap;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  /// Hero 标签命名空间；非空时封面参与飞行，标签为 `book-cover-<ns>-<id>`。
  final String? heroNamespace;

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
        SizedBox(height: titleContentGap),
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
                    child: Builder(
                      builder: (context) {
                        final heroTag = heroNamespace == null
                            ? null
                            : 'book-cover-$heroNamespace-${book.id}';
                        return BookGridCard(
                          title: book.title,
                          category: book.category,
                          coverAsset: book.coverAsset,
                          coverTag: book.coverTag,
                          heroTag: heroTag,
                          onTap: onBookTap == null
                              ? null
                              : () => onBookTap!(book, heroTag ?? book.id),
                        );
                      },
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
