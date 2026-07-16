/// 书城顶栏一级 Tab（推荐 / 分类 / 排行）。
enum BookstoreTopTab {
  recommend,
  category,
  ranking;

  String get label => switch (this) {
    BookstoreTopTab.recommend => '推荐',
    BookstoreTopTab.category => '分类',
    BookstoreTopTab.ranking => '排行',
  };
}
