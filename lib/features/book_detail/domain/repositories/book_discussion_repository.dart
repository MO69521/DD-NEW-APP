import '../entities/book_discussion_post.dart';

/// 书评详情交互仓储抽象：点赞与发送回复。
abstract interface class BookDiscussionRepository {
  Future<void> togglePostLike({required String postId, required bool like});

  Future<void> toggleReplyLike({
    required String postId,
    required String replyId,
    required bool like,
  });

  Future<BookDiscussionReply> submitReply({
    required String postId,
    required String content,
  });
}
