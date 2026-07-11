import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_async_page_body.dart';
import '../../../../shared/components/app_swipe_tab_switcher.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../../../shared/widgets/aurora_background.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_conversation.dart';
import '../../domain/entities/partner_top_tab.dart';
import '../components/partner_explore_body.dart';
import '../components/partner_filter_sheet.dart';
import '../components/partner_interaction_body.dart';
import '../components/partner_message_body.dart';
import '../components/partner_page_header.dart';

/// 伙伴页：深色基底 + 粉色强调，仅渲染 state、触发 action。
class PartnerPage extends StatelessWidget {
  const PartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerCubit, PartnerState>(
      buildWhen: (previous, current) =>
          previous.ui != current.ui ||
          (previous.domain.content == null) != (current.domain.content == null),
      builder: (context, state) {
        final content = state.domain.content;
        if (state.ui.isLoading ||
            state.ui.errorMessage != null ||
            content == null) {
          return _PartnerPageShell(
            body: AppAsyncPageBody(
              isLoading: state.ui.isLoading,
              errorMessage: state.ui.errorMessage,
              onRetry: () => context.read<PartnerCubit>().load(),
              isEmpty: content == null,
              loadingColor: AppPartnerColors.primary,
              child: const SizedBox.shrink(),
            ),
          );
        }

        return const _PartnerView();
      },
    );
  }
}

class _PartnerView extends StatefulWidget {
  const _PartnerView();

  @override
  State<_PartnerView> createState() => _PartnerViewState();
}

class _PartnerViewState extends State<_PartnerView> {
  late final ValueNotifier<double> _tabSwipeProgress;

  @override
  void initState() {
    super.initState();
    _tabSwipeProgress = ValueNotifier<double>(
      context.read<PartnerCubit>().state.interaction.topTab.index.toDouble(),
    );
  }

  @override
  void dispose() {
    _tabSwipeProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final headerHeight = statusBarHeight + AppSizes.partnerHeaderHeight;

    return _PartnerPageShell(
      body: AppScrollBlurScope(
        builder: (context, topBlurEnabled) => Stack(
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: AppSizes.partnerTopAuroraHeight,
              child: _PartnerTopAurora(),
            ),
            Positioned.fill(
              child: BlocSelector<PartnerCubit, PartnerState, PartnerTopTab>(
                selector: (state) => state.interaction.topTab,
                builder: (context, topTab) {
                  return AppSwipeTabSwitcher(
                    selectedIndex: topTab.index,
                    onSwipeProgressChanged: (progress) =>
                        _tabSwipeProgress.value = progress,
                    onIndexChanged: (index) => context
                        .read<PartnerCubit>()
                        .switchTopTab(PartnerTopTab.values[index]),
                    children: [
                      _PartnerScrollView(
                        tab: PartnerTopTab.explore,
                        headerHeight: headerHeight,
                      ),
                      _PartnerScrollView(
                        tab: PartnerTopTab.message,
                        headerHeight: headerHeight,
                      ),
                      const _PartnerInteractionView(),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _PartnerFixedHeader(
                statusBarHeight: statusBarHeight,
                topBlurEnabled: topBlurEnabled,
                swipeProgress: _tabSwipeProgress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerTopAurora extends StatelessWidget {
  const _PartnerTopAurora();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PartnerCubit, PartnerState, PartnerTopTab>(
      selector: (state) => state.interaction.topTab,
      builder: (context, topTab) {
        final isVisible = topTab != PartnerTopTab.interaction;

        return IgnorePointer(
          child: AnimatedOpacity(
            duration: AppDurations.normal,
            opacity: isVisible ? 1 : 0,
            child: const ClipRect(
              child: AuroraBackground(
                opacity: AppSizes.partnerTopAuroraOpacity,
                colorStops: [
                  AppPartnerColors.primary,
                  AppPartnerColors.primary,
                  AppPartnerColors.primary,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PartnerScrollView extends StatelessWidget {
  const _PartnerScrollView({required this.tab, required this.headerHeight});

  final PartnerTopTab tab;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PartnerCubit>();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;
        cubit.onScrollNearEnd(
          notification.metrics.pixels,
          notification.metrics.maxScrollExtent,
        );
        return false;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: headerHeight)),
          switch (tab) {
            PartnerTopTab.message => PartnerMessageBody(
              onConversationTap: _onConversationTap,
            ),
            PartnerTopTab.explore => PartnerExploreBody(
              onCharacterTap: _onCharacterTap,
              onFilterTap: () => _openFilterSheet(context),
            ),
            PartnerTopTab.interaction => const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            ),
          },
        ],
      ),
    );
  }

  void _onCharacterTap(PartnerCharacter character) {}

  void _onConversationTap(PartnerConversation conversation) {}

  void _openFilterSheet(BuildContext context) {
    final state = context.read<PartnerCubit>().state;
    final options = state.domain.content?.filterOptions ?? const [];
    PartnerFilterSheet.show(
      context,
      options: options,
      selectedIndex: state.interaction.selectedFilterIndex,
      onOptionSelected: context.read<PartnerCubit>().selectFilterOption,
    );
  }
}

class _PartnerInteractionView extends StatelessWidget {
  const _PartnerInteractionView();

  @override
  Widget build(BuildContext context) {
    return const PartnerInteractionBody();
  }
}

class _PartnerFixedHeader extends StatelessWidget {
  const _PartnerFixedHeader({
    required this.statusBarHeight,
    required this.topBlurEnabled,
    required this.swipeProgress,
  });

  final double statusBarHeight;
  final bool topBlurEnabled;
  final ValueListenable<double> swipeProgress;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PartnerCubit>();

    return AppBlurredChromeBar(
      enabled: topBlurEnabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: statusBarHeight),
          BlocSelector<
            PartnerCubit,
            PartnerState,
            ({
              PartnerTopTab topTab,
              int messageUnreadCount,
              int interactionUnreadCount,
            })
          >(
            selector: (state) => (
              topTab: state.interaction.topTab,
              messageUnreadCount: state.domain.messageUnreadCount,
              interactionUnreadCount: state.domain.interactionUnreadCount,
            ),
            builder: (context, data) {
              return PartnerPageHeader(
                selectedTopTab: data.topTab,
                messageUnreadCount: data.messageUnreadCount,
                interactionUnreadCount: data.interactionUnreadCount,
                onTopTabSelected: cubit.switchTopTab,
                swipeProgress: swipeProgress,
                onSearchTap: () => AppRouter.pushNamed(AppRoutes.searchName),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PartnerPageShell extends StatelessWidget {
  const _PartnerPageShell({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPartnerColors.pageBackgroundBottom,
      body: body,
    );
  }
}
