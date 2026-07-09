import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/book_card_skeletons.dart';
import '../../../../shared/components/empty_state.dart';
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

class _CategoryTabContent extends StatelessWidget {
  const _CategoryTabContent({
    required this.state,
    required this.topScrollPadding,
    required this.bottomScrollPadding,
  });

  final CategoryState state;
  final double topScrollPadding;
  final double bottomScrollPadding;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoryCubit>();

    return NotificationListener<ScrollNotification>(
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
        slivers: [
          if (topScrollPadding > 0)
            SliverToBoxAdapter(child: SizedBox(height: topScrollPadding)),
          SliverToBoxAdapter(
            child: Padding(
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
          if (bottomScrollPadding > 0)
            SliverToBoxAdapter(child: SizedBox(height: bottomScrollPadding)),
        ],
      ),
    );
  }
}

class _CategoryRefreshIndicator extends StatelessWidget {
  const _CategoryRefreshIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSizes.bookstoreLoadingIndicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: AppSizes.bookstoreLoadingIndicatorStrokeWidth,
        color: AppColors.accentYellow,
      ),
    );
  }
}
