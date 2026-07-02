import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — 横向 Tab 指示器：位置平滑移动，宽度先拉长再快速回弹。
class ElasticTabIndicator extends StatefulWidget {
  const ElasticTabIndicator({
    super.key,
    required this.selectedIndex,
    required this.slotWidth,
    required this.slotPitch,
    this.width = AppSizes.tabIndicatorWidth,
    this.height = AppSizes.tabIndicatorHeight,
    this.color = AppColors.accentYellow,
    this.radius = AppRadius.md,
    this.duration = AppDurations.normal,
    this.stretchFactor = 0.75,
    this.bottom = 0,
  });

  final int selectedIndex;
  final double slotWidth;
  final double slotPitch;
  final double width;
  final double height;
  final Color color;
  final double radius;
  final Duration duration;
  final double stretchFactor;
  final double bottom;

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
      animation: _controller,
      builder: (context, child) {
        final rawProgress = _controller.value;
        final progress = Curves.easeOutCubic.transform(rawProgress);
        final stretchProgress = _stretchProgress(rawProgress);
        final width =
            widget.width *
            (1 + widget.stretchFactor * stretchProgress.clamp(0, 1));
        final center =
            _indicatorCenter(_fromIndex) +
            (_indicatorCenter(_toIndex) - _indicatorCenter(_fromIndex)) *
                progress;

        return Positioned(
          left: center - width / 2,
          bottom: widget.bottom,
          child: Container(
            width: width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
          ),
        );
      },
    );
  }

  double _indicatorCenter(int index) {
    return index * widget.slotPitch + widget.slotWidth / 2;
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
