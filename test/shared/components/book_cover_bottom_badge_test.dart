import 'package:diandian_chuanshu/core/domain/entities/book_cover_bottom_badge.dart';
import 'package:diandian_chuanshu/core/theme/app_icon_assets.dart';
import 'package:diandian_chuanshu/shared/components/book_cover_bottom_badge.dart';
import 'package:diandian_chuanshu/shared/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('热度标签显示通用火花图标和数值', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookCoverBottomBadgeView(
            badge: BookCoverBottomBadge(
              type: BookCoverBottomBadgeType.popularity,
              label: '72.0万',
            ),
          ),
        ),
      ),
    );

    expect(find.text('72.0万'), findsOneWidget);
    final icon = tester.widget<AppAssetImage>(find.byType(AppAssetImage));
    expect(icon.assetPath, AppIconAssets.hotFlame);
  });

  testWidgets('运营文案标签不显示火花图标', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookCoverBottomBadgeView(
            badge: BookCoverBottomBadge(
              type: BookCoverBottomBadgeType.promotion,
              label: '连续更新15周',
            ),
          ),
        ),
      ),
    );

    expect(find.text('连续更新15周'), findsOneWidget);
    expect(find.byType(AppAssetImage), findsNothing);
  });
}
