import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';

/// L1 — 通用按压反馈包裹组件。
///
/// 点击时播放一段完整的「缩小 → overshoot 反弹 → 回正」脚本动画，让全局可点击模块
/// （按钮 / 卡片 / 列表行 / 图标）拥有统一的「按下—反弹」微交互。
///
/// 为何用 `onTap` 驱动脚本动画而非 `onTapDown/onTapUp`：在可滚动列表中，手势竞技场
/// 会把 `onTapDown` 推迟到松手瞬间，导致快速点击时缩放被压缩、几乎不可见。改由 `onTap`
/// 触发固定脚本，保证列表内也能稳定看到完整回弹。
///
/// 时序：点击后先播放缩小 + 反弹峰值，再在 [AppDurations.tapPressActionDelay] 后触发
/// [onTap]（页面跳转会盖住其后的回落），因此「按下 → 弹起 → 跳转」可完整看到。
///
/// 样式取自 token：[AppSizes.tapPressScale]、[AppSizes.tapPressReboundScale]、
/// [AppDurations.tapPressDown]、[AppDurations.tapPressRebound]。
class AppPressable extends StatefulWidget {
  const AppPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.behavior = HitTestBehavior.opaque,
    this.pressScale,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HitTestBehavior behavior;

  /// 按下缩小到的比例（全宽列表行等大面积模块可传更柔和的 [AppSizes.tapPressScaleSubtle]）。
  /// 为空时使用 [AppSizes.tapPressScale]。
  final double? pressScale;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.tapPressDown + AppDurations.tapPressRebound,
    );
    _scale = _buildScale();
  }

  @override
  void didUpdateWidget(covariant AppPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressScale != widget.pressScale) {
      _scale = _buildScale();
    }
  }

  Animation<double> _buildScale() {
    final pressScale = widget.pressScale ?? AppSizes.tapPressScale;
    return TweenSequence<double>([
      // 缩小（被按下）。
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1,
          end: pressScale,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      // 反弹越过原尺寸（overshoot）。
      TweenSequenceItem(
        tween: Tween<double>(
          begin: pressScale,
          end: AppSizes.tapPressReboundScale,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      // 回落到原尺寸。
      TweenSequenceItem(
        tween: Tween<double>(
          begin: AppSizes.tapPressReboundScale,
          end: 1,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller
      ..stop()
      ..forward(from: 0);
    final callback = widget.onTap;
    if (callback == null) return;
    // 先让「按下 → 反弹」可见，再触发动作 / 跳转。
    Future.delayed(AppDurations.tapPressActionDelay, () {
      if (mounted) callback();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTap: widget.onTap == null ? null : _handleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            alignment: Alignment.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
