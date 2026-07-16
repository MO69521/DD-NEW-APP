import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';

/// L2 — 扫光高亮层：半透明高亮带从左向右循环滑过父容器。
///
/// 用法：放在按钮/卡片的 [Positioned.fill] 中，叠在背景之上、内容之下。
/// 自持动画控制器，调用方无需管理动画状态。
///
/// 会员开通 CTA、福利签到 CTA、签到成功弹窗 VIP 领取按钮统一复用此组件。
class SweepHighlightOverlay extends StatefulWidget {
  const SweepHighlightOverlay({
    super.key,
    this.highlightColor = AppColors.white50, // light-audit: effect 扫光高亮默认色
    this.edgeColor = AppColors.white00, // light-audit: effect 扫光边缘默认色
    this.bandWidthRatio = AppSizes.membershipCtaSweepBandWidthRatio,
    this.duration = AppDurations.membershipCtaSweep,
    this.progress,
    this.slant = 0,
    this.softEdges = false,
  });

  /// 高亮带中心颜色。
  final Color highlightColor;

  /// 高亮带两端颜色（一般为全透明）。
  final Color edgeColor;

  /// 高亮带宽度占容器宽度的比例。
  final double bandWidthRatio;

  /// 单次扫光时长（左 → 右）。
  final Duration duration;

  /// 可选外部进度；用于宿主组件将扫光与自绘形变同步。
  final Animation<double>? progress;

  /// 高亮带倾斜量，0 为垂直矩形。
  final double slant;

  /// 是否使用更宽、更柔和的高亮过渡。
  final bool softEdges;

  @override
  State<SweepHighlightOverlay> createState() => _SweepHighlightOverlayState();
}

class _SweepHighlightOverlayState extends State<SweepHighlightOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  Animation<double> get _animation => widget.progress ?? _controller!;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant SweepHighlightOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress ||
        oldWidget.duration != widget.duration) {
      _syncController();
    }
  }

  void _syncController() {
    if (widget.progress != null) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    final existing = _controller;
    if (existing != null) {
      existing.duration = widget.duration;
      if (!existing.isAnimating) existing.repeat();
      return;
    }
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final bandWidth = width * widget.bandWidthRatio;
              final travelDistance = width + bandWidth;
              final offsetX = -bandWidth + travelDistance * _animation.value;
              final colors = widget.softEdges
                  ? [
                      widget.edgeColor,
                      widget.highlightColor.withValues(alpha: 0.28),
                      widget.highlightColor.withValues(alpha: 0.50),
                      widget.highlightColor.withValues(alpha: 0.28),
                      widget.edgeColor,
                    ]
                  : [widget.edgeColor, widget.highlightColor, widget.edgeColor];
              final stops = widget.softEdges
                  ? const [0.0, 0.28, 0.5, 0.72, 1.0]
                  : const [0.0, 0.5, 1.0];

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.skewX(widget.slant),
                      child: Container(
                        width: bandWidth,
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: colors,
                            stops: stops,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
