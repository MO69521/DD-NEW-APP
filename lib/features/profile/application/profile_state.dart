import 'package:equatable/equatable.dart';

import 'profile_ui_state.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.ui = const ProfileUiState(),
    this.domain = const ProfileDomainState(),
  });

  final ProfileUiState ui;
  final ProfileDomainState domain;

  ProfileState copyWith({
    ProfileUiState? ui,
    ProfileDomainState? domain,
  }) {
    return ProfileState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
    );
  }

  @override
  List<Object?> get props => [ui, domain];
}
