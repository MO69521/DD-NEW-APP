import '../entities/category_page_content.dart';

/// 分类页仓储抽象（domain 契约）。
abstract interface class CategoryRepository {
  Future<CategoryPageContent> fetchPageContent();
}
