import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';
import '../../domain/entities/search_suggestion.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_data_source.dart';

/// data 层仓储实现，仅做数据获取与映射。
/// 依赖抽象 [SearchDataSource]：注入 Mock 或 Remote 均可，无需改动本类。
class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._dataSource);

  final SearchDataSource _dataSource;

  @override
  Future<List<SearchResultItem>> search(String query) =>
      _dataSource.search(query);

  @override
  Future<List<SearchSuggestion>> fetchSuggestions(String query) =>
      _dataSource.fetchSuggestions(query);

  @override
  Future<List<SearchRecommendationItem>> fetchRecommendations() =>
      _dataSource.fetchRecommendations();

  @override
  Future<List<String>> fetchHotKeywords() => _dataSource.fetchHotKeywords();

  @override
  Future<List<String>> fetchSearchHistory() => _dataSource.fetchSearchHistory();

  @override
  Future<List<String>> addSearchHistory(String keyword) =>
      _dataSource.addSearchHistory(keyword);

  @override
  Future<List<String>> clearSearchHistory() => _dataSource.clearSearchHistory();
}
