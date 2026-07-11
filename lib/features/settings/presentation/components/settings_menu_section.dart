import 'package:flutter/material.dart';

import '../../../../shared/components/app_grouped_list_card.dart';
import '../../../../shared/components/app_navigation_list_row.dart';
import '../../domain/entities/settings_menu_item.dart';

/// L3 组件 — 设置页菜单卡片容器。
class SettingsMenuSection extends StatelessWidget {
  const SettingsMenuSection({super.key, required this.items, this.onItemTap});

  final List<SettingsMenuItem> items;
  final ValueChanged<SettingsMenuAction>? onItemTap;

  @override
  Widget build(BuildContext context) {
    return AppGroupedListCard(
      children: [
        for (final item in items)
          SettingsMenuRow(
            item: item,
            onTap: onItemTap == null ? null : () => onItemTap!(item.action),
          ),
      ],
    );
  }
}

/// L3 组件 — 设置页菜单行。
class SettingsMenuRow extends StatelessWidget {
  const SettingsMenuRow({super.key, required this.item, this.onTap});

  final SettingsMenuItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppNavigationListRow(
      label: item.label,
      subtitle: item.subtitle,
      trailingText: item.trailingText,
      onTap: onTap,
    );
  }
}
