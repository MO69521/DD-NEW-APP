/// 书籍连载状态（搜索结果角标）。纯 Dart，禁止依赖 Flutter。
enum BookSerializationStatus {
  serializing,
  completed;

  String get label => switch (this) {
        BookSerializationStatus.serializing => '连载',
        BookSerializationStatus.completed => '完结',
      };
}
