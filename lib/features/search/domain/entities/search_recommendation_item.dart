import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 搜索页默认推荐项（纯 Dart）。
///
/// 复用共享 [Book] 承载封面/标题/详情跳转，展示字段与分类列表一致。
class SearchRecommendationItem extends Equatable {
  const SearchRecommendationItem({
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
