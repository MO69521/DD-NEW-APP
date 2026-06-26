/// 榜单频道筛选（详情页顶部分段，Figma 220:8489）。纯 Dart。
enum RankingChannel {
  all,
  female,
  male;

  String get label => switch (this) {
        RankingChannel.all => '全部',
        RankingChannel.female => '女频',
        RankingChannel.male => '男频',
      };
}
