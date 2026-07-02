import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'bookshelf_domain_state.dart';
import 'bookshelf_interaction_state.dart';
import 'bookshelf_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class BookshelfState extends Equatable {
  const BookshelfState({
    this.ui = const BookshelfUiState(),
    this.domain = const BookshelfDomainState(),
    this.interaction = const BookshelfInteractionState(),
    this.recommendationBooks = const [],
  });

  final BookshelfUiState ui;
  final BookshelfDomainState domain;
  final BookshelfInteractionState interaction;
  final List<Book> recommendationBooks;

  BookshelfState copyWith({
    BookshelfUiState? ui,
    BookshelfDomainState? domain,
    BookshelfInteractionState? interaction,
    List<Book>? recommendationBooks,
  }) {
    return BookshelfState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
      recommendationBooks: recommendationBooks ?? this.recommendationBooks,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction, recommendationBooks];
}
