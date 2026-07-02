import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/search_mock_datasource.dart';
import '../data/repositories/search_repository_impl.dart';
import '../domain/repositories/search_repository.dart';
import 'search_domain_state.dart';
import 'search_state.dart';
import 'search_ui_state.dart';

/// application 层状态管理，state 仅在此层创建与修改。
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({SearchRepository? repository})
      : _repository =
            repository ?? const SearchRepositoryImpl(SearchMockDataSource()),
        super(const SearchState()) {
    loadRecommendations();
  }

  final SearchRepository _repository;

  Future<void> loadRecommendations() async {
    emit(
      state.copyWith(
        ui: state.ui.copyWith(
          isRecommendationsLoading: true,
          clearError: true,
        ),
      ),
    );

    try {
      final recommendations = await _repository.fetchRecommendations();
      emit(
        state.copyWith(
          ui: state.ui.copyWith(isRecommendationsLoading: false),
          domain: state.domain.copyWith(recommendations: recommendations),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            isRecommendationsLoading: false,
            errorMessage: error.toString(),
          ),
        ),
      );
    }
  }

  Future<void> search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      clear();
      return;
    }

    emit(
      state.copyWith(
        ui: state.ui.copyWith(phase: SearchPhase.loading, clearError: true),
        interaction: state.interaction.copyWith(committedQuery: query),
      ),
    );

    try {
      final results = await _repository.search(query);
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: results.isEmpty ? SearchPhase.noResult : SearchPhase.results,
          ),
          domain: state.domain.copyWith(results: results),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: SearchPhase.empty,
            errorMessage: error.toString(),
          ),
          domain: state.domain.copyWith(results: const []),
        ),
      );
    }
  }

  /// 清空关键词，回到默认推荐列表。
  void clear() {
    emit(
      SearchState(
        ui: state.ui.copyWith(
          phase: SearchPhase.empty,
          clearError: true,
          isRecommendationsLoading: false,
        ),
        domain: SearchDomainState(recommendations: state.domain.recommendations),
      ),
    );
  }
}
