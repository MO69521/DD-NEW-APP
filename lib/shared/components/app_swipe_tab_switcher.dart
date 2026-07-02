import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';

/// Level 2 — Tab 内容区左右滑动切换手势包裹层。
///
/// 包裹任意内容（含内部纵向滚动视图），识别水平快滑手势并切换到相邻 Tab：
/// - 向左滑 → 下一个 Tab；
/// - 向右滑 → 上一个 Tab。
///
/// 仅负责手势，不改动内容布局；越界方向不触发。内部横向可滚动组件（如横向
/// 列表）在手势竞技中优先，故不会误触。
class AppSwipeTabSwitcher extends StatelessWidget {
  const AppSwipeTabSwitcher({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.tabCount,
    required this.onIndexChanged,
    this.enabled = true,
  });

  final Widget child;
  final int selectedIndex;
  final int tabCount;
  final ValueChanged<int> onIndexChanged;

  /// 为 false 时仅透传内容，不启用滑动（如分类页只允许点击切换）。
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || tabCount <= 1) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < AppSizes.swipeTabVelocityThreshold) return;

        // 向左滑动（负速度）→ 下一个；向右滑动（正速度）→ 上一个。
        final nextIndex = velocity < 0 ? selectedIndex + 1 : selectedIndex - 1;
        if (nextIndex < 0 || nextIndex >= tabCount) return;
        onIndexChanged(nextIndex);
      },
      child: child,
    );
  }
}
