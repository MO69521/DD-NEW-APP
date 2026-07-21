part of 'check_in_success_dialog.dart';

/// VIP 再领取按钮：粉色渐变胶囊 + 扫光高亮 + 呼吸缩放动画。
class _VipRewardButton extends StatefulWidget {
  const _VipRewardButton({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_VipRewardButton> createState() => _VipRewardButtonState();
}

class _VipRewardButtonState extends State<_VipRewardButton>
    with TickerProviderStateMixin {
  late final AnimationController _breathController;
  late final AnimationController _sweepController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    )..repeat(reverse: true);
    _sweepController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaSweep,
    )..repeat();
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
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathScale,
      child: AppPressable(
        onTap: widget.onTap,
        child: LiquidSweepCtaClip(
          progress: _sweepController,
          borderRadius: AppRadius.full,
          gradientColors: const [
            AppWelfareColors.vipBannerGradientStart,
            AppWelfareColors.vipBannerGradientEnd,
          ],
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppWelfareColors.vipBannerGradientStart,
                  AppWelfareColors.vipBannerGradientEnd,
                ],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: SweepHighlightOverlay(
                      progress: _sweepController,
                      slant: -0.16,
                      softEdges: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.buttonPaddingHNormal,
                      vertical: AppSizes.buttonPaddingVNormal,
                    ),
                    child: AppText(
                      widget.label,
                      style: AppTextStyles.buttonLabel16.copyWith(
                        color: AppWelfareColors.vipCtaText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
