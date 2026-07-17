import 'package:equatable/equatable.dart';

/// 书城页 UI 状态。
class BookstoreUiState extends Equatable {
  const BookstoreUiState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMoreGuessLike = false,
    this.guessLikePage = 0,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMoreGuessLike;
  final int guessLikePage;
  final String? errorMessage;

  BookstoreUiState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMoreGuessLike,
    int? guessLikePage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookstoreUiState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMoreGuessLike:
          isLoadingMoreGuessLike ?? this.isLoadingMoreGuessLike,
      guessLikePage: guessLikePage ?? this.guessLikePage,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isRefreshing,
    isLoadingMoreGuessLike,
    guessLikePage,
    errorMessage,
  ];
}
