import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';
import '../widgets/app_text.dart';

/// L2 — Tab 文字标签：在未选中 / 选中样式之间平滑过渡（字号 / 字重 / 颜色随
/// 选中度插值），而非硬切换。与 [ElasticTabIndicator] 使用同一套进度模型：
///
/// - 提供 [swipeProgress] 时（内容区跟手滑动），标签随手指连续插值；
/// - 未提供时，选中项变化会以 [duration] 做一次平滑过渡（点击切换）。
///
/// 各 Tab 的选中度 `t = 1 - clamp(|progress - index|, 0, 1)`，其中 progress
/// 为 [swipeProgress]（连续）或内部动画在 from/to 索引间的插值。
class AppAnimatedTabLabel extends StatefulWidget {
  const AppAnimatedTabLabel({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.label,
    required this.activeStyle,
    required this.inactiveStyle,
    this.swipeProgress,
    this.duration = AppDurations.normal,
    this.textAlign = TextAlign.center,
    this.lockGeometryDuringSwipe = false,
  });

  final int index;
  final int selectedIndex;
  final String label;

  /// 完全选中态样式（t=1）。
  final TextStyle activeStyle;

  /// 完全未选中态样式（t=0）。
  final TextStyle inactiveStyle;

  /// 内容区左右滑动的连续进度（0..tabCount-1）；提供后标签跟手插值。
  final ValueListenable<double>? swipeProgress;
  final Duration duration;
  final TextAlign textAlign;

  /// 为 true 时，在 [swipeProgress] 跟手滑动阶段锁定文字几何（字号/字重/字体族），
  /// 改用 inactive/active 双层透明度混合，避免抖动且不生硬硬切。
  final bool lockGeometryDuringSwipe;

  @override
  State<AppAnimatedTabLabel> createState() => _AppAnimatedTabLabelState();
}

class _AppAnimatedTabLabelState extends State<AppAnimatedTabLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _fromIndex;
  late double _toIndex;

  @override
  void initState() {
    super.initState();
    _fromIndex = widget.selectedIndex.toDouble();
    _toIndex = widget.selectedIndex.toDouble();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant AppAnimatedTabLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 跟手模式下由 swipeProgress 直接驱动，无需内部动画。
    if (widget.swipeProgress != null) return;
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _fromIndex = oldWidget.selectedIndex.toDouble();
      _toIndex = widget.selectedIndex.toDouble();
      _controller
        ..duration = widget.duration
        ..forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _effectiveProgress {
    final swipe = widget.swipeProgress?.value;
    if (swipe != null) return swipe;
    final eased = Curves.easeInOut.transform(_controller.value);
    return _fromIndex + (_toIndex - _fromIndex) * eased;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.swipeProgress ?? _controller,
      builder: (context, _) {
        final distance = (_effectiveProgress - widget.index).abs().clamp(
          0.0,
          1.0,
        );
        final t = 1 - distance;
        if (widget.lockGeometryDuringSwipe && widget.swipeProgress != null) {
          return _buildLockedGeometryLabel(t);
        }
        final style = _lerpTabStyle(t);
        return AppText(
          widget.label,
          style: style,
          textAlign: widget.textAlign,
          maxLines: 1,
          overflow: TextOverflow.visible,
        );
      },
    );
  }

  TextStyle _lerpTabStyle(double t) {
    if (t <= 0) return widget.inactiveStyle;
    if (t >= 1) return widget.activeStyle;
    final inactiveForLerp = _normalizeLerpEndpoint(
      widget.inactiveStyle,
      widget.activeStyle,
    );
    final activeForLerp = _normalizeLerpEndpoint(
      widget.activeStyle,
      widget.inactiveStyle,
    );
    return TextStyle.lerp(inactiveForLerp, activeForLerp, t)!;
  }

  TextStyle _normalizeLerpEndpoint(TextStyle base, TextStyle peer) {
    final resolvedFamily = base.fontFamily ?? peer.fontFamily;
    final resolvedFallback = base.fontFamilyFallback ?? peer.fontFamilyFallback;
    return base.copyWith(
      fontFamily: resolvedFamily,
      fontFamilyFallback: resolvedFallback,
    );
  }

  Widget _buildLockedGeometryLabel(double t) {
    final inactiveOpacity = (1 - t).clamp(0.0, 1.0);
    final activeOpacity = t.clamp(0.0, 1.0);
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: inactiveOpacity,
          child: AppText(
            widget.label,
            style: widget.inactiveStyle,
            textAlign: widget.textAlign,
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
        Opacity(
          opacity: activeOpacity,
          child: AppText(
            widget.label,
            style: widget.activeStyle,
            textAlign: widget.textAlign,
            maxLines: 1,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
