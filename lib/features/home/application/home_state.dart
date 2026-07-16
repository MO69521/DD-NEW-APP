import 'package:equatable/equatable.dart';

import 'home_domain_state.dart';
import 'home_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class HomeState extends Equatable {
  const HomeState({
    this.ui = const HomeUiState(),
    this.domain = const HomeDomainState(),
  });

  final HomeUiState ui;
  final HomeDomainState domain;

  HomeState copyWith({HomeUiState? ui, HomeDomainState? domain}) {
    return HomeState(ui: ui ?? this.ui, domain: domain ?? this.domain);
  }

  @override
  List<Object?> get props => [ui, domain];
}
