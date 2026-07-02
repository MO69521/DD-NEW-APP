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

  /// 追加更多书籍到指定维度和频道。
  RankingPageContent appendBooks(
    RankingDimension dimension,
    RankingChannel channel,
    List<Book> newBooks,
  ) {
    final updated = Map<RankingDimension, Map<RankingChannel, List<Book>>>.from(
      booksByDimensionChannel,
    );

    final channelMap = Map<RankingChannel, List<Book>>.from(
      updated[dimension] ?? {},
    );

    final existingBooks = channelMap[channel] ?? [];
    channelMap[channel] = [...existingBooks, ...newBooks];

    updated[dimension] = channelMap;

    return RankingPageContent(
      brandTitle: brandTitle,
      booksByDimensionChannel: updated,
    );
  }

  @override
  List<Object?> get props => [brandTitle, booksByDimensionChannel];
}
