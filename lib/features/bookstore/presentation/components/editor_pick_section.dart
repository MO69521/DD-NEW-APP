import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import 'book_grid_section.dart';

/// 编辑推荐区块：3 列网格。
class EditorPickSection extends StatelessWidget {
  const EditorPickSection({
    super.key,
    required this.books,
    this.onMoreTap,
    this.onBookTap,
  });

  final List<Book> books;
  final VoidCallback? onMoreTap;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  @override
  Widget build(BuildContext context) {
    return BookGridSection(
      title: '编辑推荐',
      actionLabel: '更多',
      onActionTap: onMoreTap,
      books: books,
      crossAxisCount: 3,
      heroNamespace: 'editorpick',
      onBookTap: onBookTap,
    );
  }
}
