import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_sort_mode.dart';
import '../../domain/entities/partner_top_tab.dart';
import '../components/partner_category_chip_bar.dart';
import '../components/partner_character_grid.dart';
import '../components/partner_filter_sheet.dart';
import '../components/partner_page_background.dart';
import '../components/partner_page_header.dart';
import '../components/partner_sort_filter_bar.dart';

/// 伙伴页 / 探索：深色基底 + 粉色强调，仅渲染 state、触发 action。
class PartnerPage extends StatelessWidget {
  const PartnerPage({super.key});

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

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
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBarHeight = topInset > 0
        ? topInset
        : AppSizes.statusBarPlaceholderHeight;
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
            SliverToBoxAdapter(child: SizedBox(height: statusBarHeight)),
            SliverToBoxAdapter(
              child: BlocSelector<PartnerCubit, PartnerState, ({
                PartnerTopTab topTab,
                int messageUnreadCount,
              })>(
                selector: (state) => (
                  topTab: state.interaction.topTab,
                  messageUnreadCount: state.domain.messageUnreadCount,
                ),
                builder: (context, data) {
                  return PartnerPageHeader(
                    selectedTopTab: data.topTab,
                    messageUnreadCount: data.messageUnreadCount,
                    onTopTabSelected: cubit.switchTopTab,
                    onSearchTap: () =>
                        AppRouter.pushNamed(AppRoutes.searchName),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.partnerHeaderToCategoryGap),
            ),
            SliverToBoxAdapter(
              child: BlocSelector<PartnerCubit, PartnerState, ({
                List<String> tags,
                int selectedIndex,
              })>(
                selector: (state) => (
                  tags: state.domain.categoryTags,
                  selectedIndex: state.interaction.selectedCategoryIndex,
                ),
                builder: (context, data) {
                  return PartnerCategoryChipBar(
                    tags: data.tags,
                    selectedIndex: data.selectedIndex,
                    onSelected: cubit.selectCategory,
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.partnerCategoryToSortGap),
            ),
            SliverToBoxAdapter(
              child: BlocSelector<PartnerCubit, PartnerState, PartnerSortMode>(
                selector: (state) => state.interaction.sortMode,
                builder: (context, sortMode) {
                  return PartnerSortFilterBar(
                    sortMode: sortMode,
                    onSortModeChanged: cubit.switchSortMode,
                    onFilterTap: () => _openFilterSheet(context),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              sliver: BlocBuilder<PartnerCubit, PartnerState>(
                buildWhen: (previous, current) =>
                    previous.domain.visibleCharacters !=
                        current.domain.visibleCharacters ||
                    previous.ui.isLoadingMore != current.ui.isLoadingMore,
                builder: (context, state) {
                  final characters = state.domain.visibleCharacters;

                  if (characters.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyState(title: '暂无角色'),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildListDelegate([
                      PartnerCharacterGrid(
                        characters: characters,
                        onCharacterTap: _onCharacterTap,
                      ),
                      if (state.ui.isLoadingMore) ...[
                        const SizedBox(height: AppSpacing.md),
                        const Center(
                          child: SizedBox(
                            width: AppSizes.partnerLoadingIndicatorSize,
                            height: AppSizes.partnerLoadingIndicatorSize,
                            child: CircularProgressIndicator(
                              strokeWidth: AppSizes
                                  .partnerLoadingIndicatorStrokeWidth,
                              color: AppPartnerColors.primary,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: PartnerPage._bottomNavReserve),
                    ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCharacterTap(PartnerCharacter character) {}

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

class _PartnerPageShell extends StatelessWidget {
  const _PartnerPageShell({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPartnerColors.pageBackgroundBottom,
      body: Stack(
        children: [
          const PartnerPageBackground(),
          body,
        ],
      ),
    );
  }
}
