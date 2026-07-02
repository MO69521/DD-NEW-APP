import '../entities/search_recommendation_item.dart';
import '../entities/search_result_item.dart';

/// 搜索仓储抽象（domain 契约）。
abstract interface class SearchRepository {
  Future<List<SearchResultItem>> search(String query);

  /// 进入搜索页时的默认推送书单（布局与分类列表一致）。
  Future<List<SearchRecommendationItem>> fetchRecommendations();
}
