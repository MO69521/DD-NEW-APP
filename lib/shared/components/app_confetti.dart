import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';

/// L2 — 礼花彩带庆祝动效层。
///
/// 放入全屏 Stack 顶层并配 [IgnorePointer]：创建后自动从顶部左右两角
/// 向中心下方喷发多彩彩带纸屑，[duration] 后停止（用于签到成功等庆祝时刻）。
class AppConfetti extends StatefulWidget {
  const AppConfetti({super.key, this.duration = AppDurations.confettiBurst});

  final Duration duration;

  @override
  State<AppConfetti> createState() => _AppConfettiState();
}

class _AppConfettiState extends State<AppConfetti> {
  // 粒子物理与彩带尺寸（喷发行为参数，非样式 token）。
  // 单次迸发：短喷发窗口内高频喷一波，随后靠重力飘落。
  static const double _minBlastForce = 30;
  static const double _maxBlastForce = 100;
  static const double _gravity = 0.35;
  static const double _emissionFrequency = 0.6;
  static const int _particlesPerEmit = 30;
  static const Size _particleMinSize = Size(6, 4);
  static const Size _particleMaxSize = Size(10, 16);

  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _emitter(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _controller,
        // 向四周发散喷射（而非单一方向的线条），随后受重力回落。
        blastDirectionality: BlastDirectionality.explosive,
        emissionFrequency: _emissionFrequency,
        numberOfParticles: _particlesPerEmit,
        minBlastForce: _minBlastForce,
        maxBlastForce: _maxBlastForce,
        gravity: _gravity,
        minimumSize: _particleMinSize,
        maximumSize: _particleMaxSize,
        shouldLoop: false,
        colors: AppColors.confettiPalette,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 屏幕中部左右两侧各一处，向四周发散迸射后回落。
        _emitter(Alignment.centerLeft),
        _emitter(Alignment.centerRight),
      ],
    );
  }
}
