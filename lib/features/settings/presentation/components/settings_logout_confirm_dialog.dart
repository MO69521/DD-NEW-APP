import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/app_confirm_dialog.dart';

/// L3 — 设置页退出登录二次确认弹窗。
class SettingsLogoutConfirmDialog extends StatelessWidget {
  const SettingsLogoutConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppConfirmDialog(
      title: '退出登录提示',
      message: '退出登录后，书籍阅读记录、存档等数据将无法同步到账号',
      titleBodyGap: AppSpacing.md,
      secondaryLabel: '退出登录',
      secondaryResult: true,
      primaryLabel: '我再想想',
      primaryResult: false,
    );
  }
}
