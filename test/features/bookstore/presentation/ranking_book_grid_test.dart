import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/domain/entities/book_cover_bottom_badge.dart';
import 'package:diandian_chuanshu/features/bookstore/presentation/components/ranking_book_grid.dart';
import 'package:diandian_chuanshu/shared/components/book_cover_bottom_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('推荐页顶部榜单小封面不显示右下运营标签', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RankingBookGrid(
            books: [
              Book(
                id: 'book-1',
                title: '测试书籍',
                category: '测试分类',
                coverAsset: 'assets/covers/cover_01.png',
                coverBottomBadge: BookCoverBottomBadge(
                  type: BookCoverBottomBadgeType.popularity,
                  label: '55.0万',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(BookCoverBottomBadgeView), findsNothing);
    expect(find.text('55.0万'), findsNothing);
  });
}
