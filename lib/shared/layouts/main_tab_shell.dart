import 'package:flutter/material.dart';

import '../../core/constants/main_tab_config.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';
import 'app_bottom_nav.dart';
import 'main_tab_controller.dart';

/// 主 Tab 待领取气泡是否可见（与底栏展示条件一致），供书城浮层避让。
class MainTabPendingClaimScope extends InheritedWidget {
  const MainTabPendingClaimScope({
    super.key,
    required this.isVisible,
    required super.child,
  });

  final bool isVisible;

  static MainTabPendingClaimScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MainTabPendingClaimScope>();
  }

  @override
  bool updateShouldNotify(MainTabPendingClaimScope oldWidget) =>
      isVisible != oldWidget.isVisible;
}

/// 主 Tab Shell：管理 Tab 切换与共享底栏，页面由外部注入。
class MainTabShell extends StatefulWidget {
  const MainTabShell({
    super.key,
    required this.pages,
    this.initialIndex = 0,
    this.controller,
    this.hideBottomNav = false,
    this.pendingClaimEnergy,
  });

  final List<Widget> pages;
  final int initialIndex;
  final MainTabController? controller;
  final bool hideBottomNav;
  final int? pendingClaimEnergy;

  @override
  State<MainTabShell> createState() => _MainTabShellState();
}

class _MainTabShellState extends State<MainTabShell> {
  late int _selectedIndex = widget.initialIndex;
  late bool _hasVisitedWelfare =
      widget.initialIndex == MainTabConfig.welfareIndex;

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(_switchToTab);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller?.notifyTabChanged(_selectedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant MainTabShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(_switchToTab);
    }
    if (oldWidget.initialIndex != widget.initialIndex &&
        widget.initialIndex >= 0 &&
        widget.initialIndex < widget.pages.length) {
      _selectedIndex = widget.initialIndex;
      if (_selectedIndex == MainTabConfig.welfareIndex) {
        _hasVisitedWelfare = true;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller?.notifyTabChanged(_selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    super.dispose();
  }

  void _switchToTab(int index) {
    if (index < 0 || index >= widget.pages.length) return;
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      if (index == MainTabConfig.welfareIndex) {
        _hasVisitedWelfare = true;
      }
    });
    widget.controller?.notifyTabChanged(index);
  }

  void _onTabChanged(int index) => _switchToTab(index);

  bool get _pendingClaimBadgeVisible =>
      !_hasVisitedWelfare && (widget.pendingClaimEnergy ?? 0) > 0;

  @override
  Widget build(BuildContext context) {
    return MainTabPendingClaimScope(
      isVisible: _pendingClaimBadgeVisible,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            IndexedStack(index: _selectedIndex, children: widget.pages),
            if (!widget.hideBottomNav)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppBottomNav(
                  selectedIndex: _selectedIndex,
                  pendingClaimEnergy: _pendingClaimBadgeVisible
                      ? widget.pendingClaimEnergy
                      : null,
                  onTabChanged: _onTabChanged,
                  style: AppBottomNavStyle.fullWidthSolid,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 未实现 Tab 的占位页。
class MainTabPlaceholder extends StatelessWidget {
  const MainTabPlaceholder({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        '$label · 敬请期待',
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textOnDarkMuted,
          height: AppLineHeights.none,
        ),
      ),
    );
  }
}
