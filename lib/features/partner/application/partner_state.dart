import 'package:equatable/equatable.dart';

import 'partner_domain_state.dart';
import 'partner_interaction_state.dart';
import 'partner_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class PartnerState extends Equatable {
  const PartnerState({
    this.ui = const PartnerUiState(),
    this.domain = const PartnerDomainState(),
    this.interaction = const PartnerInteractionState(),
  });

  final PartnerUiState ui;
  final PartnerDomainState domain;
  final PartnerInteractionState interaction;

  PartnerState copyWith({
    PartnerUiState? ui,
    PartnerDomainState? domain,
    PartnerInteractionState? interaction,
  }) {
    return PartnerState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
