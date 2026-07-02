import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 编辑推荐详情页书籍项（纯 Dart）。
class EditorPickBookItem extends Equatable {
  const EditorPickBookItem({
    required this.book,
    required this.badgeLabel,
    required this.tags,
    required this.description,
    required this.author,
  });

  final Book book;

  /// 封面角标文案（如「更新」「完结」）。
  final String badgeLabel;

  /// 标签，按设计以「·」拼接展示。
  final List<String> tags;

  final String description;
  final String author;

  @override
  List<Object?> get props => [book, badgeLabel, tags, description, author];
}
