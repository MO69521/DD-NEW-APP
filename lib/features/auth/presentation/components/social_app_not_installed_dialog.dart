import 'package:flutter/material.dart';

import '../../../../core/services/social_app_launch_service.dart';
import '../../../../shared/components/app_confirm_dialog.dart';

/// L3 — 第三方登录宿主 App 未安装时的下载引导弹窗。
class SocialAppNotInstalledDialog extends StatelessWidget {
  const SocialAppNotInstalledDialog({super.key, required this.target});

  final SocialAppTarget target;

  @override
  Widget build(BuildContext context) {
    final name = target.displayName;
    return AppConfirmDialog(
      title: '未安装$name',
      message: '请先安装$name后再使用$name登录',
      secondaryLabel: '取消',
      primaryLabel: '去下载',
    );
  }
}
