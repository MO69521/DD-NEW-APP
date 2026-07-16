import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/dress_up_mock_datasource.dart';
import '../data/repositories/dress_up_repository_impl.dart';
import '../domain/entities/dress_up_tab.dart';
import '../domain/repositories/dress_up_repository.dart';
import 'dress_up_state.dart';

class DressUpCubit extends Cubit<DressUpState> {
  DressUpCubit({DressUpRepository? repository})
    : _repository =
          repository ?? const DressUpRepositoryImpl(DressUpMockDataSource()),
      super(const DressUpState());

  final DressUpRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(phase: DressUpPhase.loading));
    try {
      final content = await _repository.fetchPageContent();
      final equipped = <DressUpTab, String>{};
      for (final tab in DressUpTab.values) {
        final items = content.itemsFor(tab);
        if (items.isEmpty) continue;
        final equippedItem = items.firstWhere(
          (item) => item.isEquipped,
          orElse: () => items.first,
        );
        equipped[tab] = equippedItem.id;
      }
      emit(
        state.copyWith(
          phase: DressUpPhase.ready,
          content: content,
          selectedItemIds: Map<DressUpTab, String>.from(equipped),
          equippedItemIds: equipped,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          phase: DressUpPhase.error,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void selectTab(DressUpTab tab) {
    if (tab == state.selectedTab) return;
    emit(state.copyWith(selectedTab: tab));
  }

  void selectItem(DressUpTab tab, String itemId) {
    if (state.selectedItemIds[tab] == itemId) return;
    final updated = Map<DressUpTab, String>.from(state.selectedItemIds)
      ..[tab] = itemId;
    emit(state.copyWith(selectedItemIds: updated));
  }

  void equipSelected(DressUpTab tab) {
    final selectedId = state.selectedItemIds[tab];
    if (selectedId == null || state.equippedItemIds[tab] == selectedId) return;
    final updated = Map<DressUpTab, String>.from(state.equippedItemIds)
      ..[tab] = selectedId;
    emit(state.copyWith(equippedItemIds: updated));
  }
}
