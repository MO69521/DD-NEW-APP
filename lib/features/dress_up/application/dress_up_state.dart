import 'package:equatable/equatable.dart';

import '../domain/entities/dress_up_page_content.dart';
import '../domain/entities/dress_up_tab.dart';

enum DressUpPhase { loading, ready, error }

class DressUpState extends Equatable {
  const DressUpState({
    this.phase = DressUpPhase.loading,
    this.content,
    this.selectedTab = DressUpTab.homeBackground,
    this.selectedItemIds = const {},
    this.equippedItemIds = const {},
    this.errorMessage,
  });

  final DressUpPhase phase;
  final DressUpPageContent? content;
  final DressUpTab selectedTab;

  /// 各 Tab 当前高亮选中的装扮项 id。
  final Map<DressUpTab, String> selectedItemIds;

  /// 各 Tab 当前正在使用（已装扮）的装扮项 id。
  final Map<DressUpTab, String> equippedItemIds;

  final String? errorMessage;

  String? selectedItemId(DressUpTab tab) => selectedItemIds[tab];

  String? equippedItemId(DressUpTab tab) => equippedItemIds[tab];

  /// 当前 Tab 选中项是否即为正在使用的装扮项。
  bool isSelectedEquipped(DressUpTab tab) {
    final selected = selectedItemIds[tab];
    return selected != null && selected == equippedItemIds[tab];
  }

  DressUpState copyWith({
    DressUpPhase? phase,
    DressUpPageContent? content,
    DressUpTab? selectedTab,
    Map<DressUpTab, String>? selectedItemIds,
    Map<DressUpTab, String>? equippedItemIds,
    String? errorMessage,
  }) {
    return DressUpState(
      phase: phase ?? this.phase,
      content: content ?? this.content,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      equippedItemIds: equippedItemIds ?? this.equippedItemIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    content,
    selectedTab,
    selectedItemIds,
    equippedItemIds,
    errorMessage,
  ];
}
