import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';
import '../../domain/entities/search_suggestion.dart';

/// 搜索数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class SearchDataSource {
  Future<List<SearchResultItem>> search(String query);

  Future<List<SearchSuggestion>> fetchSuggestions(String query);

  Future<List<SearchRecommendationItem>> fetchRecommendations();

  Future<List<String>> fetchHotKeywords();

  Future<List<String>> fetchSearchHistory();

  Future<List<String>> addSearchHistory(String keyword);

  Future<List<String>> clearSearchHistory();
}
