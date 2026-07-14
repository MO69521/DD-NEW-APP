import '../../../../core/network/api_client.dart';
import '../../domain/entities/search_recommendation_item.dart';
import '../../domain/entities/search_result_item.dart';
import '../../domain/entities/search_suggestion.dart';
import '../models/search_dtos.dart';
import 'search_data_source.dart';

/// 搜索真实接口数据源：调用 [ApiClient]，解析 `data` 信封为 DTO 再映射为领域模型。
/// 覆盖列表 / 联想 / 推荐 / 热词 / 历史增删查等多类响应，可作为多方法 feature 的范式。
class SearchRemoteDataSource implements SearchDataSource {
  const SearchRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<List<SearchResultItem>> search(String query) async {
    final json = await _client.getJson('/search', query: {'q': query});
    return SearchResultItemDto.listToEntities(json['data']);
  }

  @override
  Future<List<SearchSuggestion>> fetchSuggestions(String query) async {
    final json = await _client.getJson(
      '/search/suggestions',
      query: {'q': query},
    );
    return SearchSuggestionDto.listToEntities(json['data']);
  }

  @override
  Future<List<SearchRecommendationItem>> fetchRecommendations() async {
    final json = await _client.getJson('/search/recommendations');
    return SearchRecommendationItemDto.listToEntities(json['data']);
  }

  @override
  Future<List<String>> fetchHotKeywords() async {
    final json = await _client.getJson('/search/hot-keywords');
    return parseStringList(json['data']);
  }

  @override
  Future<List<String>> fetchSearchHistory() async {
    final json = await _client.getJson('/search/history');
    return parseStringList(json['data']);
  }

  @override
  Future<List<String>> addSearchHistory(String keyword) async {
    final json = await _client.postJson(
      '/search/history',
      body: {'keyword': keyword},
    );
    return parseStringList(json['data']);
  }

  @override
  Future<List<String>> clearSearchHistory() async {
    final json = await _client.postJson('/search/history/clear');
    return parseStringList(json['data']);
  }
}
