import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/domain/entities/book_cover_bottom_badge.dart';
import 'package:diandian_chuanshu/core/domain/entities/book_cover_tag.dart';
import 'package:diandian_chuanshu/features/ranking/presentation/components/ranking_book_row.dart';
import 'package:diandian_chuanshu/shared/components/book_cover_bottom_badge.dart';
import 'package:diandian_chuanshu/shared/components/book_cover_tag_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('榜单书行展示封面右上状态角标与右下运营标签', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RankingBookRow(
            rank: 1,
            book: Book(
              id: 'rank-1',
              title: '测试书籍',
              category: '测试分类',
              coverAsset: 'assets/covers/cover_01.png',
              coverTag: BookCoverTag.updated,
              coverBottomBadge: BookCoverBottomBadge(
                type: BookCoverBottomBadgeType.popularity,
                label: '55.0万',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(BookCoverTagBadge), findsOneWidget);
    expect(find.text('更新'), findsOneWidget);
    expect(find.byType(BookCoverBottomBadgeView), findsOneWidget);
    expect(find.text('55.0万'), findsOneWidget);
  });
}
