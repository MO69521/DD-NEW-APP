import 'dart:async';

import '../domain/entities/book.dart';

/// 应用级书架状态服务：统一维护本会话内已加入书架的书籍。
class BookshelfMembershipService {
  final Map<String, Book> _booksById = {};
  final StreamController<List<Book>> _booksController =
      StreamController<List<Book>>.broadcast(sync: true);
  bool _hasInitialSnapshot = false;

  List<Book> get books => List.unmodifiable(_booksById.values);
  Stream<List<Book>> get booksStream => _booksController.stream;

  bool contains(String bookId) => _booksById.containsKey(bookId);

  void initializeIfNeeded(Iterable<Book> books) {
    if (_hasInitialSnapshot) return;
    _hasInitialSnapshot = true;
    _booksById
      ..clear()
      ..addEntries(books.map((book) => MapEntry(book.id, book)));
    _notify();
  }

  void add(Book book) {
    _booksById[book.id] = book;
    _notify();
  }

  void remove(String bookId) {
    if (_booksById.remove(bookId) == null) return;
    _notify();
  }

  void removeAll(Iterable<String> bookIds) {
    var changed = false;
    for (final bookId in bookIds) {
      changed = _booksById.remove(bookId) != null || changed;
    }
    if (changed) _notify();
  }

  void _notify() {
    _booksController.add(books);
  }
}
