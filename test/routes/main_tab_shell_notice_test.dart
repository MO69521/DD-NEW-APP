import 'package:diandian_chuanshu/core/constants/main_tab_config.dart';
import 'package:diandian_chuanshu/core/domain/entities/user_basic_info.dart';
import 'package:diandian_chuanshu/core/services/service_locator.dart';
import 'package:diandian_chuanshu/routes/pages/main_tab_shell_page.dart';
import 'package:diandian_chuanshu/shared/layouts/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('复用主 Tab 页面时切到我的页并显示新的 Toast', (tester) async {
    ServiceLocator.onboarding.completeBasicInfo(
      gender: UserGender.female,
      ageRange: UserAgeRange.age18to25,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: MainTabShellPage(initialIndex: MainTabConfig.bookstoreIndex),
      ),
    );
    await tester.pump();

    await tester.pumpWidget(
      const MaterialApp(
        home: MainTabShellPage(
          initialIndex: MainTabConfig.profileIndex,
          initialToastMessage: '青少年模式已开启',
          initialToastEventId: 'teen-mode-enabled-1',
        ),
      ),
    );
    await tester.pump();

    final bottomNav = tester.widget<AppBottomNav>(find.byType(AppBottomNav));
    expect(bottomNav.selectedIndex, MainTabConfig.profileIndex);
    expect(find.text('青少年模式已开启'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
