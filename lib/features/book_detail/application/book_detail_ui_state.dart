import 'package:equatable/equatable.dart';

/// 书籍详情页 UI 状态。
class BookDetailUiState extends Equatable {
  const BookDetailUiState({
    this.isLoading = false,
    this.errorMessage,
    this.quickReplySuccessTick = 0,
    this.quickReplyErrorTick = 0,
    this.quickReplyErrorMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final int quickReplySuccessTick;
  final int quickReplyErrorTick;
  final String? quickReplyErrorMessage;

  BookDetailUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? quickReplySuccessTick,
    int? quickReplyErrorTick,
    String? quickReplyErrorMessage,
    bool clearQuickReplyError = false,
  }) {
    return BookDetailUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      quickReplySuccessTick:
          quickReplySuccessTick ?? this.quickReplySuccessTick,
      quickReplyErrorTick: quickReplyErrorTick ?? this.quickReplyErrorTick,
      quickReplyErrorMessage: clearQuickReplyError
          ? null
          : quickReplyErrorMessage ?? this.quickReplyErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    quickReplySuccessTick,
    quickReplyErrorTick,
    quickReplyErrorMessage,
  ];
}
