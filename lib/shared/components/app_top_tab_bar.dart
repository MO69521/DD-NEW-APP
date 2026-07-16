import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import 'app_animated_tab_label.dart';
import 'app_tab_count_badge.dart';
import 'elastic_tab_indicator.dart';
import '../widgets/app_pressable.dart';

/// 单个 Tab 的数据：文案 + 可选未读角标数（0 表示不显示角标）。
class AppTopTabItem {
  const AppTopTabItem({required this.label, this.badgeCount = 0});

  final String label;
  final int badgeCount;
}

/// L2 — 统一顶部一级 Tab 栏（书城首页同款切换样式）。
///
/// 等宽槽位（按最宽文案实测）+ 统一 [ElasticTabIndicator] 弹性指示条 +
/// [AppAnimatedTabLabel] 文字平滑过渡 / 跟手插值。可选悬浮计数角标为其变体
/// （仅在 [AppTopTabItem.badgeCount] > 0 时渲染）。
///
/// 各 feature Tab 栏（书城 / 消息 / 伙伴 / 帮助反馈等）统一复用本组件，只按语义
/// 传入文案、间距、指示条 / 角标主题色，避免各页重复实现。
class AppTopTabBar extends StatelessWidget {
  const AppTopTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.swipeProgress,
    this.tabGap = AppSpacing.md,
    this.indicatorColor = AppColors.primary,
    this.activeColor = AppColors.textPrimary,
    this.inactiveColor = AppColors.textSecondary,
    this.badgeColor = AppColors.badgeCount,
  });

  final List<AppTopTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// 内容区左右滑动的连续进度（0..tabCount-1），驱动指示条与文字跟手。
  final ValueListenable<double>? swipeProgress;

  /// Tab 之间的水平间距。
  final double tabGap;
  final Color indicatorColor;
  final Color activeColor;
  final Color inactiveColor;

  /// 悬浮计数角标底色（消息=红 `badgeCount`，伙伴=紫 `partner.primary` 等）。
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final metrics = _tabLabelMetrics(textScaler);
    final slotWidth = metrics.width;
    final labelHeight = metrics.height;
    final slotPitch = slotWidth + tabGap;
    final activeStyle = AppTextStyles.tabActiveDark.copyWith(
      color: activeColor,
    );
    final inactiveStyle = AppTextStyles.tabInactiveDark.copyWith(
      color: inactiveColor,
    );
    final swipe = swipeProgress;

    final tabBar = _TabBarContent(
      items: items,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
      tabGap: tabGap,
      slotWidth: slotWidth,
      labelHeight: labelHeight,
      slotPitch: slotPitch,
      swipeProgress: swipeProgress,
      activeStyle: activeStyle,
      inactiveStyle: inactiveStyle,
      indicatorColor: indicatorColor,
      badgeColor: badgeColor,
      isSwipeInProgress: false,
    );

    if (swipe == null) return tabBar;

    return ValueListenableBuilder<double>(
      valueListenable: swipe,
      builder: (context, progress, _) {
        final isSwipeInProgress =
            (progress - progress.roundToDouble()).abs() > 0.001;
        return _TabBarContent(
          items: items,
          selectedIndex: selectedIndex,
          onSelected: onSelected,
          tabGap: tabGap,
          slotWidth: slotWidth,
          labelHeight: labelHeight,
          slotPitch: slotPitch,
          swipeProgress: swipeProgress,
          activeStyle: activeStyle,
          inactiveStyle: inactiveStyle,
          indicatorColor: indicatorColor,
          badgeColor: badgeColor,
          isSwipeInProgress: isSwipeInProgress,
        );
      },
    );
  }

  ({double width, double height}) _tabLabelMetrics(TextScaler textScaler) {
    var maxWidth = 0.0;
    var maxHeight = 0.0;
    for (final item in items) {
      final activePainter = TextPainter(
        text: TextSpan(text: item.label, style: AppTextStyles.tabActiveDark),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaler: textScaler,
      )..layout();
      final inactivePainter = TextPainter(
        text: TextSpan(text: item.label, style: AppTextStyles.tabInactiveDark),
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textScaler: textScaler,
      )..layout();
      final itemMaxWidth = activePainter.width > inactivePainter.width
          ? activePainter.width
          : inactivePainter.width;
      final itemMaxHeight = activePainter.height > inactivePainter.height
          ? activePainter.height
          : inactivePainter.height;
      if (itemMaxWidth > maxWidth) maxWidth = itemMaxWidth;
      if (itemMaxHeight > maxHeight) maxHeight = itemMaxHeight;
    }
    return (
      width: maxWidth.ceilToDouble() + AppSpacing.xs,
      height: maxHeight.ceilToDouble(),
    );
  }
}

