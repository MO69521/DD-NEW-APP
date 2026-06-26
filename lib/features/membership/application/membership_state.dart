import 'package:equatable/equatable.dart';

import 'membership_domain_state.dart';
import 'membership_interaction_state.dart';
import 'membership_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class MembershipState extends Equatable {
  const MembershipState({
    this.ui = const MembershipUiState(),
    this.domain = const MembershipDomainState(),
    this.interaction = const MembershipInteractionState(),
  });

  final MembershipUiState ui;
  final MembershipDomainState domain;
  final MembershipInteractionState interaction;

  MembershipState copyWith({
    MembershipUiState? ui,
    MembershipDomainState? domain,
    MembershipInteractionState? interaction,
  }) {
    return MembershipState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
