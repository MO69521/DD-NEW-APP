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
    loadKeywords();
  }

  final SearchRepository _repository;

  /// 加载热门搜索 + 搜索历史。
  Future<void> loadKeywords() async {
    try {
      final hotKeywords = await _repository.fetchHotKeywords();
      final searchHistory = await _repository.fetchSearchHistory();
      emit(
        state.copyWith(
          domain: state.domain.copyWith(
            hotKeywords: hotKeywords,
            searchHistory: searchHistory,
          ),
        ),
      );
    } catch (_) {
      // 关键词为辅助信息，加载失败静默降级（不阻断搜索）。
    }
  }

  /// 清空搜索历史。
  Future<void> clearHistory() async {
    final history = await _repository.clearSearchHistory();
    emit(
      state.copyWith(
        domain: state.domain.copyWith(searchHistory: history),
      ),
    );
  }

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

  /// 输入变化：实时联想；空则回到默认页。
  Future<void> queryChanged(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      clear();
      return;
    }

    final suggestions = await _repository.fetchSuggestions(query);
    // 期间用户可能已提交或清空，phase 已切换则丢弃本次联想结果。
    if (state.ui.phase == SearchPhase.loading ||
        state.ui.phase == SearchPhase.results) {
      return;
    }
    emit(
      state.copyWith(
        ui: state.ui.copyWith(phase: SearchPhase.suggesting, clearError: true),
        domain: state.domain.copyWith(suggestions: suggestions),
        interaction: state.interaction.copyWith(committedQuery: query),
      ),
    );
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
      final history = await _repository.addSearchHistory(query);
      emit(
        state.copyWith(
          ui: state.ui.copyWith(
            phase: results.isEmpty ? SearchPhase.noResult : SearchPhase.results,
          ),
          domain: state.domain.copyWith(
            results: results,
            searchHistory: history,
          ),
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

  /// 清空关键词，回到默认推荐列表（保留热门搜索与历史）。
  void clear() {
    emit(
      SearchState(
        ui: state.ui.copyWith(
          phase: SearchPhase.empty,
          clearError: true,
          isRecommendationsLoading: false,
        ),
        domain: SearchDomainState(
          recommendations: state.domain.recommendations,
          hotKeywords: state.domain.hotKeywords,
          searchHistory: state.domain.searchHistory,
        ),
      ),
    );
  }
}
