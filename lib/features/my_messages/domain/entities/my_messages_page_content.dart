import 'package:equatable/equatable.dart';

import 'my_message.dart';
import 'my_message_tab.dart';
import 'my_notification.dart';

/// 我的消息页内容：各 Tab 的消息列表与未读数。
class MyMessagesPageContent extends Equatable {
  const MyMessagesPageContent({
    this.replies = const [],
    this.likes = const [],
    this.notifications = const [],
    this.unreadReplies = 0,
    this.unreadLikes = 0,
    this.unreadNotifications = 0,
  });

  final List<MyMessage> replies;
  final List<MyMessage> likes;

  /// 通知与回复/获赞结构不同，单独承载。
  final List<MyNotification> notifications;

  final int unreadReplies;
  final int unreadLikes;
  final int unreadNotifications;

  /// 回复 / 获赞消息列表；通知走 [notifications]。
  List<MyMessage> messagesFor(MyMessageTab tab) {
    return switch (tab) {
      MyMessageTab.reply => replies,
      MyMessageTab.like => likes,
      MyMessageTab.notification => const [],
    };
  }

  int unreadFor(MyMessageTab tab) {
    return switch (tab) {
      MyMessageTab.reply => unreadReplies,
      MyMessageTab.like => unreadLikes,
      MyMessageTab.notification => unreadNotifications,
    };
  }

  @override
  List<Object?> get props => [
    replies,
    likes,
    notifications,
    unreadReplies,
    unreadLikes,
    unreadNotifications,
  ];
}
