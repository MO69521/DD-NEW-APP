import 'package:equatable/equatable.dart';

import 'category_domain_state.dart';
import 'category_interaction_state.dart';
import 'category_ui_state.dart';

/// application 层聚合状态，不可变、可重建。
class CategoryState extends Equatable {
  const CategoryState({
    this.ui = const CategoryUiState(),
    this.domain = const CategoryDomainState(),
    this.interaction = const CategoryInteractionState(),
  });

  final CategoryUiState ui;
  final CategoryDomainState domain;
  final CategoryInteractionState interaction;

  CategoryState copyWith({
    CategoryUiState? ui,
    CategoryDomainState? domain,
    CategoryInteractionState? interaction,
  }) {
    return CategoryState(
      ui: ui ?? this.ui,
      domain: domain ?? this.domain,
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [ui, domain, interaction];
}
