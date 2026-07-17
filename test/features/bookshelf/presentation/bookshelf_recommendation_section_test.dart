import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/theme/app_spacing.dart';
import 'package:diandian_chuanshu/features/bookshelf/presentation/components/bookshelf_recommendation_section.dart';
import 'package:diandian_chuanshu/shared/widgets/app_pressable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('推荐卡使用双列瀑布流且横纵间距均为 16px', (tester) async {
    const books = [
      Book(
        id: '1',
        title: '左一',
        category: '分类',
        coverAsset: 'assets/covers/cover_01.png',
        summary: '较长的两行简介，用于形成不同高度的推荐卡片内容。',
        annotations: ['标签一', '标签二', '标签三', '标签四'],
      ),
      Book(
        id: '2',
        title: '右一',
        category: '分类',
        coverAsset: 'assets/covers/cover_02.png',
        summary: '短简介',
        annotations: ['短标签'],
      ),
      Book(
        id: '3',
        title: '左二',
        category: '分类',
        coverAsset: 'assets/covers/cover_03.png',
      ),
      Book(
        id: '4',
        title: '右二',
        category: '分类',
        coverAsset: 'assets/covers/cover_04.png',
      ),
    ];

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: BookshelfRecommendationSection(books: books),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    Finder cardFor(String title) => find.ancestor(
      of: find.text(title),
      matching: find.byType(AppPressable),
    );

    final leftFirst = tester.getRect(cardFor('左一'));
    final rightFirst = tester.getRect(cardFor('右一'));
    final leftSecond = tester.getRect(cardFor('左二'));
    final rightSecond = tester.getRect(cardFor('右二'));

    expect(rightFirst.left - leftFirst.right, moreOrLessEquals(AppSpacing.md));
    expect(leftSecond.top - leftFirst.bottom, moreOrLessEquals(AppSpacing.md));
    expect(
      rightSecond.top - rightFirst.bottom,
      moreOrLessEquals(AppSpacing.md),
    );
    expect(rightSecond.top, lessThan(leftSecond.top));
  });
}
