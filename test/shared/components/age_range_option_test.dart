import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/shared/components/age_range_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('年龄选中项按主题显示强调描边', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AgeRangeOption(label: '18-25岁', selected: true, onTap: () {}),
      ),
    );

    final box = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('age-range-option-decoration-18-25岁')),
    );
    final decoration = box.decoration as BoxDecoration;
    final border = decoration.border! as Border;

    expect(
      border.top.color,
      AppBrandColors.isYellowLight
          ? AppColors.primary
          : AppColors.segmentedSelectedBorder,
    );
    expect(border.top.width, AppSizes.borderWidthEmphasis);
  });
}
