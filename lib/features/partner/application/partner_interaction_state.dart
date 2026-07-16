import 'package:equatable/equatable.dart';

import '../domain/entities/partner_sort_mode.dart';
import '../domain/entities/partner_top_tab.dart';

/// 交互状态：顶栏 Tab、标签、排序、筛选、互动场景索引。
class PartnerInteractionState extends Equatable {
  const PartnerInteractionState({
    this.topTab = PartnerTopTab.explore,
    this.selectedCategoryIndex = 0,
    this.sortMode = PartnerSortMode.hot,
    this.selectedFilterIndex = 0,
    this.isFilterSheetOpen = false,
    this.interactionSceneIndex = 0,
  });

  final PartnerTopTab topTab;
  final int selectedCategoryIndex;
  final PartnerSortMode sortMode;
  final int selectedFilterIndex;
  final bool isFilterSheetOpen;
  final int interactionSceneIndex;

  PartnerInteractionState copyWith({
    PartnerTopTab? topTab,
    int? selectedCategoryIndex,
    PartnerSortMode? sortMode,
    int? selectedFilterIndex,
    bool? isFilterSheetOpen,
    int? interactionSceneIndex,
  }) {
    return PartnerInteractionState(
      topTab: topTab ?? this.topTab,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      sortMode: sortMode ?? this.sortMode,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      isFilterSheetOpen: isFilterSheetOpen ?? this.isFilterSheetOpen,
      interactionSceneIndex:
          interactionSceneIndex ?? this.interactionSceneIndex,
    );
  }

  @override
  List<Object?> get props => [
    topTab,
    selectedCategoryIndex,
    sortMode,
    selectedFilterIndex,
    isFilterSheetOpen,
    interactionSceneIndex,
  ];
}
