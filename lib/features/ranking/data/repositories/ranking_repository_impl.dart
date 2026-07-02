import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../domain/entities/ranking_dimension.dart';
import '../../domain/entities/ranking_page_content.dart';
import '../../domain/repositories/ranking_repository.dart';
import '../datasources/ranking_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class RankingRepositoryImpl implements RankingRepository {
  const RankingRepositoryImpl(this._dataSource);

  final RankingMockDataSource _dataSource;

  @override
  Future<RankingPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();

  @override
  Future<List<Book>> fetchMoreBooks({
    required RankingDimension dimension,
    required RankingChannel channel,
    required int page,
  }) =>
      _dataSource.fetchMoreBooks(
        dimension: dimension,
        channel: channel,
        page: page,
      );
}
