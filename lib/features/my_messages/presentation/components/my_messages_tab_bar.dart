import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_top_tab_bar.dart';
import '../../domain/entities/my_message_tab.dart';

/// L3 组件 — 我的消息页 Tab（回复 / 获赞 / 通知）。统一复用 [AppTopTabBar]。
class MyMessagesTabBar extends StatelessWidget {
  const MyMessagesTabBar({
    super.key,
    required this.selected,
    required this.onSelected,
    this.unreadCounts = const {},
    this.swipeProgress,
  });

  final MyMessageTab selected;
  final ValueChanged<MyMessageTab> onSelected;
  final ValueListenable<double>? swipeProgress;

  /// 各 Tab 未读数；> 0 时展示悬浮红点角标。
  final Map<MyMessageTab, int> unreadCounts;

  @override
  Widget build(BuildContext context) {
    const tabs = MyMessageTab.values;

    return AppTopTabBar(
      items: [
        for (final tab in tabs)
          AppTopTabItem(label: tab.label, badgeCount: unreadCounts[tab] ?? 0),
      ],
      selectedIndex: tabs.indexOf(selected),
      onSelected: (index) => onSelected(tabs[index]),
      swipeProgress: swipeProgress,
      tabGap: AppSpacing.lg,
    );
  }
}
