import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_top_tab_bar.dart';
import '../../domain/entities/help_feedback_tab.dart';

/// L3 — 帮助与反馈页顶部 Tab（常见问题 / 意见反馈）。统一复用 [AppTopTabBar]。
class HelpFeedbackTabBar extends StatelessWidget {
  const HelpFeedbackTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.swipeProgress,
  });

  final HelpFeedbackTab selected;
  final ValueChanged<HelpFeedbackTab> onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    const tabs = HelpFeedbackTab.values;

    return AppTopTabBar(
      items: [for (final tab in tabs) AppTopTabItem(label: tab.label)],
      selectedIndex: tabs.indexOf(selected),
      onSelected: (index) => onSelected(tabs[index]),
      swipeProgress: swipeProgress,
      tabGap: AppSpacing.xl,
    );
  }
}
