import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'book_serialization_status.dart';

/// 搜索结果项（纯 Dart）。
///
/// 复用共享 [Book] 承载封面/标题/详情跳转，附加搜索结果专属展示字段，
/// 避免污染跨 feature 共享的 [Book] 契约。
class SearchResultItem extends Equatable {
  const SearchResultItem({
    required this.book,
    required this.audienceTags,
    required this.description,
    required this.status,
  });

  final Book book;

  /// 受众/分类标签，按设计以「/」拼接展示，如：女性向 / 未来 / 女尊 / 甜宠。
  final List<String> audienceTags;

  final String description;
  final BookSerializationStatus status;

  @override
  List<Object?> get props => [book, audienceTags, description, status];
}
