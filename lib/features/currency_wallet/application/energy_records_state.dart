import 'package:equatable/equatable.dart';

import '../domain/entities/energy_records_page_content.dart';

enum EnergyRecordsPhase { loading, loaded, empty }

enum EnergyRecordsTab { recharge, other }

class EnergyRecordsState extends Equatable {
  const EnergyRecordsState({
    this.phase = EnergyRecordsPhase.loading,
    this.selectedTab = EnergyRecordsTab.recharge,
    this.content,
    this.errorMessage,
  });

  final EnergyRecordsPhase phase;
  final EnergyRecordsTab selectedTab;
  final EnergyRecordsPageContent? content;
  final String? errorMessage;

  EnergyRecordsState copyWith({
    EnergyRecordsPhase? phase,
    EnergyRecordsTab? selectedTab,
    EnergyRecordsPageContent? content,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EnergyRecordsState(
      phase: phase ?? this.phase,
      selectedTab: selectedTab ?? this.selectedTab,
      content: content ?? this.content,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [phase, selectedTab, content, errorMessage];
}

extension EnergyRecordsTabLabel on EnergyRecordsTab {
  String get label {
    return switch (this) {
      EnergyRecordsTab.recharge => '能量充值',
      EnergyRecordsTab.other => '其他获取',
    };
  }
}
