import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../application/my_messages_cubit.dart';
import '../../application/my_messages_state.dart';
import '../../domain/entities/my_message_tab.dart';
import '../../domain/entities/my_messages_page_content.dart';
import '../components/my_messages_empty_view.dart';
import '../components/my_messages_list.dart';
import '../components/my_messages_tab_bar.dart';
import '../components/my_notifications_list.dart';

/// L3 页面 — 我的消息（深色主题）。
class MyMessagesPage extends StatelessWidget {
  const MyMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
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
                    current.interaction.selectedTab ||
                previous.content != current.content,
            builder: (context, state) {
              return MyMessagesTabBar(
                selected: state.interaction.selectedTab,
                onSelected: context.read<MyMessagesCubit>().onTabSelected,
                unreadCounts: _unreadCounts(state.content),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: BlocBuilder<MyMessagesCubit, MyMessagesState>(
              buildWhen: (previous, current) =>
                  previous.interaction.selectedTab !=
                      current.interaction.selectedTab ||
                  previous.content != current.content ||
                  previous.isLoading != current.isLoading,
              builder: (context, state) {
                if (state.isLoading || state.content == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                const tabs = MyMessageTab.values;
                final content = state.content!;
                return AppSwipeTabSwitcher(
                  selectedIndex: tabs.indexOf(state.interaction.selectedTab),
                  onIndexChanged: (index) => context
                      .read<MyMessagesCubit>()
                      .onTabSelected(tabs[index]),
                  children: [
                    for (final tab in tabs) _TabBody(content: content, tab: tab),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<MyMessageTab, int> _unreadCounts(MyMessagesPageContent? content) {
    if (content == null) return const {};
    return {
      for (final tab in MyMessageTab.values) tab: content.unreadFor(tab),
    };
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({required this.content, required this.tab});

  final MyMessagesPageContent content;
  final MyMessageTab tab;

  @override
  Widget build(BuildContext context) {
    if (tab == MyMessageTab.notification) {
      if (content.notifications.isEmpty) return const MyMessagesEmptyView();
      return MyNotificationsList(notifications: content.notifications);
    }

    final messages = content.messagesFor(tab);
    if (messages.isEmpty) return const MyMessagesEmptyView();
    return MyMessagesList(messages: messages);
  }
}
