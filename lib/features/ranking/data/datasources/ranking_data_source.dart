import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../domain/entities/ranking_dimension.dart';
import '../../domain/entities/ranking_page_content.dart';

/// 榜单数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class RankingDataSource {
  Future<RankingPageContent> fetchPageContent();

  Future<List<Book>> fetchMoreBooks({
    required RankingDimension dimension,
    required RankingChannel channel,
    required int page,
  });
}
