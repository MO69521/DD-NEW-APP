import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_page_header.dart';
import 'package:diandian_chuanshu/shared/components/app_top_bar_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('福利页说明图标按深浅主题取色', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: WelfarePageHeader())),
    );

    final button = tester.widget<AppTopBarIconButton>(
      find.byType(AppTopBarIconButton),
    );

    expect(
      button.iconColor,
      AppBrandColors.isLightExperiment ? AppColors.black100 : AppColors.white60,
    );
  });
}
