import 'package:equatable/equatable.dart';

import 'search_domain_state.dart';
import 'search_interaction_state.dart';
import 'search_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class SearchState extends Equatable {
  const SearchState({
    this.ui = const SearchUiState(),
    this.domain = const SearchDomainState(),
    this.interaction = const SearchInteractionState(),
  });

  final SearchUiState ui;
  final SearchDomainState domain;
  final SearchInteractionState interaction;

  SearchState copyWith({
    SearchUiState? ui,
    SearchDomainState? domain,
    SearchInteractionState? interaction,
  }) {
    return SearchState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
