/// 排序模式：热门 / 新作。
enum PartnerSortMode {
  hot('热门'),
  newest('新作');

  const PartnerSortMode(this.label);

  final String label;
}
