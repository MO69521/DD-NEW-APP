import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

/// 启动页整屏插画（满屏铺满）。
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  static const String _backgroundAssetPath =
      'assets/images/splash/splash_screen.png';
  static const String _brandLogoAssetPath =
      'assets/images/splash/brand_logo.webp';

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(_backgroundAssetPath, fit: BoxFit.cover),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final logoWidth = math.min(
                  constraints.maxWidth * AppSizes.splashLogoWidthRatio,
                  AppSizes.splashLogoSize,
                );
                return Center(
                  child: Image.asset(
                    _brandLogoAssetPath,
                    width: logoWidth,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
