import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/empty_state.dart';
import '../../application/category_cubit.dart';
import '../../application/category_state.dart';
import '../../application/category_ui_state.dart';
import '../components/category_book_list.dart';
import '../components/category_filter_section.dart';
import '../components/category_list_footer.dart';

/// 分类页（深色态）：仅渲染 state、触发 action。
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  static const String _title = '分类';
  static const String _emptyTitle = '暂无作品';

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBarHeight =
        topInset > 0 ? topInset : AppSizes.statusBarPlaceholderHeight;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Column(
        children: [
          AppTopBar(
            statusBarHeight: statusBarHeight,
            title: _title,
            onBack: AppRouter.pop,
          ),
          const Expanded(child: _CategoryBody()),
        ],
      ),
    );
  }
}

class _CategoryBody extends StatelessWidget {
  const _CategoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        switch (state.ui.phase) {
          case CategoryPhase.loading:
            return const Center(child: CircularProgressIndicator());
          case CategoryPhase.empty:
            return EmptyState(
              title: CategoryPage._emptyTitle,
              description: state.ui.errorMessage,
            );
          case CategoryPhase.loaded:
            return _CategoryContent(state: state);
        }
      },
    );
  }
}

class _CategoryContent extends StatelessWidget {
  const _CategoryContent({required this.state});

  final CategoryState state;

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
          CategoryBookList(
            items: state.domain.items,
            onItemTap: AppRouter.goBookDetail,
          ),
          CategoryListFooter(isLoadingMore: state.ui.isLoadingMore),
        ],
      ),
    );
  }
}
