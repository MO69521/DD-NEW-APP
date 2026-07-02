import 'package:equatable/equatable.dart';

/// 搜索页阶段：空态（未搜索）、加载中、结果、无结果。
enum SearchPhase { empty, loading, results, noResult }

/// 搜索页 UI 状态。
class SearchUiState extends Equatable {
  const SearchUiState({
    this.phase = SearchPhase.empty,
    this.errorMessage,
    this.isRecommendationsLoading = false,
  });

  final SearchPhase phase;
  final String? errorMessage;
  final bool isRecommendationsLoading;

  SearchUiState copyWith({
    SearchPhase? phase,
    String? errorMessage,
    bool? isRecommendationsLoading,
    bool clearError = false,
  }) {
    return SearchUiState(
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isRecommendationsLoading:
          isRecommendationsLoading ?? this.isRecommendationsLoading,
    );
  }

  @override
  List<Object?> get props => [phase, errorMessage, isRecommendationsLoading];
}
