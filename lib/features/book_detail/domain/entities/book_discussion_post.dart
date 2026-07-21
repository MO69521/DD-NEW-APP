import 'package:equatable/equatable.dart';

import 'book_discussion_filter.dart';

/// 讨论帖正文前的内容标签（可叠加，展示顺序：置顶 → 精选 → 公告）。
enum BookDiscussionPostBadge {
  pinned,
  featured,
  notice,
}

extension BookDiscussionPostBadgeX on BookDiscussionPostBadge {
  String get label => switch (this) {
    BookDiscussionPostBadge.pinned => '置顶',
    BookDiscussionPostBadge.featured => '精选',
    BookDiscussionPostBadge.notice => '公告',
  };
}

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
    this.isAuthor = false,
  });

  final String id;
  final String authorName;
  final String authorAvatarAsset;
  final String publishMeta;
  final String content;
  final int likeCount;
  final bool isLiked;

  /// 是否为本书作者发言。
  final bool isAuthor;

  BookDiscussionReply copyWith({
    int? likeCount,
    bool? isLiked,
    bool? isAuthor,
  }) {
    return BookDiscussionReply(
      id: id,
      authorName: authorName,
      authorAvatarAsset: authorAvatarAsset,
      publishMeta: publishMeta,
      content: content,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isAuthor: isAuthor ?? this.isAuthor,
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
    isAuthor,
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
    this.isAuthor = false,
    this.replies = const [],
    this.badges = const [],
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

  /// 是否为本书作者发言。
  final bool isAuthor;
  final List<BookDiscussionReply> replies;

  /// 正文前标签（置顶 / 精选 / 公告，可多选）。
  final List<BookDiscussionPostBadge> badges;
  final BookDiscussionReplyPreview? replyPreview;

  BookDiscussionPost copyWith({
    int? replyCount,
    List<BookDiscussionReply>? replies,
    int? likeCount,
    bool? isLiked,
    bool? isAuthor,
    List<BookDiscussionPostBadge>? badges,
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
      isAuthor: isAuthor ?? this.isAuthor,
      replies: replies ?? this.replies,
      badges: badges ?? this.badges,
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
    isAuthor,
    replies,
    badges,
    replyPreview,
  ];
}
