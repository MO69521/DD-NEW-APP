import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/book_card_skeletons.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/category_cubit.dart';
import '../../application/category_state.dart';
import '../../application/category_ui_state.dart';
import 'category_book_list.dart';
import 'category_filter_section.dart';
import 'category_list_footer.dart';

/// 分类 Tab 主体：筛选 + 书籍列表（供书城页内嵌入或二级页复用）。
class CategoryTabBody extends StatelessWidget {
  const CategoryTabBody({
    super.key,
    this.topScrollPadding = 0,
    this.bottomScrollPadding = 0,
  });

  static const String emptyTitle = '暂无作品';

  /// 书城顶栏内嵌时预留顶部 Chrome 高度，使首屏内容不被遮挡。
  final double topScrollPadding;

  /// 书城主 Tab 内嵌时预留底部导航高度。
  final double bottomScrollPadding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        switch (state.ui.phase) {
          case CategoryPhase.loading:
            return BookLargeRowListSkeleton(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                topScrollPadding + AppSpacing.md,
                AppSpacing.md,
                0,
              ),
            );
          case CategoryPhase.empty:
            return EmptyState(
              title: emptyTitle,
              description: state.ui.errorMessage,
            );
          case CategoryPhase.loaded:
            return _CategoryTabContent(
              state: state,
              topScrollPadding: topScrollPadding,
              bottomScrollPadding: bottomScrollPadding,
            );
        }
      },
    );
  }
}

class _CategoryTabContent extends StatefulWidget {
  const _CategoryTabContent({
    required this.state,
    required this.topScrollPadding,
    required this.bottomScrollPadding,
  });

  final CategoryState state;
  final double topScrollPadding;
  final double bottomScrollPadding;

  @override
  State<_CategoryTabContent> createState() => _CategoryTabContentState();
}

class _CategoryTabContentState extends State<_CategoryTabContent> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _filterSectionKey = GlobalKey();
  bool _showFilterSummary = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateFilterSummaryVisibility);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateFilterSummaryVisibility)
      ..dispose();
    super.dispose();
  }

  void _updateFilterSummaryVisibility() {
    final filterHeight = _filterSectionKey.currentContext?.size?.height;
    if (filterHeight == null) return;
    final threshold =
        widget.topScrollPadding +
        AppSizes.categoryHeaderToFilterGap +
        filterHeight;
    final shouldShow = _scrollController.offset >= threshold;
    if (shouldShow == _showFilterSummary) return;
    setState(() => _showFilterSummary = shouldShow);
  }

  Future<void> _scrollToFilters() {
    return _scrollController.animateTo(
      0,
      duration: AppDurations.normal,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryCubit>();
    final state = widget.state;

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              cubit.onScrollNearEnd(
                notification.metrics.pixels,
                notification.metrics.maxScrollExtent,
              );
            }
            return false;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (widget.topScrollPadding > 0)
                SliverToBoxAdapter(
                  child: SizedBox(height: widget.topScrollPadding),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  key: _filterSectionKey,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSizes.categoryHeaderToFilterGap,
                    AppSpacing.md,
                    AppSizes.categoryFilterSectionVerticalPadding,
                  ),
                  child: CategoryFilterSection(
                    groups: state.domain.filterGroups,
                    selectedIndexFor: state.interaction.selectedIndexFor,
                    onSelect: cubit.selectOption,
                  ),
                ),
              ),
              if (state.ui.isRefreshing)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: _CategoryRefreshIndicator()),
                )
              else if (state.domain.items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(title: CategoryTabBody.emptyTitle),
                )
              else ...[
                CategoryBookList(
                  items: state.domain.items,
                  onItemTap: AppRouter.goBookDetail,
                ),
                CategoryListFooter(isLoadingMore: state.ui.isLoadingMore),
              ],
              if (widget.bottomScrollPadding > 0)
                SliverToBoxAdapter(
                  child: SizedBox(height: widget.bottomScrollPadding),
                ),
            ],
          ),
        ),
        if (_showFilterSummary)
          Positioned(
            top: (widget.topScrollPadding - AppSpacing.md).clamp(
              0,
              double.infinity,
            ),
            left: 0,
            right: 0,
            child: _CategoryFilterSummary(
              state: state,
              onTap: _scrollToFilters,
            ),
          ),
      ],
    );
  }
}

class _CategoryFilterSummary extends StatelessWidget {
  const _CategoryFilterSummary({required this.state, required this.onTap});

  final CategoryState state;
  final VoidCallback onTap;

  String get _label => state.domain.filterGroups
      .map((group) {
        final index = state.interaction.selectedIndexFor(group.id);
        return group.options[index.clamp(0, group.options.length - 1)];
      })
      .join(' · ');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceCard,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: AppText(
                  _label,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(
                Icons.keyboard_arrow_up_rounded,
                size: AppSizes.iconSm,
                color: AppColors.sectionActionIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryRefreshIndicator extends StatelessWidget {
  const _CategoryRefreshIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: AppSizes.bookstoreLoadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
        color: AppColors.accentYellow,
      ),
    );
  }
}
