import '../entities/ranking_page_content.dart';

/// 榜单详情页仓储抽象（domain 契约）。
abstract interface class RankingRepository {
  Future<RankingPageContent> fetchPageContent();
}
