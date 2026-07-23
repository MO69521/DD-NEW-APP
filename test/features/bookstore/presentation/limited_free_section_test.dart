import 'package:diandian_chuanshu/core/domain/entities/book.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/core/theme/app_theme_assets.dart';
import 'package:diandian_chuanshu/features/bookstore/presentation/components/limited_free_section.dart';
import 'package:diandian_chuanshu/shared/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('限时免费区块顶部叠 FREE 彩头', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LimitedFreeSection(
            books: [
              Book(
                id: '1',
                title: '测试书',
                category: '测试',
                coverAsset: 'assets/covers/cover_01.png',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('限时免费'), findsOneWidget);
    expect(find.byType(AspectRatio), findsWidgets);
    final bg = tester.widget<AppAssetImage>(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppAssetImage &&
            widget.assetPath == AppThemeAssets.limitedFreeHeaderBg,
      ),
    );
    expect(bg.fit, BoxFit.cover);

    final aspect = tester
        .widgetList<AspectRatio>(find.byType(AspectRatio))
        .firstWhere(
          (widget) =>
              widget.aspectRatio == AppSizes.limitedFreeHeaderBgAspectRatio,
        );
    expect(aspect.aspectRatio, AppSizes.limitedFreeHeaderBgAspectRatio);
  });
}
