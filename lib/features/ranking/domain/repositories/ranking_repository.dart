import '../../../../core/domain/entities/book.dart';
import '../entities/ranking_channel.dart';
import '../entities/ranking_dimension.dart';
import '../entities/ranking_page_content.dart';

/// 榜单详情页仓储抽象（domain 契约）。
abstract interface class RankingRepository {
  Future<RankingPageContent> fetchPageContent();

  /// 加载指定维度、频道的更多书籍（分页）。
  Future<List<Book>> fetchMoreBooks({
    required RankingDimension dimension,
    required RankingChannel channel,
    required int page,
  });
}
