import 'package:flutter/material.dart';

import '../../../../shared/components/app_grouped_list_card.dart';

/// L3 组件 — 账号设置页分组：区块标题 + 卡片容器。
class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppGroupedListCard(title: title, children: children);
  }
}
