import '../../domain/entities/book_discussion_post.dart';
import 'book_discussion_data_source.dart';

/// 书评详情交互 mock 数据源。
class BookDiscussionMockDataSource implements BookDiscussionDataSource {
  const BookDiscussionMockDataSource();

  @override
  Future<void> togglePostLike({
    required String postId,
    required bool like,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (postId.isEmpty) {
      throw Exception('帖子不存在');
    }
  }

  @override
  Future<void> toggleReplyLike({
    required String postId,
    required String replyId,
    required bool like,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));
    if (postId.isEmpty || replyId.isEmpty) {
      throw Exception('回复不存在');
    }
  }

  @override
  Future<BookDiscussionReply> submitReply({
    required String postId,
    required String content,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 360));
    final trimmed = content.trim();
    if (postId.isEmpty || trimmed.isEmpty) {
      throw Exception('回复内容为空');
    }
    return BookDiscussionReply(
      id: '$postId-reply-${DateTime.now().microsecondsSinceEpoch}',
      authorName: '我',
      authorAvatarAsset: 'assets/images/profile/avatar_placeholder.png',
      publishMeta: '刚刚',
      content: trimmed,
      likeCount: 0,
    );
  }
}
