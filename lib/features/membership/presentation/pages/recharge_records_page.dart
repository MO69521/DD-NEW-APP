import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';

/// L3 占位页 — 充值记录（P2 实现明细列表）。
class RechargeRecordsPage extends StatelessWidget {
  const RechargeRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          AppTopBar(
            statusBarHeight: statusBarHeight,
            title: '充值记录',
            onBack: AppRouter.pop,
          ),
          const Expanded(
            child: EmptyState(title: '暂无充值记录'),
          ),
        ],
      ),
    );
  }
}
