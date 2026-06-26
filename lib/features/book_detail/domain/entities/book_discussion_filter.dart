/// 讨论分组筛选（书籍详情内二级切换）。
enum BookDiscussionFilter {
  all,
  featured,
  notice,
  guide;

  String get label => switch (this) {
    BookDiscussionFilter.all => '全部',
    BookDiscussionFilter.featured => '精选',
    BookDiscussionFilter.notice => '公告',
    BookDiscussionFilter.guide => '攻略',
  };
}
