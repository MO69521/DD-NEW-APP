import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_theme_assets.dart';
import '../../../../shared/components/book_card_large_row.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../domain/entities/book_serialization_status.dart';
import '../../domain/entities/search_result_item.dart';

/// L3 — 搜索结果行：映射到共享 [BookCardLargeRow]。
class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    super.key,
    required this.item,
    this.isInShelf = false,
    this.onTap,
    this.onAddToShelf,
  });

  final SearchResultItem item;
  final bool isInShelf;
  final void Function(Book book)? onTap;
  final void Function(Book book)? onAddToShelf;

  BookCoverTag _coverTagFor(BookSerializationStatus status) => switch (status) {
    BookSerializationStatus.serializing => BookCoverTag.serializing,
    BookSerializationStatus.completed => BookCoverTag.completed,
  };

  @override
  Widget build(BuildContext context) {
    return BookCardLargeRow(
      coverAsset: item.book.coverAsset,
      title: item.book.title,
      meta: item.audienceTags.join(' / '),
      description: item.description,
      coverTag: _coverTagFor(item.status),
      coverBottomBadge: item.book.coverBottomBadge,
      heroTag: 'book-cover-${item.book.id}',
      trailing: _AddToShelfButton(
        isInShelf: isInShelf,
        onTap: onAddToShelf == null ? null : () => onAddToShelf!(item.book),
      ),
      padding: EdgeInsets.zero,
      onTap: onTap == null ? null : () => onTap!(item.book),
    );
  }
}

class _AddToShelfButton extends StatelessWidget {
  const _AddToShelfButton({this.isInShelf = false, this.onTap});

  final bool isInShelf;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: AppIcon(
        // 主题完整色稿（AppThemeAssets），不再运行时染色。
        assetPath: isInShelf
            ? AppThemeAssets.bookDetailInShelf
            : AppThemeAssets.bookDetailAddToShelf,
        width: AppSizes.bookCardLargeTrailingIconSize,
        height: AppSizes.bookCardLargeTrailingIconSize,
      ),
    );
  }
}
