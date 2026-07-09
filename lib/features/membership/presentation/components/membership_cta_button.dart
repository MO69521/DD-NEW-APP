import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/components/sweep_highlight_overlay.dart';

/// L3 — 会员金色 CTA 按钮：金色渐变底 + 循环扫光 + 呼吸缩放动画。
///
/// 会员开通区与会员特权详情页统一复用；[child] 为按钮内容（文案 / 价格行等），
/// 加载态显示环形进度并停止缩放 / 扫光。
class MembershipCtaButton extends StatefulWidget {
  const MembershipCtaButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onTap,
  });

  final Widget child;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  State<MembershipCtaButton> createState() => _MembershipCtaButtonState();
}

class _MembershipCtaButtonState extends State<MembershipCtaButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;
  late final Animation<double> _breathScale;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: AppDurations.membershipCtaBreath,
    );
    _breathScale = Tween<double>(
      begin: AppSizes.membershipCtaBreathScaleMin,
      end: AppSizes.membershipCtaBreathScaleMax,
    ).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOut,
      ),
    );
    _syncAnimations();
  }

  @override
  void didUpdateWidget(covariant MembershipCtaButton oldWidget) {
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
      return;
    }

    if (!_breathController.isAnimating) {
      _breathController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxScale = AppSizes.membershipCtaBreathScaleMax;
    final ctaHeight = AppSizes.membershipCtaHeight;

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.membershipCta),
                child: SizedBox(
                  width: innerWidth,
                  height: ctaHeight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppMembershipColors.ctaGradientStart,
                              AppMembershipColors.ctaGradientEnd,
                            ],
                          ),
                        ),
                        child: SizedBox.expand(),
                      ),
                      if (!widget.isLoading)
                        const Positioned.fill(
                          child: SweepHighlightOverlay(
                            highlightColor: AppMembershipColors.ctaSweepHighlight,
                            edgeColor: AppMembershipColors.ctaSweepEdge,
                          ),
                        ),
                      if (widget.isLoading)
                        const SizedBox(
                          width: AppSizes.buttonLoadingIndicatorSize,
                          height: AppSizes.buttonLoadingIndicatorSize,
                          child: CircularProgressIndicator(
                            strokeWidth:
                                AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                            color: AppMembershipColors.ctaText,
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
