import '../entities/bookshelf_page_content.dart';

/// 书架数据仓库抽象。
abstract class BookshelfRepository {
  Future<BookshelfPageContent> fetchPageContent();
}
