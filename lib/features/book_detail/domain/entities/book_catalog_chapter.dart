import 'package:equatable/equatable.dart';

/// 目录章节项。
class BookCatalogChapter extends Equatable {
  const BookCatalogChapter({
    required this.id,
    required this.title,
    this.isLocked = false,
  });

  final String id;

  /// 展示就绪标题，如「第一章 收割天命之子」。
  final String title;
  final bool isLocked;

  @override
  List<Object?> get props => [id, title, isLocked];
}
