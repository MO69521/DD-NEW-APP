import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';

/// L1 组件 — 容器转换（Container Transform）转场包装器。
///
/// 将 [closedChild]（卡片）无缝放大为 [openChild]（全屏页），基于
/// `animations` 包的 [OpenContainer]：
/// - 圆角随放大平滑变直角（[borderRadius] → 0）；
/// - 暗色主题下 [closedColor]/[openColor] 默认用实色背景，避免转场白闪；
/// - 点击卡片有水波纹反馈，且裁剪在卡片圆角内。
///
/// 注意：[OpenContainer] 自管转场路由（不经过 `AppRouter`/go_router），
/// 这是共享元素动效的固有要求；展开页为纯视觉转场页，不参与深链路由。
class AdvancedTransitionWrapper extends StatelessWidget {
  const AdvancedTransitionWrapper({
    super.key,
    required this.closedChild,
    this.openChild,
    this.openBuilder,
    this.borderRadius = AppRadius.lg,
    this.closedColor,
    this.openColor,
    this.duration = AppDurations.containerTransform,
    this.onClosed,
  }) : assert(
         openChild != null || openBuilder != null,
         'openChild 与 openBuilder 至少提供一个',
       );

  /// 未展开时的卡片 UI。
  final Widget closedChild;

  /// 展开后的完整页面 UI（与 [openBuilder] 二选一）。
  final Widget? openChild;

  /// 展开页构造器，回调参数 `closeContainer` 用于触发缩回动画，
  /// 业务页据此关闭而无需直接调用 Navigator（与 [openChild] 二选一）。
  final Widget Function(BuildContext context, VoidCallback closeContainer)?
  openBuilder;

  /// 卡片默认圆角半径（展开到全屏时归零）。
  final double borderRadius;

  /// 闭合状态背景色；为空时用实色暗背景，避免转场白闪。
  final Color? closedColor;

  /// 展开状态背景色；为空时跟随页面 [ThemeData.scaffoldBackgroundColor]。
  final Color? openColor;

  /// 转场时长（建议 400–500ms）。
  final Duration duration;

  /// 全屏页关闭返回后的回调。
  final ValueChanged<Object?>? onClosed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OpenContainer<Object?>(
      transitionDuration: duration,
      transitionType: ContainerTransitionType.fadeThrough,
      routeSettings: const RouteSettings(name: '/detail_page_transition'),
      onClosed: onClosed,
      // 闭合（卡片）外观：圆角 + 实色背景，杜绝白闪。
      closedElevation: 0,
      closedColor: closedColor ?? AppColors.backgroundDark,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      // 展开（全屏）外观：直角 + 页面背景色。
      openElevation: 0,
      openColor: openColor ?? theme.scaffoldBackgroundColor,
      openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      openBuilder: (context, closeContainer) {
        final child = openBuilder?.call(context, closeContainer) ?? openChild!;
        return PopScope(canPop: true, child: child);
      },
      closedBuilder: (context, openContainer) {
        return InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: openContainer,
          child: closedChild,
        );
      },
    );
  }
}
