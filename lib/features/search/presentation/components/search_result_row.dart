import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/components/book_card_search_result.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../domain/entities/search_result_item.dart';
import 'book_status_badge.dart';

/// L3 — 搜索结果行：把 [SearchResultItem] 映射到共享布局
/// [BookCardSearchResult]，注入状态角标与加入书架操作（feature 业务）。
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

  @override
  Widget build(BuildContext context) {
    return BookCardSearchResult(
      coverAsset: item.book.coverAsset,
      title: item.book.title,
      meta: item.audienceTags.join(' / '),
      description: item.description,
      leadingBadge: BookStatusBadge(status: item.status),
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
        width: AppSizes.searchResultAddIconSize,
        height: AppSizes.searchResultAddIconSize,
        color: AppColors.textOnDarkPlaceholder,
      ),
    );
  }
}
