import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/dress_up_cubit.dart';
import '../../application/dress_up_state.dart';
import '../../domain/entities/dress_up_tab.dart';
import '../components/dress_up_bottom_bar.dart';
import '../components/dress_up_grid.dart';
import '../components/dress_up_hero_header.dart';
import '../components/dress_up_tab_bar.dart';

/// L3 页面 — 我的装扮（深色主题）：Hero 头部 + Tab + 宫格。
class DressUpPage extends StatelessWidget {
  const DressUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DressUpCubit, DressUpState>(
      builder: (context, state) {
        if (state.phase == DressUpPhase.loading) {
          return const Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.phase == DressUpPhase.error || state.content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(
              title: '加载失败',
              description: state.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<DressUpCubit>().load(),
              ),
            ),
          );
        }

        return _DressUpView(state: state);
      },
    );
  }
}

class _DressUpView extends StatefulWidget {
  const _DressUpView({required this.state});

  final DressUpState state;

  @override
  State<_DressUpView> createState() => _DressUpViewState();
}

class _DressUpViewState extends State<_DressUpView> {
  late final ValueNotifier<double> _tabSwipeProgress;

  @override
  void initState() {
    super.initState();
    _tabSwipeProgress = ValueNotifier<double>(0);
  }

  @override
  void dispose() {
    _tabSwipeProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final cubit = context.read<DressUpCubit>();
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final tabs = DressUpTab.values;
    final content = state.content!;
    final selectedTab = state.selectedTab;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          DressUpHeroHeader(
            avatarUrl: content.avatarUrl,
            nickname: content.nickname,
            userId: content.userId,
            backgroundAsset: content.heroBackgroundAsset,
            statusBarHeight: statusBarHeight,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: DressUpTabBar(
              selected: selectedTab,
              onSelected: cubit.selectTab,
              swipeProgress: _tabSwipeProgress,
            ),
          ),
          Expanded(
            child: AppSwipeTabSwitcher(
              selectedIndex: tabs.indexOf(selectedTab),
              onSwipeProgressChanged: (progress) =>
                  _tabSwipeProgress.value = progress,
              onIndexChanged: (index) => cubit.selectTab(tabs[index]),
              children: [
                for (final tab in tabs)
                  DressUpGrid(
                    items: content.itemsFor(tab),
                    selectedItemId: state.selectedItemId(tab),
                    onItemTap: (item) => cubit.selectItem(tab, item.id),
                  ),
              ],
            ),
          ),
          DressUpBottomBar(
            isEquipped: state.isSelectedEquipped(selectedTab),
            onEquip: () => cubit.equipSelected(selectedTab),
          ),
        ],
      ),
    );
  }
}
