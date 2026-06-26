import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

/// 从 [BuildContext] 读取当前语义色方案。
extension AppThemeContext on BuildContext {
  AppColorScheme get appColors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.dark;
}
