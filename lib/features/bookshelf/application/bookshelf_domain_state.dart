import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import '../domain/entities/bookshelf_page_content.dart';
import '../domain/entities/bookshelf_tab.dart';

/// 领域状态：书架页内容。
class BookshelfDomainState extends Equatable {
  const BookshelfDomainState({this.content});

  final BookshelfPageContent? content;

  int get todayReadingMinutes => content?.todayReadingMinutes ?? 0;

  List<Book> bookSeedFor(BookshelfTab tab) =>
      content?.booksFor(tab) ?? const [];

  List<Book> get recommendationSeed => content?.recommendationBooks ?? const [];

  BookshelfDomainState copyWith({BookshelfPageContent? content}) {
    return BookshelfDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
