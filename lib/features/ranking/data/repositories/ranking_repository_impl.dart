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
}
