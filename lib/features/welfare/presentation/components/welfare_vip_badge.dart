import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 福利任务 VIP 标签。
class WelfareVipBadge extends StatelessWidget {
  const WelfareVipBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.welfareTaskVipBadgeHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppWelfareColors.vipBannerGradientStart,
            AppWelfareColors.vipBannerGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Center(
        child: AppText(
          label,
          style: AppTextStyles.captionMd.copyWith(
            color: AppWelfareColors.taskVipGradientBadgeText,
          ),
        ),
      ),
    );
  }
}
