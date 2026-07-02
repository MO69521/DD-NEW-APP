import 'package:equatable/equatable.dart';

import 'account_settings_ui_state.dart';

class AccountSettingsState extends Equatable {
  const AccountSettingsState({
    this.ui = const AccountSettingsUiState(),
    this.domain = const AccountSettingsDomainState(),
  });

  final AccountSettingsUiState ui;
  final AccountSettingsDomainState domain;

  AccountSettingsState copyWith({
    AccountSettingsUiState? ui,
    AccountSettingsDomainState? domain,
  }) {
    return AccountSettingsState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
    );
  }

  @override
  List<Object?> get props => [ui, domain];
}
