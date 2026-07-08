import '../entities/search_recommendation_item.dart';
import '../entities/search_result_item.dart';
import '../entities/search_suggestion.dart';

/// 搜索仓储抽象（domain 契约）。
abstract interface class SearchRepository {
  Future<List<SearchResultItem>> search(String query);

  /// 输入实时联想词条。
  Future<List<SearchSuggestion>> fetchSuggestions(String query);

  /// 进入搜索页时的默认推送书单（布局与分类列表一致）。
  Future<List<SearchRecommendationItem>> fetchRecommendations();

  /// 热门搜索关键词（首项为置顶热词）。
  Future<List<String>> fetchHotKeywords();

  /// 本地搜索历史关键词（最近在前）。
  Future<List<String>> fetchSearchHistory();

  /// 记录一次搜索关键词，返回更新后的历史。
  Future<List<String>> addSearchHistory(String keyword);

  /// 清空搜索历史，返回空历史。
  Future<List<String>> clearSearchHistory();
}
