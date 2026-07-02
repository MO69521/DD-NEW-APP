import 'package:equatable/equatable.dart';

/// UI 状态：加载与错误。
class BookshelfUiState extends Equatable {
  const BookshelfUiState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.recommendationPage = 0,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final int recommendationPage;
  final String? errorMessage;

  BookshelfUiState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? recommendationPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookshelfUiState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      recommendationPage: recommendationPage ?? this.recommendationPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    recommendationPage,
    errorMessage,
  ];
}
