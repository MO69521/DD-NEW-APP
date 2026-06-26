import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'bookshelf_tab.dart';

/// 书架页领域内容：今日阅读时长 + 两套书单。
class BookshelfPageContent extends Equatable {
  const BookshelfPageContent({
    required this.todayReadingMinutes,
    required this.booksByTab,
  });

  final int todayReadingMinutes;
  final Map<BookshelfTab, List<Book>> booksByTab;

  List<Book> booksFor(BookshelfTab tab) =>
      booksByTab[tab] ?? const <Book>[];

  @override
  List<Object?> get props => [todayReadingMinutes, booksByTab];
}
