import 'package:equatable/equatable.dart';

import '../domain/entities/bookshelf_tab.dart';

/// UI 状态：加载与错误。
class BookshelfUiState extends Equatable {
  const BookshelfUiState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.loadMorePageByTab = const {},
    this.errorMessage,
  });

  final bool isLoading;
  final bool isLoadingMore;
  final Map<BookshelfTab, int> loadMorePageByTab;
  final String? errorMessage;

  BookshelfUiState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    Map<BookshelfTab, int>? loadMorePageByTab,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookshelfUiState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMorePageByTab: loadMorePageByTab ?? this.loadMorePageByTab,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoadingMore,
    loadMorePageByTab,
    errorMessage,
  ];
}
