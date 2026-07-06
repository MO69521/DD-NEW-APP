import 'package:equatable/equatable.dart';

import 'login_ui_state.dart';

class LoginState extends Equatable {
  const LoginState({this.ui = const LoginUiState()});

  final LoginUiState ui;

  LoginState copyWith({LoginUiState? ui}) {
    return LoginState(ui: ui ?? this.ui);
  }

  @override
  List<Object?> get props => [ui];
}
