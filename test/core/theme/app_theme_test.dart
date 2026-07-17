import 'package:diandian_chuanshu/core/theme/app_brand_colors.dart';
import 'package:diandian_chuanshu/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('当前 Material 亮度跟随编译主题', () {
    const expected = AppBrandColors.isLightExperiment
        ? Brightness.light
        : Brightness.dark;

    expect(AppTheme.current.brightness, expected);
  });
}
