import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../application/partner_cubit.dart';
import '../../application/partner_state.dart';
import '../../domain/entities/partner_character.dart';
import '../../domain/entities/partner_sort_mode.dart';
import 'partner_category_chip_bar.dart';
import 'partner_character_grid.dart';
import 'partner_sort_filter_bar.dart';

/// L3 — 探索 / 互动 Tab 主体（分类 + 排序筛选 + 角色网格）。
class PartnerExploreBody extends StatelessWidget {
  const PartnerExploreBody({
    super.key,
    required this.onCharacterTap,
    required this.onFilterTap,
  });

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  final ValueChanged<PartnerCharacter> onCharacterTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PartnerCubit>();

    return SliverMainAxisGroup(
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.partnerHeaderToCategoryGap),
        ),
        SliverToBoxAdapter(
          child:
              BlocSelector<
                PartnerCubit,
                PartnerState,
                ({List<String> tags, int selectedIndex})
              >(
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
                onFilterTap: onFilterTap,
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
                    onCharacterTap: onCharacterTap,
                  ),
                  if (state.ui.isLoadingMore) ...[
                    const SizedBox(height: AppSpacing.md),
                    const Center(
                      child: SizedBox(
                        width: AppSizes.partnerLoadingIndicatorSize,
                        height: AppSizes.partnerLoadingIndicatorSize,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              AppSizes.partnerLoadingIndicatorStrokeWidth,
                          color: AppPartnerColors.primary,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: _bottomNavReserve),
                ]),
              );
            },
          ),
        ),
      ],
    );
  }
}
