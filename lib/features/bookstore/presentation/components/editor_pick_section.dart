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
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    return BookGridSection(
      title: '编辑推荐',
      actionLabel: '更多',
      onActionTap: onMoreTap,
      books: books,
      crossAxisCount: 3,
      onBookTap: onBookTap,
    );
  }
}
