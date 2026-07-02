import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../application/my_messages_cubit.dart';
import '../../application/my_messages_state.dart';
import '../components/my_messages_empty_view.dart';
import '../components/my_messages_tab_bar.dart';

/// L3 页面 — 我的消息（深色主题）。
class MyMessagesPage extends StatelessWidget {
  const MyMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTopBar(
              statusBarHeight: statusBarHeight,
              title: '我的消息',
              onBack: AppRouter.pop,
            ),
            const SizedBox(height: AppSpacing.sm),
            BlocBuilder<MyMessagesCubit, MyMessagesState>(
              buildWhen: (previous, current) =>
                  previous.interaction.selectedTab !=
                  current.interaction.selectedTab,
              builder: (context, state) {
                return MyMessagesTabBar(
                  selected: state.interaction.selectedTab,
                  onSelected: context.read<MyMessagesCubit>().onTabSelected,
                );
              },
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
        body: const MyMessagesEmptyView(),
      ),
    );
  }
}
