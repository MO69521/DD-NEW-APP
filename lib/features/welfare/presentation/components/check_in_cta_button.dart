import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/app_gradient_cta_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 每日签到主 CTA（黄色扫光 + 呼吸缩放）。
///
/// 由「签到区块」与「首页签到弹窗」共用；文案分前后两段（如
/// `立即签到` + `+20能量`、`看视频` + `再领500星辰`）。
class CheckInCtaButton extends StatelessWidget {
  const CheckInCtaButton({
    super.key,
    required this.leadingLabel,
    required this.trailingLabel,
    this.onTap,
  });

  final String leadingLabel;
  final String trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppGradientCtaButton(
      gradientColors: const [
        AppWelfareColors.checkInCtaSolid,
        AppWelfareColors.checkInCtaSolid,
      ],
      height: AppSizes.welfareCheckInCtaHeight,
      borderRadius: AppRadius.welfareCheckInCta,
      sweepHighlight: AppWelfareColors.checkInCtaSweepHighlight,
      sweepEdge: AppWelfareColors.checkInCtaSweepEdge,
      loadingColor: AppWelfareColors.checkInCtaTextDark,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            leadingLabel,
            style: AppTextStyles.welfareCtaText.copyWith(
              color: AppWelfareColors.checkInCtaTextDark,
            ),
          ),
          const SizedBox(width: AppSpacing.xxsHalf),
          AppText(
            trailingLabel,
            style: AppTextStyles.welfareCtaText.copyWith(
              color: AppWelfareColors.checkInCtaTextDark,
            ),
          ),
        ],
      ),
    );
  }
}