class _TabBarContent extends StatelessWidget {
  const _TabBarContent({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.tabGap,
    required this.slotWidth,
    required this.labelHeight,
    required this.slotPitch,
    required this.swipeProgress,
    required this.activeStyle,
    required this.inactiveStyle,
    required this.indicatorColor,
    required this.badgeColor,
    required this.isSwipeInProgress,
  });

  final List<AppTopTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final double tabGap;
  final double slotWidth;
  final double labelHeight;
  final double slotPitch;
  final ValueListenable<double>? swipeProgress;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final Color indicatorColor;
  final Color badgeColor;
  final bool isSwipeInProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: slotWidth * items.length + tabGap * (items.length - 1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) SizedBox(width: tabGap),
                _AppTopTabItemView(
                  item: items[i],
                  index: i,
                  selectedIndex: selectedIndex,
                  width: slotWidth,
                  labelHeight: labelHeight,
                  pressEffectEnabled: !isSwipeInProgress,
                  swipeProgress: swipeProgress,
                  activeStyle: activeStyle,
                  inactiveStyle: inactiveStyle,
                  badgeColor: badgeColor,
                  onTap: () => onSelected(i),
                ),
              ],
            ],
          ),
          ElasticTabIndicator(
            selectedIndex: selectedIndex,
            slotWidth: slotWidth,
            slotPitch: slotPitch,
            color: indicatorColor,
            swipeProgress: swipeProgress,
          ),
        ],
      ),
    );
  }
}

class _AppTopTabItemView extends StatelessWidget {
  const _AppTopTabItemView({
    required this.item,
    required this.index,
    required this.selectedIndex,
    required this.width,
    required this.labelHeight,
    required this.pressEffectEnabled,
    required this.activeStyle,
    required this.inactiveStyle,
    required this.badgeColor,
    required this.onTap,
    this.swipeProgress,
  });

  final AppTopTabItem item;
  final int index;
  final int selectedIndex;
  final double width;
  final double labelHeight;
  final bool pressEffectEnabled;
  final TextStyle activeStyle;
  final TextStyle inactiveStyle;
  final Color badgeColor;
  final ValueListenable<double>? swipeProgress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressEffectEnabled: pressEffectEnabled,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          // heightFactor: 1.0 让内容按文字高度收缩，不随父级（如固定高顶栏）
          // 拉伸而垂直居中——否则文字会上移、与底部指示条间距变大、各页不一致。
          child: Center(
            heightFactor: 1.0,
            // Stack 收缩到文字尺寸，角标以 overlay 贴在文字右上角，不占布局宽度。
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: labelHeight,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AppAnimatedTabLabel(
                      index: index,
                      selectedIndex: selectedIndex,
                      label: item.label,
                      activeStyle: activeStyle,
                      inactiveStyle: inactiveStyle,
                      swipeProgress: swipeProgress,
                      lockGeometryDuringSwipe: true,
                    ),
                  ),
                ),
                if (item.badgeCount > 0)
                  Positioned(
                    top: -AppSpacing.sm,
                    right: -AppSpacing.sm,
                    child: AppTabCountBadge(
                      count: item.badgeCount,
                      color: badgeColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
