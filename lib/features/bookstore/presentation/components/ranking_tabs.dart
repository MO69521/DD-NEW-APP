import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/components/app_animated_tab_label.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../core/domain/entities/book.dart';

/// 榜单 Tab 切换（推荐榜 / 人气榜 / 飙升榜 / 完结榜）。
///
/// 与下方书单左对齐，Tab 间距固定 [AppSpacing.md]。
class RankingTabs extends StatefulWidget {
  const RankingTabs({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RankingTab selected;
  final ValueChanged<RankingTab> onSelected;

  @override
  State<RankingTabs> createState() => _RankingTabsState();
}

class _RankingTabsState extends State<RankingTabs> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScrollPosition(RankingTab.values.indexOf(widget.selected));
    });
  }

  @override
  void didUpdateWidget(covariant RankingTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected == widget.selected) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncScrollPosition(RankingTab.values.indexOf(widget.selected));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tabs = RankingTab.values;

    // 横向滚动到右缘时渐隐（不硬切）：ShaderMask 在右侧做透明渐变。
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
        // 加宽渐隐区（40px）使右缘淡出更柔和自然。
        const fadeWidth = AppSpacing.xl + AppSpacing.xs;
        final fadeStop = bounds.width <= 0
            ? 1.0
            : (1 - (fadeWidth / bounds.width)).clamp(0.0, 1.0);
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [Colors.white, Colors.white, Colors.transparent],
          stops: [0.0, fadeStop, 1.0],
        ).createShader(bounds);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < tabs.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              _RankingTabItem(
                tab: tabs[i],
                index: i,
                selectedIndex: tabs.indexOf(widget.selected),
                onTap: () {
                  widget.onSelected(tabs[i]);
                  _syncScrollPosition(i);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _syncScrollPosition(int selectedIndex) {
    if (!_scrollController.hasClients) return;
    final maxOffset = _scrollController.position.maxScrollExtent;
    if (maxOffset <= 0) return;

    final targetOffset = (selectedIndex <= 1 ? 0.0 : maxOffset).clamp(
      0.0,
      maxOffset,
    );
    if ((targetOffset - _scrollController.offset).abs() < 1) return;
    // 平滑滚动到目标位置；jumpTo 硬跳会让跨档切换观感突兀。
    _scrollController.animateTo(
      targetOffset,
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
    );
  }
}

class _RankingTabItem extends StatelessWidget {
  const _RankingTabItem({
    required this.tab,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  final RankingTab tab;
  final int index;
  final int selectedIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppPressable(
      onTap: onTap,
      child: AppAnimatedTabLabel(
        index: index,
        selectedIndex: selectedIndex,
        label: tab.label,
        activeStyle: AppTextStyles.tabActiveDark.copyWith(
          color: colors.textPrimary,
        ),
        inactiveStyle: AppTextStyles.tabInactiveDark.copyWith(
          color: colors.textMuted,
        ),
      ),
    );
  }
}
