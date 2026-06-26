import 'package:equatable/equatable.dart';

import 'book_detail_domain_state.dart';
import 'book_detail_interaction_state.dart';
import 'book_detail_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class BookDetailState extends Equatable {
  const BookDetailState({
    this.ui = const BookDetailUiState(),
    this.domain = const BookDetailDomainState(),
    this.interaction = const BookDetailInteractionState(),
  });

  final BookDetailUiState ui;
  final BookDetailDomainState domain;
  final BookDetailInteractionState interaction;

  BookDetailState copyWith({
    BookDetailUiState? ui,
    BookDetailDomainState? domain,
    BookDetailInteractionState? interaction,
  }) {
    return BookDetailState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
