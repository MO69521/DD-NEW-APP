import '../entities/dress_up_page_content.dart';

/// 我的装扮数据契约。
abstract interface class DressUpRepository {
  Future<DressUpPageContent> fetchPageContent();
}
