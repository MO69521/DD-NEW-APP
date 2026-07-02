import 'package:equatable/equatable.dart';

/// 编辑推荐详情页阶段：加载中、已加载、空结果。
enum EditorPickPhase { loading, loaded, empty }

/// 编辑推荐详情页 UI 状态。
class EditorPickUiState extends Equatable {
  const EditorPickUiState({
    this.phase = EditorPickPhase.loading,
    this.errorMessage,
    this.isLoadingMore = false,
    this.page = 0,
  });

  final EditorPickPhase phase;
  final String? errorMessage;
  final bool isLoadingMore;
  final int page;

  EditorPickUiState copyWith({
    EditorPickPhase? phase,
    String? errorMessage,
    bool clearError = false,
    bool? isLoadingMore,
    int? page,
  }) {
    return EditorPickUiState(
      phase: phase ?? this.phase,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [phase, errorMessage, isLoadingMore, page];
}
