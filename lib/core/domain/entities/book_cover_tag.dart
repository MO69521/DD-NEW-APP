/// 书籍封面右上角状态角标类型（后端接口返回）。纯 Dart，禁止依赖 Flutter。
enum BookCoverTag {
  updated,
  completed,
  serializing;

  String get label => switch (this) {
    BookCoverTag.updated => '更新',
    BookCoverTag.completed => '完结',
    BookCoverTag.serializing => '连载',
  };

  /// 由后端/展示文案解析角标类型；无法识别时返回 null（不展示）。
  static BookCoverTag? fromLabel(String? label) => switch (label) {
    '更新' => BookCoverTag.updated,
    '完结' => BookCoverTag.completed,
    '连载' => BookCoverTag.serializing,
    _ => null,
  };
}
