import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_membership_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('会员 Hero 极光仅在 yellow_light 增强', () {
    const expectedOpacity = AppBrandColors.themeId == 'yellow_light'
        ? 0.45
        : 0.26;

    expect(AppMembershipColors.heroAuroraOpacity, expectedOpacity);
  });
}
