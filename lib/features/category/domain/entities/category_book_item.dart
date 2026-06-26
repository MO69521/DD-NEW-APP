import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 分类页书籍结果项（纯 Dart）。
///
/// 复用共享 [Book] 承载封面/标题/详情跳转，附加分类页展示字段。
class CategoryBookItem extends Equatable {
  const CategoryBookItem({
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
