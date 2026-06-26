import '../entities/bookstore_page_content.dart';

/// 书城数据仓储抽象。
abstract interface class BookstoreRepository {
  Future<BookstorePageContent> fetchPageContent();
}
