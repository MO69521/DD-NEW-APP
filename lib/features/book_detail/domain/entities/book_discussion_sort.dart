/// 讨论列表排序（书籍详情讨论 Tab）。
enum BookDiscussionSort {
  latest,
  hottest;

  String get label => switch (this) {
    BookDiscussionSort.latest => '最新',
    BookDiscussionSort.hottest => '最热',
  };
}
