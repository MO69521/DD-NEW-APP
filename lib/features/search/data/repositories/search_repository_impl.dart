import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_mock_datasource.dart';

/// data 层仓储实现，仅做数据获取与映射。
class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource);

  final SearchMockDataSource _dataSource;

  @override
  Future<List<SearchResultItem>> search(String query) =>
      _dataSource.search(query);

  @override
  Future<List<SearchRecommendationItem>> fetchRecommendations() =>
      _dataSource.fetchRecommendations();
}
