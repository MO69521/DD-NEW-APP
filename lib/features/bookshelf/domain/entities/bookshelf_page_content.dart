import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'bookshelf_tab.dart';

/// 书架页领域内容：今日阅读时长 + 两套书单。
class BookshelfPageContent extends Equatable {
  const BookshelfPageContent({
    required this.todayReadingMinutes,
    required this.booksByTab,
    required this.recommendationBooks,
  });

  final int todayReadingMinutes;
  final Map<BookshelfTab, List<Book>> booksByTab;
  final List<Book> recommendationBooks;

  List<Book> booksFor(BookshelfTab tab) => booksByTab[tab] ?? const <Book>[];

  BookshelfPageContent copyWith({
    int? todayReadingMinutes,
    Map<BookshelfTab, List<Book>>? booksByTab,
    List<Book>? recommendationBooks,
  }) {
    return BookshelfPageContent(
      todayReadingMinutes: todayReadingMinutes ?? this.todayReadingMinutes,
      booksByTab: booksByTab ?? this.booksByTab,
      recommendationBooks: recommendationBooks ?? this.recommendationBooks,
    );
  }

  @override
  List<Object?> get props => [
    todayReadingMinutes,
    booksByTab,
    recommendationBooks,
  ];
}
