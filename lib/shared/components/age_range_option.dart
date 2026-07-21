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
/// 共用，保证选项高度 / 选中样式一致：选中态 8% 主色底 + 强调文字档**加粗**字
/// （accentText：浅色态深黄/深粉、深色态亮黄；yellow_light 增加黄色描边），
/// 未选态浅色填充底 + 细描边 + 主文字色（三主题适配）。
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
        key: ValueKey('age-range-option-decoration-$label'),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.segmentedSelectedFill
              : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected
                ? AppColors.ageRangeSelectedBorder
                : AppColors.borderSubtle,
            width: selected ? AppSizes.borderWidthEmphasis : AppSizes.hairline,
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
                color: selected ? AppColors.accentText : AppColors.textPrimary,
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
