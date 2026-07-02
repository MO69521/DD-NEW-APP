import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';

/// L3 占位页 — 充值记录（P2 实现明细列表）。
class RechargeRecordsPage extends StatelessWidget {
  const RechargeRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '充值记录',
          onBack: AppRouter.pop,
        ),
        body: const EmptyState(title: '暂无充值记录'),
      ),
    );
  }
}
