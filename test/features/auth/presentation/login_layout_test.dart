import 'package:diandian_chuanshu/core/config/app_theme_id.dart';
import 'package:diandian_chuanshu/core/theme/app_theme_assets.dart';
import 'package:diandian_chuanshu/features/auth/presentation/components/login_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('仅 yellow_light 登录页复用我的页默认 Hero', () {
    const expected = AppThemeId.assetPack == AppThemeId.yellowLight
        ? AppThemeAssets.profileHeroBackgroundDefault
        : 'assets/images/auth/${AppThemeId.assetPack}/login_top_bg.png';

    expect(LoginLayout.topBackgroundAsset, expected);
  });
}
