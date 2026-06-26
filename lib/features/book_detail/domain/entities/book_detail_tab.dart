/// 书籍详情页顶部 Tab（详情 / 讨论 / 更新）。
enum BookDetailTab {
  detail,
  discussion,
  update;

  String get label => switch (this) {
    BookDetailTab.detail => '详情',
    BookDetailTab.discussion => '讨论',
    BookDetailTab.update => '更新',
  };
}
