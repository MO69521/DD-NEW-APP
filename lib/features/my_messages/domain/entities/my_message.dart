import 'package:equatable/equatable.dart';

import 'my_message_tab.dart';

/// 消息内被引用的书籍（可含章节信息）。
class MyMessageBookRef extends Equatable {
  const MyMessageBookRef({
    required this.title,
    required this.coverAsset,
    this.chapterLabel,
  });

  final String title;
  final String coverAsset;

  /// 章节信息（如「第三章 武侠世界梦」），为空则不展示。
  final String? chapterLabel;

  @override
  List<Object?> get props => [title, coverAsset, chapterLabel];
}

/// 一条互动消息（回复 / 获赞）。
class MyMessage extends Equatable {
  const MyMessage({
    required this.id,
    required this.kind,
    required this.senderName,
    required this.timeLabel,
    required this.quotedReview,
    required this.bookRef,
    this.senderAvatarUrl,
    this.isAuthor = false,
    this.replyContent,
    this.isDeleted = false,
  });

  final String id;

  /// 消息类型（回复 / 获赞）；决定动作文案与是否展示回复正文。
  final MyMessageTab kind;

  final String senderName;
  final String? senderAvatarUrl;

  /// 相对时间文案（如「2分钟前」）。
  final String timeLabel;

  /// 被回复 / 被点赞的「我的书评」原文。
  final String quotedReview;

  final MyMessageBookRef bookRef;

  /// 发信人是否为作者（展示「作者」标识）。
  final bool isAuthor;

  /// 回复正文；获赞消息为空。
  final String? replyContent;

  /// 回复是否已被删除（展示「该评论已被删除」占位）。
  final bool isDeleted;

  @override
  List<Object?> get props => [
    id,
    kind,
    senderName,
    senderAvatarUrl,
    timeLabel,
    quotedReview,
    bookRef,
    isAuthor,
    replyContent,
    isDeleted,
  ];
}
