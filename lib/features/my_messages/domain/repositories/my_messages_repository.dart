import '../entities/my_messages_page_content.dart';

/// 我的消息页仓储抽象（domain 契约）。
abstract interface class MyMessagesRepository {
  Future<MyMessagesPageContent> fetchPageContent();
}
