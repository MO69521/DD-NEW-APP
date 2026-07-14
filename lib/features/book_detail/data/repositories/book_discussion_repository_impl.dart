import '../../domain/entities/book_discussion_post.dart';
import '../../domain/repositories/book_discussion_repository.dart';
import '../datasources/book_discussion_data_source.dart';

/// 书评详情交互仓储实现，仅做数据请求桥接。
class BookDiscussionRepositoryImpl implements BookDiscussionRepository {
  const BookDiscussionRepositoryImpl(this._dataSource);

  final BookDiscussionDataSource _dataSource;

  @override
  Future<void> togglePostLike({required String postId, required bool like}) =>
      _dataSource.togglePostLike(postId: postId, like: like);

  @override
  Future<void> toggleReplyLike({
    required String postId,
    required String replyId,
    required bool like,
  }) =>
      _dataSource.toggleReplyLike(postId: postId, replyId: replyId, like: like);

  @override
  Future<BookDiscussionReply> submitReply({
    required String postId,
    required String content,
  }) => _dataSource.submitReply(postId: postId, content: content);
}
