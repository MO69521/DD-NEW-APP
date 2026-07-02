import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — 顶/底 Chrome 区域毛玻璃背景（半透明 + backdrop blur）。
class AppBlurredChromeBar extends StatelessWidget {
  const AppBlurredChromeBar({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurSigma = AppSizes.chromeBarBlurSigma,
    this.scrimColor = AppColors.chromeBarScrim,
  });

  final Widget child;
  final bool enabled;
  final double blurSigma;
  final Color scrimColor;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(color: scrimColor),
          child: child,
        ),
      ),
    );
  }
}
