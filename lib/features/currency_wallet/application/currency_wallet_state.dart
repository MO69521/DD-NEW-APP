import 'package:equatable/equatable.dart';

import 'currency_wallet_domain_state.dart';
import 'currency_wallet_interaction_state.dart';
import 'currency_wallet_ui_state.dart';

class CurrencyWalletState extends Equatable {
  const CurrencyWalletState({
    this.ui = const CurrencyWalletUiState(),
    this.domain = const CurrencyWalletDomainState(),
    this.interaction = const CurrencyWalletInteractionState(),
  });

  final CurrencyWalletUiState ui;
  final CurrencyWalletDomainState domain;
  final CurrencyWalletInteractionState interaction;

  CurrencyWalletState copyWith({
    CurrencyWalletUiState? ui,
    CurrencyWalletDomainState? domain,
    CurrencyWalletInteractionState? interaction,
  }) {
    return CurrencyWalletState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
