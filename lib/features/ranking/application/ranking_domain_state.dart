import 'package:equatable/equatable.dart';

import '../../../core/domain/entities/book.dart';
import '../domain/entities/ranking_channel.dart';
import '../domain/entities/ranking_dimension.dart';
import '../domain/entities/ranking_page_content.dart';

/// 榜单详情页领域状态。
class RankingDomainState extends Equatable {
  const RankingDomainState({this.content});

  final RankingPageContent? content;

  String get brandTitle => content?.brandTitle ?? '';

  List<Book> booksFor(RankingDimension dimension, RankingChannel channel) =>
      content?.booksFor(dimension, channel) ?? const [];

  RankingDomainState copyWith({RankingPageContent? content}) {
    return RankingDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
