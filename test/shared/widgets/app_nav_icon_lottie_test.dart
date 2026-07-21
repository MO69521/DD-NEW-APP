import 'package:diandian_chuanshu/core/constants/main_tab_config.dart';
import 'package:diandian_chuanshu/shared/components/app_lottie.dart';
import 'package:diandian_chuanshu/shared/widgets/app_asset_image.dart';
import 'package:diandian_chuanshu/shared/widgets/app_nav_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const lottieItem = MainTabItem(
    label: '书城',
    iconAsset: 'assets/images/bottom_nav/yellow_light/bookcity_nor.webp',
    selectedLottieAsset:
        'assets/lottie/bottom_nav/yellow_light/book_city/book_city.json',
  );

  testWidgets('Lottie Tab：未选中显示静态图，选中显示 AppLottie', (tester) async {
    var selected = false;
    var tapEpoch = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Center(
                child: GestureDetector(
                  onTap: () => setState(() {
                    selected = true;
                    tapEpoch++;
                  }),
                  child: AppNavIcon(
                    item: lottieItem,
                    isSelected: selected,
                    tapEpoch: tapEpoch,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(AppAssetImage), findsOneWidget);
    expect(find.byType(AppLottie), findsNothing);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(AppLottie), findsOneWidget);
  });
}
