import 'package:equatable/equatable.dart';

/// 跨 feature 共享的书籍领域实体（纯 Dart）。
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.summary,
    this.annotations = const [],
  });

  final String id;
  final String title;
  final String category;

  /// TODO(real-data): 当前字段指向本地 mock 封面资源。
  /// 接真实接口时可改为 `coverUrl`，或新增封面 value object 区分 asset / network。
  final String coverAsset;

  /// 书籍摘要（用于「猜你喜欢」卡片详情文案）。
  final String? summary;

  /// 卡片注释标签（用于「猜你喜欢」下方标签胶囊，如纯爱/升级流）。
  final List<String> annotations;

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    coverAsset,
    summary,
    annotations,
  ];
}

enum RankingTab {
  recommend,
  popular,
  rising,
  completed;

  String get label => switch (this) {
    RankingTab.recommend => '推荐榜',
    RankingTab.popular => '人气榜',
    RankingTab.rising => '飙升榜',
    RankingTab.completed => '完结榜',
  };
}
