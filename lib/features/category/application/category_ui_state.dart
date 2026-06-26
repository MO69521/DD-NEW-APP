import 'package:equatable/equatable.dart';

/// 分类页阶段：加载中、已加载、空结果。
enum CategoryPhase { loading, loaded, empty }

/// 分类页 UI 状态。
class CategoryUiState extends Equatable {
  const CategoryUiState({
    this.phase = CategoryPhase.loading,
    this.errorMessage,
    this.isLoadingMore = false,
    this.page = 0,
  });

  final CategoryPhase phase;
  final String? errorMessage;

  /// 上拉加载更多进行中。
  final bool isLoadingMore;

  /// 已加载的页码（0 为首屏）。
  final int page;

  CategoryUiState copyWith({
    CategoryPhase? phase,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingMore,
    int? page,
  }) {
    return CategoryUiState(
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [phase, errorMessage, isLoadingMore, page];
}
