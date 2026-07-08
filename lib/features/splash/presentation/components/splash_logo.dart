import 'package:flutter/material.dart';

/// 启动页整屏插画（满屏铺满）。
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  static const String _assetPath = 'assets/images/splash/splash_screen.png';

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(_assetPath, fit: BoxFit.cover),
    );
  }
}
