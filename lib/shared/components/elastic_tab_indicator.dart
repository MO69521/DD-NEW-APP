import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — Tab 指示条：位置平滑移动，沿主轴长度先拉长再快速回弹。
///
/// [axis] 默认横向（黄色下划线，长度=宽度）；传 [Axis.vertical] 用作竖向轨道
/// 左侧指示条（长度=高度）。等宽 Tab 传 [slotWidth] + [slotPitch]（均分排布）；
/// 变宽 Tab（按文案实测）传 [centers]（各 Tab 中心点相对偏移），二者择一。
class ElasticTabIndicator extends StatefulWidget {
  const ElasticTabIndicator({
    super.key,
    required this.selectedIndex,
    this.axis = Axis.horizontal,
    this.slotWidth,
    this.slotPitch,
    this.centers,
    this.width = AppSizes.tabIndicatorWidth,
    this.height = AppSizes.tabIndicatorHeight,
    this.color = AppColors.accentYellow,
    this.radius = AppRadius.md,
    this.duration = AppDurations.normal,
    this.stretchFactor = 0.75,
    this.crossOffset = 0,
    this.swipeProgress,
  }) : assert(
         centers != null || (slotWidth != null && slotPitch != null),
         'Provide either centers or slotWidth + slotPitch',
       );

  final int selectedIndex;

  /// 指示条排布主轴：横向 = 宽度拉伸的下划线；竖向 = 高度拉伸的侧边条。
  final Axis axis;

  /// 等宽模式：单个 Tab 槽宽 / 槽间距（含间隙）；竖向时为槽高 / 槽间距。
  final double? slotWidth;
  final double? slotPitch;

  /// 变宽模式：各 Tab 中心点相对偏移（实测），优先于等宽计算。
  final List<double>? centers;
  final double width;
  final double height;
  final Color color;
  final double radius;
  final Duration duration;
  final double stretchFactor;

  /// 交叉轴偏移：横向为距底边距离（`bottom`），竖向为距左边距离（`left`）。
  final double crossOffset;
  final ValueListenable<double>? swipeProgress;

  @override
  State<ElasticTabIndicator> createState() => _ElasticTabIndicatorState();
}

class _ElasticTabIndicatorState extends State<ElasticTabIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _fromIndex;
  late int _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.selectedIndex;
    _toIndex = widget.selectedIndex;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant ElasticTabIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    if (widget.swipeProgress != null) return;
    _fromIndex = oldWidget.selectedIndex;
    _toIndex = widget.selectedIndex;
    _controller
      ..duration = widget.duration
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.swipeProgress ?? _controller,
      builder: (context, child) {
        final progressData = _progressData();
        final stretch =
            1 + widget.stretchFactor * progressData.stretch.clamp(0, 1);
        final center = progressData.center;
        final isHorizontal = widget.axis == Axis.horizontal;
        final boxWidth = isHorizontal ? widget.width * stretch : widget.width;
        final boxHeight = isHorizontal ? widget.height : widget.height * stretch;

        return Positioned(
          left: isHorizontal ? center - boxWidth / 2 : widget.crossOffset,
          bottom: isHorizontal ? widget.crossOffset : null,
          top: isHorizontal ? null : center - boxHeight / 2,
          child: Container(
            width: boxWidth,
            height: boxHeight,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        );
      },
    );
  }

  ({double center, double stretch}) _progressData() {
    final swipeProgress = widget.swipeProgress?.value;
    if (swipeProgress != null) {
      final clampedProgress = swipeProgress.clamp(0.0, double.infinity);
      final fromIndex = clampedProgress.floor();
      final toIndex = clampedProgress.ceil();
      final localProgress = clampedProgress - fromIndex;
      final center =
          _indicatorCenter(fromIndex) +
          (_indicatorCenter(toIndex) - _indicatorCenter(fromIndex)) *
              localProgress;
      final stretch = localProgress <= 0.5
          ? localProgress / 0.5
          : (1 - localProgress) / 0.5;
      return (center: center, stretch: stretch);
    }

    final rawProgress = _controller.value;
    final progress = Curves.easeOutCubic.transform(rawProgress);
    final center =
        _indicatorCenter(_fromIndex) +
        (_indicatorCenter(_toIndex) - _indicatorCenter(_fromIndex)) * progress;
    return (center: center, stretch: _stretchProgress(rawProgress));
  }

  double _indicatorCenter(int index) {
    final centers = widget.centers;
    if (centers != null) {
      if (centers.isEmpty) return 0;
      return centers[index.clamp(0, centers.length - 1)];
    }
    return index * widget.slotPitch! + widget.slotWidth! / 2;
  }

  double _stretchProgress(double progress) {
    if (progress <= 0.35) {
      return Curves.easeOutCubic.transform(progress / 0.35);
    }
    if (progress <= 0.62) {
      return 1 - Curves.easeInCubic.transform((progress - 0.35) / 0.27);
    }
    return 0;
  }
}
