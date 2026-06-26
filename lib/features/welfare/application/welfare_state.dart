import 'package:equatable/equatable.dart';

import 'welfare_domain_state.dart';
import 'welfare_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class WelfareState extends Equatable {
  const WelfareState({
    this.ui = const WelfareUiState(),
    this.domain = const WelfareDomainState(),
  });

  final WelfareUiState ui;
  final WelfareDomainState domain;

  WelfareState copyWith({WelfareUiState? ui, WelfareDomainState? domain}) {
    return WelfareState(ui: ui ?? this.ui, domain: domain ?? this.domain);
  }

  @override
  List<Object?> get props => [ui, domain];
}
