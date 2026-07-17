import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/features/search/domain/entities/search_recommendation_item.dart';
import 'package:diandian_chuanshu/features/search/presentation/components/search_recommendation_row.dart';
import 'package:diandian_chuanshu/shared/components/ranking_rank_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const item = SearchRecommendationItem(
    book: Book(
      id: 'hot-1',
      title: '热搜书籍',
      category: '分类',
      coverAsset: 'assets/covers/cover_01.png',
    ),
    badgeLabel: '更新',
    tags: ['甜宠'],
    description: '简介',
    author: '作者',
  );

  testWidgets('传入排行时复用 RankingRankBadge', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SearchRecommendationRow(item: item, rank: 2)),
      ),
    );

    final badge = tester.widget<RankingRankBadge>(
      find.byType(RankingRankBadge),
    );
    expect(badge.rank, 2);
  });

  testWidgets('普通推荐未传排行时不显示角标', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SearchRecommendationRow(item: item)),
      ),
    );

    expect(find.byType(RankingRankBadge), findsNothing);
  });
}
