import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/datasources/book_discussion_mock_datasource.dart';
import '../data/repositories/book_discussion_repository_impl.dart';
import '../domain/entities/book_discussion_post.dart';
import '../domain/repositories/book_discussion_repository.dart';
import 'book_discussion_detail_state.dart';

/// 书评详情交互状态管理：维护回复草稿与发送动作。
class BookDiscussionDetailCubit extends Cubit<BookDiscussionDetailState> {
  BookDiscussionDetailCubit({
    required BookDiscussionPost post,
    BookDiscussionRepository? repository,
  }) : _repository =
           repository ??
           const BookDiscussionRepositoryImpl(BookDiscussionMockDataSource()),
       super(BookDiscussionDetailState(post: post));

  final BookDiscussionRepository _repository;

  void updateReplyDraft(String value) {
    if (value == state.replyDraft) return;
    emit(state.copyWith(replyDraft: value));
  }

  Future<void> submitReply() async {
    final content = state.replyDraft.trim();
    if (content.isEmpty || state.isSubmittingReply) return;

    final previousPost = state.post;
    final nextReply = BookDiscussionReply(
      id: '${state.post.id}-temp-${state.post.replies.length + 1}',
      authorName: '我',
      authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
      publishMeta: '刚刚',
      content: content,
      likeCount: 0,
    );
    final nextReplies = List<BookDiscussionReply>.from(state.post.replies)
      ..add(nextReply);
    final nextPost = state.post.copyWith(
      replyCount: state.post.replyCount + 1,
      replies: nextReplies,
    );
    emit(
      state.copyWith(
        post: nextPost,
        replyDraft: '',
        draftRevision: state.draftRevision + 1,
        isSubmittingReply: true,
        clearError: true,
      ),
    );

    try {
      final serverReply = await _repository.submitReply(
        postId: state.post.id,
        content: content,
      );
      final mergedReplies = List<BookDiscussionReply>.from(state.post.replies);
      final tempIndex = mergedReplies.indexWhere(
        (reply) => reply.id == nextReply.id,
      );
      if (tempIndex >= 0) {
        mergedReplies[tempIndex] = serverReply;
      } else {
        mergedReplies.add(serverReply);
      }
      emit(
        state.copyWith(
          post: state.post.copyWith(replies: mergedReplies),
          isSubmittingReply: false,
          sendSuccessTick: state.sendSuccessTick + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          post: previousPost,
          replyDraft: content,
          isSubmittingReply: false,
          errorTick: state.errorTick + 1,
          errorMessage: '发送失败，请稍后重试',
        ),
      );
    }
  }

  Future<void> togglePostLike() async {
    if (state.isPostLikePending) return;

    final previousPost = state.post;
    final liked = state.post.isLiked;
    final nextCount = liked
        ? state.post.likeCount - 1
        : state.post.likeCount + 1;
    emit(
      state.copyWith(
        post: state.post.copyWith(
          isLiked: !liked,
          likeCount: nextCount < 0 ? 0 : nextCount,
        ),
        isPostLikePending: true,
        clearError: true,
      ),
    );

    try {
      await _repository.togglePostLike(postId: state.post.id, like: !liked);
      emit(state.copyWith(isPostLikePending: false));
    } catch (_) {
      emit(
        state.copyWith(
          post: previousPost,
          isPostLikePending: false,
          errorTick: state.errorTick + 1,
          errorMessage: '点赞失败，请重试',
        ),
      );
    }
  }

  Future<void> toggleReplyLike(String replyId) async {
    if (state.replyLikePendingIds.contains(replyId)) return;

    final previousPost = state.post;
    final target = state.post.replies.where((reply) => reply.id == replyId);
    if (target.isEmpty) return;

    final nextReplies = state.post.replies
        .map((reply) {
          if (reply.id != replyId) return reply;
          final liked = reply.isLiked;
          final nextCount = liked ? reply.likeCount - 1 : reply.likeCount + 1;
          return reply.copyWith(
            isLiked: !liked,
            likeCount: nextCount < 0 ? 0 : nextCount,
          );
        })
        .toList(growable: false);

    emit(
      state.copyWith(
        post: state.post.copyWith(replies: nextReplies),
        replyLikePendingIds: [...state.replyLikePendingIds, replyId],
        clearError: true,
      ),
    );

    final liked = target.first.isLiked;
    try {
      await _repository.toggleReplyLike(
        postId: state.post.id,
        replyId: replyId,
        like: !liked,
      );
      emit(
        state.copyWith(
          replyLikePendingIds: state.replyLikePendingIds
              .where((id) => id != replyId)
              .toList(growable: false),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          post: previousPost,
          replyLikePendingIds: state.replyLikePendingIds
              .where((id) => id != replyId)
              .toList(growable: false),
          errorTick: state.errorTick + 1,
          errorMessage: '点赞失败，请重试',
        ),
      );
    }
  }
}
