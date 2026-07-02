import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/components/app_blurred_chrome_bar.dart';
import '../../../../shared/layouts/app_chrome_blur.dart';
import '../../../../shared/layouts/app_scroll_blur_scope.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_conversation.dart';
import '../../domain/entities/partner_top_tab.dart';
import '../components/partner_explore_body.dart';
import '../components/partner_filter_sheet.dart';
import '../components/partner_interaction_body.dart';
import '../components/partner_message_body.dart';
import '../components/partner_page_background.dart';
import '../components/partner_page_header.dart';

/// 伙伴页：深色基底 + 粉色强调，仅渲染 state、触发 action。
class PartnerPage extends StatelessWidget {
  const PartnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartnerCubit, PartnerState>(
      buildWhen: (previous, current) =>
          previous.ui != current.ui ||
          (previous.domain.content == null) !=
              (current.domain.content == null),
      builder: (context, state) {
        if (state.ui.isLoading) {
          return const _PartnerPageShell(
            body: Center(
              child: CircularProgressIndicator(
                color: AppPartnerColors.primary,
              ),
            ),
          );
        }

        if (state.ui.errorMessage != null) {
          return _PartnerPageShell(
            body: EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<PartnerCubit>().load(),
              ),
            ),
          );
        }

        final content = state.domain.content;
        if (content == null) {
          return const _PartnerPageShell(
            body: EmptyState(title: '暂无数据'),
          );
        }

        return const _PartnerView();
      },
    );
  }
}

class _PartnerView extends StatelessWidget {
  const _PartnerView();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PartnerCubit, PartnerState, PartnerTopTab>(
      selector: (state) => state.interaction.topTab,
      builder: (context, topTab) {
        if (topTab == PartnerTopTab.interaction) {
          return const _PartnerInteractionView();
        }
        return const _PartnerScrollView();
      },
    );
  }
}

class _PartnerScrollView extends StatelessWidget {
  const _PartnerScrollView();

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final headerHeight = statusBarHeight + AppSizes.partnerHeaderHeight;
    final cubit = context.read<PartnerCubit>();

    return _PartnerPageShell(
      body: NotificationListener<ScrollNotification>(
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
            SliverPersistentHeader(
              pinned: true,
              delegate: _PartnerHeaderDelegate(
                height: headerHeight,
                child: _PartnerHeaderContent(statusBarHeight: statusBarHeight),
              ),
            ),
            BlocSelector<PartnerCubit, PartnerState, PartnerTopTab>(
              selector: (state) => state.interaction.topTab,
              builder: (context, topTab) {
                return switch (topTab) {
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
                };
              },
            ),
          ],
        ),
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
    return const _PartnerPageShell(
      showPageBackground: false,
      body: _PartnerInteractionBody(),
    );
  }
}

class _PartnerInteractionBody extends StatelessWidget {
  const _PartnerInteractionBody();

  @override
  Widget build(BuildContext context) {
    return AppScrollBlurScope(
      builder: (context, topBlurEnabled) => Stack(
        fit: StackFit.expand,
        children: [
          const PartnerInteractionBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _PartnerInteractionHeader(topBlurEnabled: topBlurEnabled),
          ),
        ],
      ),
    );
  }
}

class _PartnerInteractionHeader extends StatelessWidget {
  const _PartnerInteractionHeader({required this.topBlurEnabled});

  final bool topBlurEnabled;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final headerHeight =
        AppSizes.partnerInteractionHeaderOverlayHeight(statusBarHeight);
    final cubit = context.read<PartnerCubit>();

    return AppBlurredChromeBar(
      enabled: topBlurEnabled,
      child: SizedBox(
        height: headerHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: statusBarHeight),
            BlocSelector<PartnerCubit, PartnerState, ({
              PartnerTopTab topTab,
              int messageUnreadCount,
              int interactionUnreadCount,
            })>(
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
                  onSearchTap: () => AppRouter.pushNamed(AppRoutes.searchName),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerHeaderContent extends StatelessWidget {
  const _PartnerHeaderContent({required this.statusBarHeight});

  final double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PartnerCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: statusBarHeight),
        BlocSelector<PartnerCubit, PartnerState, ({
          PartnerTopTab topTab,
          int messageUnreadCount,
          int interactionUnreadCount,
        })>(
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
              onSearchTap: () => AppRouter.pushNamed(AppRoutes.searchName),
            );
          },
        ),
      ],
    );
  }
}

class _PartnerPageShell extends StatelessWidget {
  const _PartnerPageShell({
    required this.body,
    this.showPageBackground = true,
  });

  final Widget body;
  final bool showPageBackground;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPartnerColors.pageBackgroundBottom,
      body: Stack(
        children: [
          if (showPageBackground) const PartnerPageBackground(),
          body,
        ],
      ),
    );
  }
}

class _PartnerHeaderDelegate extends SliverPersistentHeaderDelegate {
  _PartnerHeaderDelegate({
    required this.height,
    required this.child,
  });

  final double height;
  final Widget child;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AppBlurredChromeBar(
      enabled: AppChromeBlur.shouldBlurForSliver(
        shrinkOffset: shrinkOffset,
        overlapsContent: overlapsContent,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _PartnerHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
