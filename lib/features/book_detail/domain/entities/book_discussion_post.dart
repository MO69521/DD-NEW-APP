import 'package:equatable/equatable.dart';

import 'book_discussion_filter.dart';

/// 讨论区回复预览（灰底摘要块）。
class BookDiscussionReplyPreview extends Equatable {
  const BookDiscussionReplyPreview({
    required this.authorName,
    required this.content,
  });

  final String authorName;
  final String content;

  @override
  List<Object?> get props => [authorName, content];
}

/// 书评详情回复项。
class BookDiscussionReply extends Equatable {
  const BookDiscussionReply({
    required this.id,
    required this.authorName,
    required this.authorAvatarAsset,
    required this.publishMeta,
    required this.content,
    required this.likeCount,
    this.isLiked = false,
  });

  final String id;
  final String authorName;
  final String authorAvatarAsset;
  final String publishMeta;
  final String content;
  final int likeCount;
  final bool isLiked;

  BookDiscussionReply copyWith({int? likeCount, bool? isLiked}) {
    return BookDiscussionReply(
      id: id,
      authorName: authorName,
      authorAvatarAsset: authorAvatarAsset,
      publishMeta: publishMeta,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
    id,
    authorName,
    authorAvatarAsset,
    publishMeta,
    content,
    likeCount,
    isLiked,
  ];
}

/// 讨论区帖子聚合实体（列表卡片）。
class BookDiscussionPost extends Equatable {
  const BookDiscussionPost({
    required this.id,
    required this.authorName,
    required this.authorAvatarAsset,
    required this.publishMeta,
    required this.likeCount,
    required this.title,
    required this.content,
    required this.replyCount,
    required this.filters,
    this.isLiked = false,
    this.replies = const [],
    this.highlightTag,
    this.replyPreview,
  });

  final String id;
  final String authorName;
  final String authorAvatarAsset;

  /// 时间+地区等展示就绪元信息（如「06-21 23:32·江苏省」）。
  final String publishMeta;
  final int likeCount;
  final String title;
  final String content;
  final int replyCount;
  final List<BookDiscussionFilter> filters;
  final bool isLiked;
  final List<BookDiscussionReply> replies;

  /// 帖子标签，如「精选」。
  final String? highlightTag;
  final BookDiscussionReplyPreview? replyPreview;

  BookDiscussionPost copyWith({
    int? replyCount,
    List<BookDiscussionReply>? replies,
    int? likeCount,
    bool? isLiked,
    BookDiscussionReplyPreview? replyPreview,
  }) {
    return BookDiscussionPost(
      id: id,
      authorName: authorName,
      authorAvatarAsset: authorAvatarAsset,
      publishMeta: publishMeta,
      likeCount: likeCount ?? this.likeCount,
      title: title,
      content: content,
      replyCount: replyCount ?? this.replyCount,
      filters: filters,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
      highlightTag: highlightTag,
      replyPreview: replyPreview,
    );
  }

  @override
  List<Object?> get props => [
    id,
    authorName,
    authorAvatarAsset,
    publishMeta,
    likeCount,
    title,
    content,
    replyCount,
    filters,
    isLiked,
    replies,
    highlightTag,
    replyPreview,
  ];
}
