import 'package:diandian_chuanshu/core/theme/app_durations.dart';
import 'package:diandian_chuanshu/core/theme/app_text_styles.dart';
import 'package:diandian_chuanshu/features/welfare/presentation/components/welfare_vip_title_rotator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('福利横幅标题每 3 秒向下一条文案切换', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: WelfareVipTitleRotator(
            titles: const ['今日福利中心最高可领200能量', '今日福利中心最高可领1200星辰'],
            textStyle: AppTextStyles.welfareVipBannerLabel,
          ),
        ),
      ),
    );

    final initialSize = tester.getSize(find.byType(WelfareVipTitleRotator));
    expect(
      find.byKey(const ValueKey<String>('今日福利中心最高可领200能量')),
      findsOneWidget,
    );

    await tester.pump(AppDurations.slow * 6);
    await tester.pump(AppDurations.normal + AppDurations.fast);

    expect(
      find.byKey(const ValueKey<String>('今日福利中心最高可领1200星辰')),
      findsOneWidget,
    );
    expect(tester.getSize(find.byType(WelfareVipTitleRotator)), initialSize);
  });
}
