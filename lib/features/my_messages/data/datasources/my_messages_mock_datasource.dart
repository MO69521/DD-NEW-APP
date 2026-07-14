import '../../domain/entities/my_message.dart';
import '../../domain/entities/my_message_tab.dart';
import '../../domain/entities/my_messages_page_content.dart';
import '../../domain/entities/my_notification.dart';
import 'my_messages_data_source.dart';

/// 我的消息 mock 数据源。
class MyMessagesMockDataSource implements MyMessagesDataSource {
  const MyMessagesMockDataSource();

  static const String _quotedReview = '他们朝我扔泥巴，泥巴干了我咋他家玻璃…';

  static const MyMessageBookRef _replyBookRef = MyMessageBookRef(
    title: '《我养当女帝》',
    coverAsset: 'assets/covers/cover_01.png',
  );

  static const MyMessageBookRef _likeBookRef = MyMessageBookRef(
    title: '《我养当女帝》',
    coverAsset: 'assets/covers/cover_01.png',
    chapterLabel: '第三章 武侠世界梦',
  );

  static const String _noticeContent = '限免卡忘记用过期了，这个体验感很差，怎么没有快过期的通知呢';
  static const String _noticeTime = '2024-10-11 21:05:33';

  static const List<MyNotification> _notifications = [
    MyNotification(
      id: 'notice-1',
      senderName: '客服',
      actionLabel: '已回复您',
      content: _noticeContent,
      timeLabel: _noticeTime,
      status: MyNotificationStatus.isNew,
    ),
    MyNotification(
      id: 'notice-2',
      senderName: '客服',
      actionLabel: '已回复您',
      content: _noticeContent,
      timeLabel: _noticeTime,
      status: MyNotificationStatus.isNew,
    ),
    MyNotification(
      id: 'notice-3',
      senderName: '客服',
      actionLabel: '已回复您',
      content: _noticeContent,
      timeLabel: _noticeTime,
      status: MyNotificationStatus.unread,
    ),
    MyNotification(
      id: 'notice-4',
      senderName: '客服',
      actionLabel: '已回复您',
      content: _noticeContent,
      timeLabel: _noticeTime,
      status: MyNotificationStatus.read,
    ),
  ];

  @override
  Future<MyMessagesPageContent> fetchPageContent() async {
    await Future<void>.delayed(const Duration(milliseconds: 240));

    return const MyMessagesPageContent(
      unreadReplies: 0,
      unreadLikes: 16,
      unreadNotifications: 0,
      notifications: _notifications,
      replies: [
        MyMessage(
          id: 'reply-1',
          kind: MyMessageTab.reply,
          senderName: '白色云海',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=15',
          timeLabel: '2分钟前',
          isAuthor: true,
          replyContent: '超级好玩，我的崽也太可爱了！就是数值感觉…',
          quotedReview: _quotedReview,
          bookRef: _replyBookRef,
        ),
        MyMessage(
          id: 'reply-2',
          kind: MyMessageTab.reply,
          senderName: '喜欢枫叶的岚',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=32',
          timeLabel: '2分钟前',
          replyContent: '鹅我要笑死了，我不是吹，我就是氪金大佬…',
          quotedReview: _quotedReview,
          bookRef: _replyBookRef,
        ),
        MyMessage(
          id: 'reply-3',
          kind: MyMessageTab.reply,
          senderName: '喜欢枫叶的岚',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=32',
          timeLabel: '2分钟前',
          isDeleted: true,
          quotedReview: _quotedReview,
          bookRef: _replyBookRef,
        ),
      ],
      likes: [
        MyMessage(
          id: 'like-1',
          kind: MyMessageTab.like,
          senderName: '白色云海',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=15',
          timeLabel: '2分钟前',
          quotedReview: _quotedReview,
          bookRef: _likeBookRef,
        ),
        MyMessage(
          id: 'like-2',
          kind: MyMessageTab.like,
          senderName: '喜欢枫叶的岚',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=32',
          timeLabel: '15分钟前',
          quotedReview: _quotedReview,
          bookRef: _likeBookRef,
        ),
        MyMessage(
          id: 'like-3',
          kind: MyMessageTab.like,
          senderName: '喜欢枫叶的岚',
          senderAvatarUrl: 'https://i.pravatar.cc/150?img=45',
          timeLabel: '60分钟前',
          quotedReview: _quotedReview,
          bookRef: _likeBookRef,
        ),
      ],
    );
  }
}
