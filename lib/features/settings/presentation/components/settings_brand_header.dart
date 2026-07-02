import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 设置页品牌区：App 图标 + 名称 + 版本号。
class SettingsBrandHeader extends StatelessWidget {
  const SettingsBrandHeader({super.key, required this.appVersion});

  static const String _logoAssetPath = 'assets/images/splash/app_icon.png';

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Image.asset(
            _logoAssetPath,
            width: AppSizes.settingsLogoSize,
            height: AppSizes.settingsLogoSize,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppText(
          AppConstants.appName,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        AppText(
          appVersion,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDarkMuted,
          ),
        ),
      ],
    );
  }
}
