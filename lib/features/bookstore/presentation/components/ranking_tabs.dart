import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_context.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
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
    final tabs = RankingTab.values;

    return SingleChildScrollView(
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
              isSelected: tabs[i] == widget.selected,
              onTap: () {
                widget.onSelected(tabs[i]);
                _syncScrollPosition(i);
              },
            ),
          ],
        ],
      ),
    );
  }

  void _syncScrollPosition(int selectedIndex) {
    if (!_scrollController.hasClients) return;
    final maxOffset = _scrollController.position.maxScrollExtent;
    if (maxOffset <= 0) return;

    final targetOffset = selectedIndex <= 1 ? 0.0 : maxOffset;
    _scrollController.jumpTo(targetOffset.clamp(0.0, maxOffset));
  }
}

class _RankingTabItem extends StatelessWidget {
  const _RankingTabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  final RankingTab tab;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppPressable(
      onTap: onTap,
      child: AppText(
        tab.label,
        style:
            (isSelected
                    ? AppTextStyles.tabActiveDark
                    : AppTextStyles.tabInactiveDark)
                .copyWith(
                  color: isSelected ? colors.textPrimary : colors.textMuted,
                ),
        maxLines: 1,
      ),
    );
  }
}
