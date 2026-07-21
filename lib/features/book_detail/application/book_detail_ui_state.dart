import 'package:equatable/equatable.dart';

/// 书籍详情页 UI 状态。
class BookDetailUiState extends Equatable {
  const BookDetailUiState({
    this.isLoading = false,
    this.errorMessage,
    this.quickReplySuccessTick = 0,
    this.quickReplyErrorTick = 0,
    this.quickReplyErrorMessage,
    this.shelfToastTick = 0,
    this.shelfToastMessage,
    this.highlightedDiscussionPostId,
  });

  final bool isLoading;
  final String? errorMessage;
  final int quickReplySuccessTick;
  final int quickReplyErrorTick;
  final String? quickReplyErrorMessage;

  /// 加入/取消书架反馈计数（每次操作自增，驱动一次性 Toast）。
  final int shelfToastTick;
  final String? shelfToastMessage;

  /// 新发讨论帖短暂高亮 id；`null` 表示无高亮。
  final String? highlightedDiscussionPostId;

  BookDetailUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? quickReplySuccessTick,
    int? quickReplyErrorTick,
    String? quickReplyErrorMessage,
    bool clearQuickReplyError = false,
    int? shelfToastTick,
    String? shelfToastMessage,
    String? highlightedDiscussionPostId,
    bool clearHighlightedDiscussionPostId = false,
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
      shelfToastTick: shelfToastTick ?? this.shelfToastTick,
      shelfToastMessage: shelfToastMessage ?? this.shelfToastMessage,
      highlightedDiscussionPostId: clearHighlightedDiscussionPostId
          ? null
          : highlightedDiscussionPostId ?? this.highlightedDiscussionPostId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    quickReplySuccessTick,
    quickReplyErrorTick,
    quickReplyErrorMessage,
    shelfToastTick,
    shelfToastMessage,
    highlightedDiscussionPostId,
  ];
}
