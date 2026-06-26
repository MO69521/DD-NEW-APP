import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';

/// 书城页聚合数据契约。
class BookstorePageContent extends Equatable {
  const BookstorePageContent({
    required this.searchPlaceholder,
    required this.rankingBooksByTab,
    required this.editorPicks,
    required this.guessLikeBooks,
  });

  final String searchPlaceholder;
  final Map<RankingTab, List<Book>> rankingBooksByTab;
  final List<Book> editorPicks;
  final List<Book> guessLikeBooks;

  @override
  List<Object?> get props => [
    searchPlaceholder,
    rankingBooksByTab,
    editorPicks,
    guessLikeBooks,
  ];
}
