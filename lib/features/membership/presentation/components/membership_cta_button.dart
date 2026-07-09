import 'package:flutter/material.dart';

import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/components/app_gradient_cta_button.dart';

/// L3 — 会员金色 CTA 按钮：金色渐变底 + 循环扫光 + 呼吸缩放动画。
///
/// 会员开通区与会员特权详情页统一复用；委派共享 [AppGradientCtaButton]，仅注入
/// 会员金渐变 / 高度 / 圆角 / 扫光色。[child] 为按钮内容（文案 / 价格行等）。
class MembershipCtaButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AppGradientCtaButton(
      gradientColors: const [
        AppMembershipColors.ctaGradientStart,
        AppMembershipColors.ctaGradientEnd,
      ],
      height: AppSizes.membershipCtaHeight,
      borderRadius: AppRadius.membershipCta,
      sweepHighlight: AppMembershipColors.ctaSweepHighlight,
      sweepEdge: AppMembershipColors.ctaSweepEdge,
      loadingColor: AppMembershipColors.ctaText,
      isLoading: isLoading,
      onTap: onTap,
      child: child,
    );
  }
}
