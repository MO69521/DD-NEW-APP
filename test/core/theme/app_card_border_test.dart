import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_palette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('卡片弱描边按三主题解析', () {
    const expected = AppBrandColors.themeId == 'yellow_light'
        ? AppPalette.neutralCool100
        : AppBrandColors.themeId == 'pink_light'
        ? AppPalette.pink75
        : AppPalette.whiteAlpha04;

    expect(AppColors.borderSubtle, expected);
    expect(AppColors.borderGlass, expected);
  });
}
