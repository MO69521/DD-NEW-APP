import '../entities/welfare_page_content.dart';

/// 福利页数据仓储抽象。
abstract interface class WelfareRepository {
  Future<WelfarePageContent> fetchPageContent();
}
