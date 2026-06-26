import 'package:equatable/equatable.dart';

import '../domain/entities/book_discussion_post.dart';

/// 书评详情交互状态：草稿与回复列表动态更新。
class BookDiscussionDetailState extends Equatable {
  const BookDiscussionDetailState({
    required this.post,
    this.replyDraft = '',
    this.draftRevision = 0,
    this.sendSuccessTick = 0,
    this.errorTick = 0,
    this.errorMessage,
    this.isSubmittingReply = false,
    this.isPostLikePending = false,
    this.replyLikePendingIds = const [],
  });

  final BookDiscussionPost post;
  final String replyDraft;

  /// 用于重建输入框（发送后清空）。
  final int draftRevision;
  final int sendSuccessTick;
  final int errorTick;
  final String? errorMessage;
  final bool isSubmittingReply;
  final bool isPostLikePending;
  final List<String> replyLikePendingIds;

  bool get canSend => !isSubmittingReply && replyDraft.trim().isNotEmpty;

  BookDiscussionDetailState copyWith({
    BookDiscussionPost? post,
    String? replyDraft,
    int? draftRevision,
    int? sendSuccessTick,
    int? errorTick,
    String? errorMessage,
    bool clearError = false,
    bool? isSubmittingReply,
    bool? isPostLikePending,
    List<String>? replyLikePendingIds,
  }) {
    return BookDiscussionDetailState(
      post: post ?? this.post,
      replyDraft: replyDraft ?? this.replyDraft,
      draftRevision: draftRevision ?? this.draftRevision,
      sendSuccessTick: sendSuccessTick ?? this.sendSuccessTick,
      errorTick: errorTick ?? this.errorTick,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isSubmittingReply: isSubmittingReply ?? this.isSubmittingReply,
      isPostLikePending: isPostLikePending ?? this.isPostLikePending,
      replyLikePendingIds: replyLikePendingIds ?? this.replyLikePendingIds,
    );
  }

  @override
  List<Object?> get props => [
    post,
    replyDraft,
    draftRevision,
    sendSuccessTick,
    errorTick,
    errorMessage,
    isSubmittingReply,
    isPostLikePending,
    replyLikePendingIds,
  ];
}
