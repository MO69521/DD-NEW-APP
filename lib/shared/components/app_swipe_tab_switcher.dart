import 'package:flutter/material.dart';

import '../../core/theme/app_durations.dart';
import '../../core/theme/app_sizes.dart';

/// Level 2 — Tab 内容区左右滑动切换。
///
/// 使用 PageView 实现与首页一致的跟手滑动效果；落页后通过 [onIndexChanged]
/// 同步外部 tab state。
class AppSwipeTabSwitcher extends StatefulWidget {
  const AppSwipeTabSwitcher({
    super.key,
    this.child,
    this.children,
    required this.selectedIndex,
    required this.onIndexChanged,
    this.tabCount,
    this.enabled = true,
    this.onSwipeProgressChanged,
  }) : assert(
         child != null || children != null,
         'Either child or children must be provided',
       );

  /// 自适应高度内容使用 [child]，仅提供左右滑手势。
  final Widget? child;

  /// 有界内容使用 [children]，通过 PageView 获得与首页一致的跟手切换。
  final List<Widget>? children;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final int? tabCount;
  final ValueChanged<double>? onSwipeProgressChanged;

  /// 为 false 时仅透传内容，不启用滑动（如分类页只允许点击切换）。
  final bool enabled;

  @override
  State<AppSwipeTabSwitcher> createState() => _AppSwipeTabSwitcherState();
}

class _AppSwipeTabSwitcherState extends State<AppSwipeTabSwitcher> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSwipeProgressChanged?.call(widget.selectedIndex.toDouble());
    });
  }

  @override
  void didUpdateWidget(covariant AppSwipeTabSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex == oldWidget.selectedIndex) {
      return;
    }
    // 延后到本帧构建结束再翻页：animateToPage 会同步派发 ScrollStartNotification，
    // 若在 didUpdateWidget（构建阶段）内触发，祖先（如 AppPageChrome）在滚动通知
    // 回调里 setState 会命中「build 期间 setState」断言导致崩溃。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.animateToPage(
        widget.selectedIndex,
        duration: AppDurations.normal,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.children;
    if (children == null) return _buildGestureOnly(widget.child!);
    if (children.isEmpty) return const SizedBox.shrink();
    if (!widget.enabled || children.length <= 1) {
      final index = widget.selectedIndex.clamp(0, children.length - 1);
      return children[index];
    }

    // 仅在滚动结束（松手落页）后提交切换：拖动过程中跟手但不中途自动翻页，
    // 由 PageScrollPhysics 依据松手位置/速度决定落到哪一页。
    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (!_pageController.hasClients || _pageController.page == null) {
          return false;
        }
        final target = _pageController.page!.round().clamp(
          0,
          children.length - 1,
        );
        if (target != widget.selectedIndex) {
          widget.onIndexChanged(target);
        }
        return false;
      },
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          final page = _pageController.hasClients ? _pageController.page : null;
          if (page != null) {
            widget.onSwipeProgressChanged?.call(
              page.clamp(0, children.length - 1).toDouble(),
            );
          }
          return false;
        },
        child: PageView(
          controller: _pageController,
          physics: const PageScrollPhysics(),
          children: children,
        ),
      ),
    );
  }

  Widget _buildGestureOnly(Widget child) {
    if (!widget.enabled) return child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity.abs() < AppSizes.swipeTabVelocityThreshold) return;
        final nextIndex = velocity < 0
            ? widget.selectedIndex + 1
            : widget.selectedIndex - 1;
        final maxCount = widget.tabCount ?? 1;
        if (nextIndex < 0 || nextIndex >= maxCount) return;
        widget.onIndexChanged(nextIndex);
      },
      child: child,
    );
  }
}
