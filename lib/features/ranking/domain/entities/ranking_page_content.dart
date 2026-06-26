import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'ranking_channel.dart';
import 'ranking_dimension.dart';

/// 榜单详情页聚合数据契约。
class RankingPageContent extends Equatable {
  const RankingPageContent({
    required this.brandTitle,
    required this.booksByDimensionChannel,
  });

  /// 品牌前缀，如「点点穿书」。
  final String brandTitle;

  /// 维度 -> 频道 -> 书单。
  final Map<RankingDimension, Map<RankingChannel, List<Book>>>
      booksByDimensionChannel;

  /// 取指定维度 + 频道书单，缺省回退到该维度「全部」。
  List<Book> booksFor(RankingDimension dimension, RankingChannel channel) {
    final byChannel = booksByDimensionChannel[dimension];
    if (byChannel == null) return const [];
    return byChannel[channel] ?? byChannel[RankingChannel.all] ?? const [];
  }

  @override
  List<Object?> get props => [brandTitle, booksByDimensionChannel];
}
