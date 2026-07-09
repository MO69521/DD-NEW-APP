import '../core/domain/entities/book.dart';

/// 书籍详情路由的 extra 载荷：携带书籍实体与是否已在书架，供详情页渲染真实封面。
class BookDetailRouteExtra {
  const BookDetailRouteExtra({required this.book, this.isInShelf = false});

  final Book book;
  final bool isInShelf;
}
