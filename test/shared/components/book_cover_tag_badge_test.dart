import 'package:diandian_chuanshu/core/domain/entities/book_cover_tag.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/core/theme/app_spacing.dart';
import 'package:diandian_chuanshu/core/theme/app_text_styles.dart';
import 'package:diandian_chuanshu/shared/components/book_cover_tag_badge.dart';
import 'package:diandian_chuanshu/shared/widgets/app_text.dart';
import 'package:diandian_chuanshu/shared/widgets/book_cover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('封面状态角标使用 10px 文字和紧凑内边距', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: BookCoverTagBadge(tag: BookCoverTag.updated)),
      ),
    );

    expect(find.text('更新'), findsOneWidget);
    final label = tester.widget<AppText>(find.byType(AppText));
    expect(label.style.fontSize, AppFontSizes.xs);

    final padding = tester.widget<Padding>(
      find.descendant(
        of: find.byType(BookCoverTagBadge),
        matching: find.byType(Padding),
      ),
    );
    expect(
      padding.padding,
      const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxs,
        vertical: AppSpacing.xxsHalf,
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(
      find.descendant(
        of: find.byType(BookCoverTagBadge),
        matching: find.byType(DecoratedBox),
      ),
    );
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.border!.top.color, AppColors.bookCoverTagUpdatedBorder);
    expect(AppColors.bookCoverTagUpdatedBorder, AppColors.white04);
  });

  testWidgets('封面状态角标紧贴右上角并保留 4px 安全留白', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookCover(
            assetPath: 'assets/covers/cover_01.png',
            width: 100,
            height: 140,
            topEndBadge: BookCoverTagBadge(tag: BookCoverTag.updated),
          ),
        ),
      ),
    );

    final positioned = tester.widget<Positioned>(
      find.descendant(
        of: find.byType(BookCover),
        matching: find.byType(Positioned),
      ),
    );
    expect(positioned.top, AppSizes.bookCoverTagInsetTop);
    expect(positioned.right, AppSizes.bookCoverTagInsetRight);
    expect(AppSizes.bookCoverTagInsetTop, AppSpacing.xxs);
    expect(AppSizes.bookCoverTagInsetRight, AppSpacing.xxs);
  });
}
