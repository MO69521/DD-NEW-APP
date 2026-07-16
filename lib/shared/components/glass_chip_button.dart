import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme_context.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../widgets/app_pressable.dart';

/// Level 2 — 玻璃态胶囊按钮/搜索框容器。
class GlassChipButton extends StatelessWidget {
  const GlassChipButton({
    super.key,
    required this.child,
    this.onTap,
    this.expanded = false,
    this.height = AppSizes.searchBarHeight,
    this.blur = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool expanded;
  final double height;
  final bool blur;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final borderRadius = BorderRadius.circular(AppRadius.searchBar);

    Widget container = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.surfaceGlass,
        borderRadius: borderRadius,
        border: Border.all(color: colors.borderGlass, width: AppSizes.hairline),
      ),
      child: child,
    );

    if (blur) {
      container = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSizes.glassBlurSigma,
            sigmaY: AppSizes.glassBlurSigma,
          ),
          child: container,
        ),
      );
    }

    final chip = onTap != null
        ? AppPressable(onTap: onTap, child: container)
        : container;

    return expanded ? Expanded(child: chip) : chip;
  }
}
