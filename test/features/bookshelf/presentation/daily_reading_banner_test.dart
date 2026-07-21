import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/core/theme/app_text_styles.dart';
import 'package:diandian_chuanshu/features/bookshelf/presentation/components/daily_reading_banner.dart';
import 'package:diandian_chuanshu/shared/widgets/animated_count_text.dart';
import 'package:diandian_chuanshu/shared/widgets/app_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('今日阅读横幅无小熊、无底填充且分钟标红', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DailyReadingBanner(
            todayReadingMinutes: 23,
            onClaimWelfareTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('今日已阅读 '), findsOneWidget);
    expect(find.text(' 分钟'), findsOneWidget);
    expect(find.text('领福利'), findsOneWidget);
    expect(
      tester.getSize(find.byType(DailyReadingBanner)).height,
      AppSizes.bookshelfClaimWelfareCtaHeight,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppAssetImage &&
            widget.assetPath.contains('reading_bear'),
      ),
      findsNothing,
    );

    final count = tester.widget<AnimatedCountText>(
      find.byType(AnimatedCountText),
    );
    expect(count.style?.color, AppColors.bookshelfReadingMinutes);
    expect(
      AppTextStyles.bookshelfReadingMinutes.color,
      AppColors.bookshelfReadingMinutes,
    );
  });
}
