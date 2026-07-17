import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/features/bookstore/data/datasources/bookstore_mock_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('连续请求返回不同的书城内容快照', () async {
    final dataSource = BookstoreMockDataSource();

    final initial = await dataSource.fetchPageContent();
    final refreshed = await dataSource.fetchPageContent();

    final initialRanking = initial.rankingBooksByTab[RankingTab.recommend]!;
    final refreshedRanking = refreshed.rankingBooksByTab[RankingTab.recommend]!;
    expect(refreshedRanking.first, initialRanking[1]);
    expect(refreshed.editorPicks.first, initial.editorPicks[1]);
    expect(refreshed.guessLikeBooks.first, initial.guessLikeBooks[1]);
    expect(refreshed, isNot(initial));
  });
}
