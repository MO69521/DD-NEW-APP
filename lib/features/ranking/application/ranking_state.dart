import 'package:equatable/equatable.dart';

import 'ranking_domain_state.dart';
import 'ranking_interaction_state.dart';
import 'ranking_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class RankingState extends Equatable {
  const RankingState({
    this.ui = const RankingUiState(),
    this.domain = const RankingDomainState(),
    this.interaction = const RankingInteractionState(),
  });

  final RankingUiState ui;
  final RankingDomainState domain;
  final RankingInteractionState interaction;

  RankingState copyWith({
    RankingUiState? ui,
    RankingDomainState? domain,
    RankingInteractionState? interaction,
  }) {
    return RankingState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
