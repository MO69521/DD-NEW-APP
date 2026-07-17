import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_membership_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_palette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('会员套餐卡颜色按深浅主题解析', () {
    const expectedSelectedBg = AppBrandColors.isLightExperiment
        ? 0x4DFFE794
        : 0x14FFE794;
    const expectedUnselectedBg = AppBrandColors.isLightExperiment
        ? AppColors.surfaceCard
        : AppColors.white04;
    const expectedTextStart = AppBrandColors.isLightExperiment
        ? AppPalette.brown800
        : AppMembershipColors.planSelectedGoldStart;
    const expectedTextEnd = AppBrandColors.isLightExperiment
        ? AppPalette.brown800
        : AppMembershipColors.planSelectedGoldEnd;

    expect(AppMembershipColors.planSelectedBg.toARGB32(), expectedSelectedBg);
    expect(AppMembershipColors.planUnselectedBg, expectedUnselectedBg);
    expect(AppMembershipColors.planSelectedTextStart, expectedTextStart);
    expect(AppMembershipColors.planSelectedTextEnd, expectedTextEnd);
  });
}
