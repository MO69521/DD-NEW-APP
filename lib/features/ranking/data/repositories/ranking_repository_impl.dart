import '../../../../core/domain/entities/book.dart';
import '../../domain/entities/ranking_channel.dart';
import '../../domain/entities/ranking_dimension.dart';
import '../../domain/entities/ranking_page_content.dart';
import '../../domain/repositories/ranking_repository.dart';
import '../datasources/ranking_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
/// 依赖抽象 [RankingDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class RankingRepositoryImpl implements RankingRepository {
  const RankingRepositoryImpl(this._dataSource);

  final RankingDataSource _dataSource;

  @override
  Future<RankingPageContent> fetchPageContent() =>
      _dataSource.fetchPageContent();

  @override
  Future<List<Book>> fetchMoreBooks({
    required RankingDimension dimension,
    required RankingChannel channel,
    required int page,
  }) => _dataSource.fetchMoreBooks(
    dimension: dimension,
    channel: channel,
    page: page,
  );
}
