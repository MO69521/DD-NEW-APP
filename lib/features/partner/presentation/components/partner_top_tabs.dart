import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../shared/components/app_top_tab_bar.dart';
import '../../domain/entities/partner_top_tab.dart';

/// L3 — 顶栏「探索 / 消息 / 互动」同级切换。统一复用 [AppTopTabBar]，
/// 指示条与悬浮角标取伙伴主题紫色。
class PartnerTopTabs extends StatelessWidget {
  const PartnerTopTabs({
    super.key,
    required this.selected,
    required this.messageUnreadCount,
    this.interactionUnreadCount = 0,
    this.onSelected,
    this.swipeProgress,
  });

  final PartnerTopTab selected;
  final int messageUnreadCount;
  final int interactionUnreadCount;
  final ValueChanged<PartnerTopTab>? onSelected;
  final ValueListenable<double>? swipeProgress;

  @override
  Widget build(BuildContext context) {
    final tabs = PartnerTopTab.values;

    return AppTopTabBar(
      items: [
        for (final tab in tabs)
          AppTopTabItem(
            label: tab.label,
            badgeCount: switch (tab) {
              PartnerTopTab.message => messageUnreadCount,
              PartnerTopTab.interaction => interactionUnreadCount,
              _ => 0,
            },
          ),
      ],
      selectedIndex: tabs.indexOf(selected),
      onSelected: (index) => onSelected?.call(tabs[index]),
      swipeProgress: swipeProgress,
      indicatorColor: AppPartnerColors.primary,
      badgeColor: AppPartnerColors.primary,
    );
  }
}
