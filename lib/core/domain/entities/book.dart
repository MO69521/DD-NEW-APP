import 'package:equatable/equatable.dart';

import 'book_cover_tag.dart';
import 'book_cover_bottom_badge.dart';

/// 跨 feature 共享的书籍领域实体（纯 Dart）。
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.category,
    required this.coverAsset,
    this.summary,
    this.annotations = const [],
    this.coverTag,
    this.coverBottomBadge,
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

  /// 封面右上角状态角标（更新 / 完结），后端返回；为空则不展示。
  final BookCoverTag? coverTag;

  /// 封面右下角运营标签（热度或红色活动文案），由后端返回。
  final BookCoverBottomBadge? coverBottomBadge;

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    coverAsset,
    summary,
    annotations,
    coverTag,
    coverBottomBadge,
  ];
}

enum RankingTab {
  recommend,
  popular,
  rising,
  completed,
  following,
  potential,
  interaction;

  String get label => switch (this) {
    RankingTab.recommend => '推荐榜',
    RankingTab.popular => '人气榜',
    RankingTab.rising => '飙升榜',
    RankingTab.completed => '完结榜',
    RankingTab.following => '追更榜',
    RankingTab.potential => '潜力榜',
    RankingTab.interaction => '互动榜',
  };
}
