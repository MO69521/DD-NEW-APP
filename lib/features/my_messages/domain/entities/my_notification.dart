import 'package:equatable/equatable.dart';

/// 通知阅读状态，决定标识样式与是否置灰。
enum MyNotificationStatus {
  /// 全新通知（橙色「NEW」标）。
  isNew,

  /// 未读（橙色描边「未读」标）。
  unread,

  /// 已读（无标识，整条置灰）。
  read,
}

/// 一条系统 / 客服通知。
class MyNotification extends Equatable {
  const MyNotification({
    required this.id,
    required this.senderName,
    required this.actionLabel,
    required this.content,
    required this.timeLabel,
    required this.status,
  });

  final String id;
  final String senderName;
  final String actionLabel;
  final String content;
  final String timeLabel;
  final MyNotificationStatus status;

  @override
  List<Object?> get props => [
    id,
    senderName,
    actionLabel,
    content,
    timeLabel,
    status,
  ];
}
