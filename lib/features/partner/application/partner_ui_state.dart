import 'package:equatable/equatable.dart';

/// UI 状态：加载 / 空 / 错误 / 加载更多。
class PartnerUiState extends Equatable {
  const PartnerUiState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.page = 0,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int page;

  bool get hasError => errorMessage != null;

  PartnerUiState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    int? page,
  }) {
    return PartnerUiState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [isLoading, isLoadingMore, errorMessage, page];
}
