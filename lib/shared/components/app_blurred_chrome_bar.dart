import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — 顶/底 Chrome 区域背景（可选 backdrop blur + 可选底图纹理）。
///
/// - [enabled]：`false` 时不绘制背景，仅渲染 [child]。
/// - [blurEnabled]：`false` 时跳过 [BackdropFilter]，仅用 [scrimColor]（及可选纹理）实心铺底。
/// - [textureAsset]：铺满底栏背景图，[scrimColor] 叠在纹理之上；为 `null` 时仅 [scrimColor]。
class AppBlurredChromeBar extends StatelessWidget {
  const AppBlurredChromeBar({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurEnabled = true,
    this.blurSigma = AppSizes.chromeBarBlurSigma,
    this.scrimColor = AppColors.chromeBarScrim,
    this.textureAsset,
  });

  final Widget child;
  final bool enabled;

  /// 是否对背后内容做 backdrop blur；底栏等需纯色不透明底时置 `false`。
  final bool blurEnabled;
  final double blurSigma;
  final Color scrimColor;

  /// 背景纹理资源路径（如 `AppThemeAssets.bottomNavTexture`）；`null` 时纯色底。
  final String? textureAsset;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final background = _buildBackground();

    if (!blurEnabled) return background;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: background,
      ),
    );
  }

  Widget _buildBackground() {
    final hasTexture = textureAsset != null && textureAsset!.isNotEmpty;

    if (hasTexture) {
      return DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(textureAsset!),
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: scrimColor),
          child: child,
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: scrimColor),
      child: child,
    );
  }
}
