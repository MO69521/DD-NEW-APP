import 'package:equatable/equatable.dart';

/// 榜单详情页 UI 状态。
class RankingUiState extends Equatable {
  const RankingUiState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final String? errorMessage;

  RankingUiState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    String? errorMessage,
    bool clearError = false,
  }) {
    return RankingUiState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoadingMore, hasMoreData, errorMessage];
}
