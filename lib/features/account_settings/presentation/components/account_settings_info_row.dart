import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/components/app_navigation_list_row.dart';
import '../../../../shared/widgets/app_network_avatar.dart';

/// L3 组件 — 账号设置个人信息行（可导航 / 只读）。
class AccountSettingsInfoRow extends StatelessWidget {
  const AccountSettingsInfoRow({
    super.key,
    required this.label,
    this.value,
    this.avatarUrl,
    this.onTap,
    this.showChevron = true,
  });

  final String label;
  final String? value;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return AppNavigationListRow(
      label: label,
      trailingText: avatarUrl == null ? value : null,
      trailing: avatarUrl == null
          ? null
          : AppNetworkAvatar(
              imageUrl: avatarUrl!,
              size: AppSizes.accountSettingsAvatarSize,
            ),
      onTap: onTap,
      showChevron: showChevron,
    );
  }
}
