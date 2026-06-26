import '../entities/book_detail.dart';

/// 书籍详情页仓储抽象（domain 契约）。
abstract interface class BookDetailRepository {
  Future<BookDetail> fetchDetail(String bookId);
}
