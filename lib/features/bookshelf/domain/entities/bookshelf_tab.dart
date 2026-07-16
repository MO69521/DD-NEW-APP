/// 书架页顶部 Tab：书架 / 阅读历史。
enum BookshelfTab {
  shelf,
  history;

  String get label => switch (this) {
    BookshelfTab.shelf => '书架',
    BookshelfTab.history => '阅读历史',
  };
}
