import 'package:equatable/equatable.dart';

import 'settings_ui_state.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.ui = const SettingsUiState(),
    this.domain = const SettingsDomainState(),
  });

  final SettingsUiState ui;
  final SettingsDomainState domain;

  SettingsState copyWith({SettingsUiState? ui, SettingsDomainState? domain}) {
    return SettingsState(ui: ui ?? this.ui, domain: domain ?? this.domain);
  }

  @override
  List<Object?> get props => [ui, domain];
}
