import '../entities/search_result_item.dart';

/// 搜索仓储抽象（domain 契约）。
abstract interface class SearchRepository {
  Future<List<SearchResultItem>> search(String query);
}
