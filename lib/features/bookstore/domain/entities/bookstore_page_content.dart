import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 书城页聚合数据契约。
class BookstorePageContent extends Equatable {
  const BookstorePageContent({
    required this.searchPlaceholder,
    required this.rankingBooksByTab,
    required this.editorPicks,
    required this.guessLikeBooks,
    this.continueReadingBook,
  });

  final String searchPlaceholder;
  final Map<RankingTab, List<Book>> rankingBooksByTab;
  final List<Book> editorPicks;
  final List<Book> guessLikeBooks;

  /// 最近在读书籍；为空表示无「继续阅读」入口。
  final Book? continueReadingBook;

  @override
  List<Object?> get props => [
    searchPlaceholder,
    rankingBooksByTab,
    editorPicks,
    guessLikeBooks,
    continueReadingBook,
  ];
}
