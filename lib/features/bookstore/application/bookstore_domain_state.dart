import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import '../domain/entities/bookstore_page_content.dart';

/// 书城页领域状态。
class BookstoreDomainState extends Equatable {
  const BookstoreDomainState({this.content});

  final BookstorePageContent? content;

  String get searchPlaceholder => content?.searchPlaceholder ?? '';

  Map<RankingTab, List<Book>> get rankingBooksByTab =>
      content?.rankingBooksByTab ?? const {};

  List<Book> get editorPicks => content?.editorPicks ?? const [];

  List<Book> get guessLikeSeed => content?.guessLikeBooks ?? const [];

  BookstoreDomainState copyWith({BookstorePageContent? content}) {
    return BookstoreDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
