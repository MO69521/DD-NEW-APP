import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/domain/entities/book_cover_tag.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/components/book_card_large_row.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../domain/entities/book_serialization_status.dart';
import '../../domain/entities/search_result_item.dart';

/// L3 — 搜索结果行：映射到共享 [BookCardLargeRow]。
class SearchResultRow extends StatelessWidget {
  const SearchResultRow({
    super.key,
    required this.item,
    this.onTap,
    this.onAddToShelf,
  });

  final SearchResultItem item;
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
      trailing: _AddToShelfButton(
        onTap: onAddToShelf == null ? null : () => onAddToShelf!(item.book),
      ),
      onTap: onTap == null ? null : () => onTap!(item.book),
    );
  }
}

class _AddToShelfButton extends StatelessWidget {
  const _AddToShelfButton({this.onTap});

  final VoidCallback? onTap;

  static const String _addIconAsset = 'assets/icons/search/add_to_shelf.svg';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const AppIcon(
        assetPath: _addIconAsset,
        width: AppSizes.bookCardLargeTrailingIconSize,
        height: AppSizes.bookCardLargeTrailingIconSize,
        color: AppColors.textOnDarkPlaceholder,
      ),
    );
  }
}
