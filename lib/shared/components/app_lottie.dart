import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

/// L2 — Lottie 动画统一封装。
///
/// 传入 `assets/lottie/*.json` 资源路径即可播放；默认循环播放、按内容尺寸自适应。
/// 用于空状态 / 加载 / 庆祝等需要矢量帧动画的场景。资源需先放入 `assets/lottie/`
/// 并在 `pubspec.yaml` 声明（该目录已声明）。
///
/// 说明：当前仓库尚无内置 Lottie JSON；接入具体动画时把资源放进 `assets/lottie/`，
/// 再在目标页用本组件引用即可。
class AppLottie extends StatelessWidget {
  const AppLottie({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.repeat = true,
    this.fit = BoxFit.contain,
  });

  final String asset;
  final double? width;
  final double? height;
  final bool repeat;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: repeat,
      fit: fit,
    );
  }
}
