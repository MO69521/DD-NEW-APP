import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/energy_records_mock_datasource.dart';
import '../data/repositories/energy_records_repository_impl.dart';
import '../domain/repositories/energy_records_repository.dart';
import 'energy_records_state.dart';

class EnergyRecordsCubit extends Cubit<EnergyRecordsState> {
  EnergyRecordsCubit({EnergyRecordsRepository? repository})
    : _repository =
          repository ??
          const EnergyRecordsRepositoryImpl(EnergyRecordsMockDataSource()),
      super(const EnergyRecordsState());

  final EnergyRecordsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(phase: EnergyRecordsPhase.loading, clearError: true));

    try {
      final content = await _repository.fetchPageContent();
      emit(state.copyWith(phase: EnergyRecordsPhase.loaded, content: content));
    } catch (error) {
      emit(
        state.copyWith(
          phase: EnergyRecordsPhase.empty,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void selectTab(EnergyRecordsTab tab) {
    emit(state.copyWith(selectedTab: tab));
  }
}
