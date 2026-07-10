import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 每日签到主 CTA（黄色扫光 + 呼吸缩放）。
///
/// 由「签到区块」与「首页签到弹窗」共用；文案分前后两段（如
/// `立即签到` + `+20能量`、`看视频` + `再领500星辰`）。
class CheckInCtaButton extends StatefulWidget {
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
  State<CheckInCtaButton> createState() => _CheckInCtaButtonState();
}

class _CheckInCtaButtonState extends State<CheckInCtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _breathScale =
        Tween<double>(
          begin: AppSizes.membershipCtaBreathScaleMin,
          end: AppSizes.membershipCtaBreathScaleMax,
        ).animate(
          CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathScale,
      child: AppPressable(
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.welfareCheckInCta),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppWelfareColors.checkInCtaSolid,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(
                  child: SweepHighlightOverlay(
                    highlightColor: AppWelfareColors.checkInCtaSweepHighlight,
                    edgeColor: AppWelfareColors.checkInCtaSweepEdge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.welfareCheckInCtaPaddingHorizontal,
                    vertical: AppSizes.welfareCheckInCtaPaddingVertical,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        widget.leadingLabel,
                        style: AppTextStyles.welfareCtaText.copyWith(
                          color: AppWelfareColors.checkInCtaTextDark,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxsHalf),
                      AppText(
                        widget.trailingLabel,
                        style: AppTextStyles.welfareCtaText.copyWith(
                          color: AppWelfareColors.checkInCtaTextDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
