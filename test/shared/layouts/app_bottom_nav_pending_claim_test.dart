import 'package:diandian_chuanshu/core/constants/main_tab_config.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/shared/layouts/app_bottom_nav.dart';
import 'package:diandian_chuanshu/shared/layouts/main_tab_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('实心底栏仅绘制主题化的 0.5px 顶部分割线', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(bottomNavigationBar: AppBottomNav())),
    );

    final divider = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('bottom-nav-top-divider')),
    );
    final decoration = divider.decoration as BoxDecoration;
    final border = decoration.border! as Border;

    expect(border.top.color, AppColors.bottomNavTopDivider);
    expect(border.top.width, AppSizes.hairline);
    expect(border.left, BorderSide.none);
    expect(border.right, BorderSide.none);
    expect(border.bottom, BorderSide.none);
  });

  testWidgets('福利未选中时展示服务端待领取能量', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(
            selectedIndex: MainTabConfig.bookstoreIndex,
            pendingClaimEnergy: 585,
          ),
        ),
      ),
    );

    expect(find.text('585能量待领取'), findsOneWidget);
  });

  testWidgets('选中福利或待领取为零时隐藏标签', (tester) async {
    Future<void> pumpNav({required int selectedIndex, required int energy}) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: AppBottomNav(
              selectedIndex: selectedIndex,
              pendingClaimEnergy: energy,
            ),
          ),
        ),
      );
    }

    await pumpNav(selectedIndex: MainTabConfig.welfareIndex, energy: 585);
    expect(find.text('585能量待领取'), findsNothing);

    await pumpNav(selectedIndex: MainTabConfig.bookstoreIndex, energy: 0);
    expect(find.text('0能量待领取'), findsNothing);
  });

  testWidgets('首次进入福利时渐隐且本会话不再显示', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainTabShell(
          pendingClaimEnergy: 585,
          pages: [
            SizedBox.expand(),
            SizedBox.expand(),
            SizedBox.expand(),
            SizedBox.expand(),
          ],
        ),
      ),
    );

    expect(find.text('585能量待领取'), findsOneWidget);

    await tester.tap(find.text('福利'));
    await tester.pump();
    expect(find.text('585能量待领取'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.text('585能量待领取'), findsNothing);

    await tester.tap(find.text('书城'));
    await tester.pumpAndSettle();
    expect(find.text('585能量待领取'), findsNothing);
  });
}
