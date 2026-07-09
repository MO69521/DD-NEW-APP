import 'package:flutter/widgets.dart';

import '../../core/theme/app_sizes.dart';

/// L1 — 头图下拉拉伸（视差）：滚动越过顶部（负 overscroll）时，头图按
/// [AppSizes.heroParallaxFactor] 比例放大，形成"下拉放大头图"的视差效果。
///
/// 需配合可产生负 overscroll 的物理（如 [BouncingScrollPhysics]）与传入的
/// [controller]（挂在同一个可滚动容器上）。[baseHeight] 为头图基准高度，
/// 用于把 overscroll 像素换算成放大比例。
class OverscrollStretch extends StatelessWidget {
  const OverscrollStretch({
    super.key,
    required this.controller,
    required this.baseHeight,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  final ScrollController controller;
  final double baseHeight;
  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        var scale = 1.0;
        if (controller.hasClients && baseHeight > 0) {
          final pixels = controller.position.pixels;
          if (pixels < 0) {
            final fraction = (-pixels / baseHeight).clamp(0.0, 1.0);
            scale = 1 + fraction * AppSizes.heroParallaxFactor;
          }
        }
        return Transform.scale(
          scale: scale,
          alignment: alignment,
          child: child,
        );
      },
      child: child,
    );
  }
}
