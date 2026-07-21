import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/shared/components/app_segmented_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('分段轨道底为极浅 surfaceSoft', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: AppSegmentedSwitch(
              itemCount: 3,
              selectedIndex: 0,
              onChanged: (_) {},
              itemBuilder: (context, index, isSelected) => Text('项$index'),
            ),
          ),
        ),
      ),
    );

    final track = tester
        .widgetList<Container>(find.byType(Container))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.color == AppColors.surfaceSoft);
    expect(track.color, AppColors.surfaceSoft);
  });

  testWidgets('分段选中为白底无描边，与年龄选项强调选中解耦', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: AppSegmentedSwitch(
              itemCount: 3,
              selectedIndex: 0,
              onChanged: (_) {},
              itemBuilder: (context, index, isSelected) => Text('项$index'),
            ),
          ),
        ),
      ),
    );

    final slider = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((box) => box.decoration)
        .whereType<BoxDecoration>()
        .firstWhere(
          (decoration) =>
              decoration.color == AppColors.segmentedSwitchSelectedFill &&
              decoration.border is Border,
        );
    final border = slider.border! as Border;

    expect(slider.color, AppColors.segmentedSwitchSelectedFill);
    expect(border.top.color, AppColors.segmentedSwitchSelectedBorder);
    expect(border.top.color, AppColors.white00);
    expect(border.top.width, AppSizes.borderWidthEmphasis);
    // 年龄选项仍保留强调选中描边 token，不受分段开关影响。
    expect(
      AppColors.ageRangeSelectedBorder,
      AppBrandColors.isYellowLight ? AppColors.primary : AppColors.white00,
    );
  });
}
