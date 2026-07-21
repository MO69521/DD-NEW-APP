import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/shared/components/app_blurred_chrome_bar.dart';
import 'package:diandian_chuanshu/shared/layouts/app_page_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('浅色主题顶栏默认启用白色 Chrome 底', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppPageChrome(
          topBar: SizedBox(height: 44, child: Text('tabs')),
          body: ColoredBox(color: Color(0xFFEEEEEE)),
        ),
      ),
    );

    final chrome = tester.widget<AppBlurredChromeBar>(
      find.byType(AppBlurredChromeBar),
    );
    expect(chrome.scrimColor, AppColors.topChromeBarScrolledScrim);

    if (AppBrandColors.isLightExperiment) {
      expect(chrome.enabled, isTrue);
      expect(AppColors.topChromeBarScrolledScrim, AppColors.white100);
    } else {
      // yellow_dark：未滚动时不铺底。
      expect(chrome.enabled, isFalse);
    }
  });
}
