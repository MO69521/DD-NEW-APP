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
    this.highlightColor = AppColors.white50,
    this.edgeColor = AppColors.white00,
    this.bandWidthRatio = AppSizes.membershipCtaSweepBandWidthRatio,
    this.duration = AppDurations.membershipCtaSweep,
  });

  /// 高亮带中心颜色。
  final Color highlightColor;

  /// 高亮带两端颜色（一般为全透明）。
  final Color edgeColor;

  /// 高亮带宽度占容器宽度的比例。
  final double bandWidthRatio;

  /// 单次扫光时长（左 → 右）。
  final Duration duration;

  @override
  State<SweepHighlightOverlay> createState() => _SweepHighlightOverlayState();
}

class _SweepHighlightOverlayState extends State<SweepHighlightOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final bandWidth = width * widget.bandWidthRatio;
              final travelDistance = width + bandWidth;
              final offsetX = -bandWidth + travelDistance * _controller.value;

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Transform.translate(
                    offset: Offset(offsetX, 0),
                    child: Container(
                      width: bandWidth,
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            widget.edgeColor,
                            widget.highlightColor,
                            widget.edgeColor,
                          ],
                          stops: const [0, 0.5, 1],
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
