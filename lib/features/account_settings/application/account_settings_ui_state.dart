import 'package:equatable/equatable.dart';

import '../domain/entities/account_settings_page_content.dart';

class AccountSettingsUiState extends Equatable {
  const AccountSettingsUiState({
    this.isLoading = false,
    this.errorMessage,
    this.actionMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? actionMessage;

  AccountSettingsUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? actionMessage,
    bool clearError = false,
    bool clearActionMessage = false,
  }) {
    return AccountSettingsUiState(
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

class AccountSettingsDomainState extends Equatable {
  const AccountSettingsDomainState({this.content});

  final AccountSettingsPageContent? content;

  AccountSettingsDomainState copyWith({AccountSettingsPageContent? content}) {
    return AccountSettingsDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
