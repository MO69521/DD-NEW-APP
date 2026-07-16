import 'package:equatable/equatable.dart';

import '../domain/entities/profile_page_content.dart';

class ProfileUiState extends Equatable {
  const ProfileUiState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  ProfileUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

class ProfileDomainState extends Equatable {
  const ProfileDomainState({this.content});

  final ProfilePageContent? content;

  ProfileDomainState copyWith({ProfilePageContent? content}) {
    return ProfileDomainState(content: content ?? this.content);
  }

  @override
  List<Object?> get props => [content];
}
