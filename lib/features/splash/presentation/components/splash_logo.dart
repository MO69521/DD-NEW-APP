import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  static const String _assetPath = 'assets/images/splash/app_icon.png';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Image.asset(
        _assetPath,
        width: AppSizes.splashLogoSize,
        height: AppSizes.splashLogoSize,
        fit: BoxFit.cover,
      ),
    );
  }
}
