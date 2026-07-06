import 'package:equatable/equatable.dart';

import '../domain/entities/settings_page_content.dart';

class SettingsUiState extends Equatable {
  const SettingsUiState({
    this.isLoading = false,
    this.isLoggingOut = false,
    this.errorMessage,
    this.actionMessage,
  });

  final bool isLoading;
  final bool isLoggingOut;
  final String? errorMessage;
  final String? actionMessage;

  SettingsUiState copyWith({
    bool? isLoading,
    bool? isLoggingOut,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearActionMessage = false,
  }) {
    return SettingsUiState(
      isLoading: isLoading ?? this.isLoading,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionMessage: clearActionMessage
          ? null
          : actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoggingOut,
    errorMessage,
    actionMessage,
  ];
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
