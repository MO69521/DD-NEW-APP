import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

/// L2 — Lottie 动画统一封装。
///
/// 传入 `assets/lottie/**/*.json` 资源路径即可播放；默认循环播放、按内容尺寸自适应。
/// 资源需先放入 `assets/lottie/` 并在 `pubspec.yaml` 声明（该目录已声明）。
///
/// 底栏选中等「播一次停末帧」场景：传入 [controller] + [onLoaded] 自行驱动进度。
class AppLottie extends StatelessWidget {
  const AppLottie({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
    this.controller,
    this.onLoaded,
  });

  final String asset;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;
  final AnimationController? controller;
  final void Function(LottieComposition composition)? onLoaded;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: controller == null && repeat,
      fit: fit,
      controller: controller,
      onLoaded: onLoaded,
    );
  }
}
