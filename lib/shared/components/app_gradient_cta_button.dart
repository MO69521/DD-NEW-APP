import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';
import 'liquid_sweep_cta_clip.dart';
import 'sweep_highlight_overlay.dart';

/// L2 — 渐变 CTA 按钮：渐变底 + 循环扫光 + 呼吸缩放 + 加载态。
///
/// 会员开通、福利「立即签到」、签到成功「VIP 再领取」等强动效 CTA 统一复用，
/// 各处仅通过参数传入自己的渐变色 / 高度 / 圆角 / 扫光色,视觉保持不变。
/// 加载态显示环形进度并停止缩放 / 扫光。
class AppGradientCtaButton extends StatefulWidget {
  const AppGradientCtaButton({
    super.key,
    required this.child,
    required this.gradientColors,
    required this.height,
    required this.borderRadius,
    required this.sweepHighlight,
    required this.sweepEdge,
    required this.loadingColor,
    this.onTap,
    this.isLoading = false,
    this.borderColor,
  });

  final Widget child;
  final List<Color> gradientColors;
  final double height;
  final double borderRadius;
  final Color sweepHighlight;
  final Color sweepEdge;
  final Color loadingColor;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? borderColor;

  @override
  State<AppGradientCtaButton> createState() => _AppGradientCtaButtonState();
}

class _AppGradientCtaButtonState extends State<AppGradientCtaButton>
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
    );
    _sweepController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaSweep,
    );
    _breathScale = Tween<double>(
      begin: AppSizes.membershipCtaBreathScaleMin,
      end: AppSizes.membershipCtaBreathScaleMax,
    ).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    _syncAnimations();
  }

  @override
  void didUpdateWidget(covariant AppGradientCtaButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      _syncAnimations();
    }
  }

  void _syncAnimations() {
    if (widget.isLoading) {
      _breathController
        ..stop()
        ..value = 0;
      _sweepController
        ..stop()
        ..value = 0;
      return;
    }
    if (!_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
    if (!_sweepController.isAnimating) {
      _sweepController.repeat();
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    _sweepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxScale = AppSizes.membershipCtaBreathScaleMax;
    final ctaHeight = widget.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final horizontalInset = maxWidth * (maxScale - 1) / 2;
        final verticalInset = ctaHeight * (maxScale - 1) / 2;
        final innerWidth = maxWidth - horizontalInset * 2;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalInset,
            vertical: verticalInset,
          ),
          child: ScaleTransition(
            scale: _breathScale,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: widget.isLoading ? null : widget.onTap,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: innerWidth,
                height: ctaHeight,
                child: LiquidSweepCtaClip(
                  progress: _sweepController,
                  borderRadius: widget.borderRadius,
                  gradientColors: widget.gradientColors,
                  borderColor: widget.borderColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: widget.gradientColors,
                            ),
                          ),
                        ),
                      ),
                      if (!widget.isLoading)
                        Positioned.fill(
                          child: SweepHighlightOverlay(
                            highlightColor: widget.sweepHighlight,
                            edgeColor: widget.sweepEdge,
                            progress: _sweepController,
                            slant: -0.16,
                            softEdges: true,
                          ),
                        ),
                      if (widget.isLoading)
                        SizedBox(
                          width: AppSizes.buttonLoadingIndicatorSize,
                          height: AppSizes.buttonLoadingIndicatorSize,
                          child: CircularProgressIndicator(
                            strokeWidth:
                                AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                            color: widget.loadingColor,
                          ),
                        )
                      else
                        widget.child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
