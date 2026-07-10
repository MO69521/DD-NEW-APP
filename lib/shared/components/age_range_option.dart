import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// L2 组件 — 年龄段单选胶囊（整行）。
///
/// 新手弹窗（[OnboardingProfileDialog]）与偏好设置页（[ReadingPreferencesPage]）
/// 共用，保证选项高度 / 选中样式一致：选中态 8% 黄底 + 黄色**加粗**字（无描边），
/// 未选态卡片底 + 细描边 + 纯白字（不带透明度）。
class AgeRangeOption extends StatelessWidget {
  const AgeRangeOption({
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? AppColors.segmentedSelectedFill
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected
                ? AppColors.segmentedSelectedBorder
                : AppColors.borderGlass,
            width: AppSizes.hairline,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Center(
            child: AppText(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: selected
                    ? AppColors.accentYellow
                    : AppColors.textOnDark,
                fontWeight: selected ? AppFontWeights.semibold : null,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
