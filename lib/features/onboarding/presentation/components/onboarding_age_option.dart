import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 年龄段选项（整行胶囊，选中黄底深字）。
class OnboardingAgeOption extends StatelessWidget {
  const OnboardingAgeOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.onboardingAgeSelected
              : AppColors.onboardingAgeUnselected,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AppText(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: selected
                ? AppColors.onboardingAgeSelectedText
                : AppColors.textOnDark,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
