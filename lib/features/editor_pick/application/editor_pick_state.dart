import 'package:equatable/equatable.dart';

import 'editor_pick_domain_state.dart';
import 'editor_pick_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class EditorPickState extends Equatable {
  const EditorPickState({
    this.ui = const EditorPickUiState(),
    this.domain = const EditorPickDomainState(),
  });

  final EditorPickUiState ui;
  final EditorPickDomainState domain;

  EditorPickState copyWith({
    EditorPickUiState? ui,
    EditorPickDomainState? domain,
  }) {
    return EditorPickState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
    );
  }

  @override
  List<Object?> get props => [ui, domain];
}
