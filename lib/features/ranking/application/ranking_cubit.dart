import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/ranking_mock_datasource.dart';
import '../data/repositories/ranking_repository_impl.dart';
import '../domain/entities/ranking_channel.dart';
import '../domain/entities/ranking_dimension.dart';
import '../domain/repositories/ranking_repository.dart';
import 'ranking_domain_state.dart';
import 'ranking_interaction_state.dart';
import 'ranking_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class RankingCubit extends Cubit<RankingState> {
  RankingCubit({
    RankingRepository? repository,
    RankingDimension initialDimension = RankingDimension.recommend,
  })  : _repository = repository ??
            const RankingRepositoryImpl(RankingMockDataSource()),
        super(
          RankingState(
            interaction:
                RankingInteractionState(selectedDimension: initialDimension),
          ),
        );

  final RankingRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(isLoading: true, clearError: true),
      ),
    );

    try {
      final content = await _repository.fetchPageContent();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isLoading: false),
          domain: RankingDomainState(content: content),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  void selectDimension(RankingDimension dimension) {
    if (dimension == state.interaction.selectedDimension) return;
    emit(
      state.copyWith(
        interaction:
            state.interaction.copyWith(selectedDimension: dimension),
      ),
    );
  }

  void selectChannel(RankingChannel channel) {
    if (channel == state.interaction.selectedChannel) return;
    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(selectedChannel: channel),
      ),
    );
  }
}
