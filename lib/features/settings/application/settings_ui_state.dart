import 'package:equatable/equatable.dart';

import '../domain/entities/settings_page_content.dart';

class SettingsUiState extends Equatable {
  const SettingsUiState({
    this.isLoading = false,
    this.errorMessage,
    this.actionMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? actionMessage;

  SettingsUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearActionMessage = false,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, actionMessage];
}

class SettingsDomainState extends Equatable {
  const SettingsDomainState({this.content});

  final SettingsPageContent? content;

  SettingsDomainState copyWith({SettingsPageContent? content}) {
    return SettingsDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
