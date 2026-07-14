import '../../domain/entities/book_discussion_post.dart';

/// 书评交互数据源抽象。Mock 与 Remote 实现同一契约，
/// Repository 只依赖此接口——接入真实接口时仅替换注入的实现，无需改动上层。
abstract interface class BookDiscussionDataSource {
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
