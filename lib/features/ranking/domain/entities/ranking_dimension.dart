/// 榜单维度（详情页左侧竖向 Tab，Figma 220:8570）。纯 Dart。
enum RankingDimension {
  recommend,
  popular,
  rising,
  completed,
  following,
  potential,
  interaction;

  String get label => switch (this) {
        RankingDimension.recommend => '推荐榜',
        RankingDimension.popular => '人气榜',
        RankingDimension.rising => '飙升榜',
        RankingDimension.completed => '完结榜',
        RankingDimension.following => '追更榜',
        RankingDimension.potential => '潜力榜',
        RankingDimension.interaction => '互动榜',
      };

  /// hero 标题后缀，如「人气榜」（拼接为「点点穿书 人气榜」）。
  String get titleSuffix => label;

  /// hero 副标题描述（Figma 220:8532）。
  String get subtitle => switch (this) {
        RankingDimension.recommend => '根据用户喜好智能推荐',
        RankingDimension.popular => '根据用户阅读情况排行',
        RankingDimension.rising => '近期热度飙升排行',
        RankingDimension.completed => '已完结作品口碑排行',
        RankingDimension.following => '追更人数实时排行',
        RankingDimension.potential => '潜力新作上升排行',
        RankingDimension.interaction => '根据互动热度排行',
      };
}
