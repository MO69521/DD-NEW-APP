import 'package:equatable/equatable.dart';

import '../../../../core/domain/entities/book.dart';
import 'bookstore_domain_state.dart';
import 'bookstore_interaction_state.dart';
import 'bookstore_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class BookstoreState extends Equatable {
  const BookstoreState({
    this.ui = const BookstoreUiState(),
    this.domain = const BookstoreDomainState(),
    this.interaction = const BookstoreInteractionState(),
    this.guessLikeBooks = const [],
  });

  final BookstoreUiState ui;
  final BookstoreDomainState domain;
  final BookstoreInteractionState interaction;
  final List<Book> guessLikeBooks;

  BookstoreState copyWith({
    BookstoreUiState? ui,
    BookstoreDomainState? domain,
    BookstoreInteractionState? interaction,
    List<Book>? guessLikeBooks,
  }) {
    return BookstoreState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
      guessLikeBooks: guessLikeBooks ?? this.guessLikeBooks,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction, guessLikeBooks];
}
