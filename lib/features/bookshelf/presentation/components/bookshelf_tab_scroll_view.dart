import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/layouts/main_tab_controller.dart';
import '../../application/bookshelf_cubit.dart';
import '../../application/bookshelf_state.dart';
import '../../domain/entities/bookshelf_tab.dart';
import 'bookshelf_book_grid.dart';
import 'bookshelf_empty_view.dart';
import 'bookshelf_load_more_footer.dart';
import 'bookshelf_page_scroll_gradient.dart';
import 'bookshelf_recommendation_section.dart';

/// L3 — 书架单个 Tab（书架 / 阅读历史）的滚动内容区。
///
/// 顶部预留 [headerHeight] 给固定顶栏（含吸顶「今日已阅读」横幅）；仅渲染
/// state、触发 action。白色垂直渐隐叠在滚动内容之下并随滚位移。
class BookshelfTabScrollView extends StatelessWidget {
  const BookshelfTabScrollView({
    super.key,
    required this.tab,
    required this.scrollController,
    required this.headerHeight,
    required this.gridWidth,
    required this.bottomReserve,
    this.mainTabController,
  });

  final BookshelfTab tab;
  final ScrollController scrollController;

  /// 页面固定 Chrome 总高（状态栏 + Header + 横幅区），滚动内容从此高度起排。
  final double headerHeight;
  final double gridWidth;
  final double bottomReserve;
  final MainTabController? mainTabController;

  @override
  Widget build(BuildContext context) {
    final isShelfTab = tab == BookshelfTab.shelf;

    return Stack(
      children: [
        BookshelfPageScrollGradient(scrollController: scrollController),
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: headerHeight)),
            BlocBuilder<BookshelfCubit, BookshelfState>(
              buildWhen: (previous, current) =>
                  previous.domain.content != current.domain.content ||
                  previous.interaction.isManaging !=
                      current.interaction.isManaging ||
                  previous.interaction.selectedBookIds !=
                      current.interaction.selectedBookIds,
              builder: (context, state) {
                final books =
                    state.domain.content?.booksFor(tab) ?? const <Book>[];

                if (isShelfTab &&
                    books.isEmpty &&
                    !state.interaction.isManaging) {
                  return SliverToBoxAdapter(
                    child: BookshelfEmptyView(
                      onExploreTap:
                          mainTabController?.openBookstoreCategoryTab,
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  sliver: BookshelfBookGrid.sliver(
                    books: books,
                    gridWidth: gridWidth,
                    heroNamespace: isShelfTab ? 'shelf' : 'history',
                    onBookTap: (book, heroTag) => AppRouter.goBookDetail(
                      book,
                      isInShelf: isShelfTab,
                      coverHeroTag: heroTag,
                    ),
                    isManaging: state.interaction.isManaging,
                    selectedBookIds: state.interaction.selectedBookIds,
                    onBookSelectionToggle: context
                        .read<BookshelfCubit>()
                        .toggleBookSelection,
                  ),
                );
              },
            ),
            BlocBuilder<BookshelfCubit, BookshelfState>(
              buildWhen: (previous, current) =>
                  previous.recommendationBooks !=
                      current.recommendationBooks ||
                  previous.interaction.isManaging !=
                      current.interaction.isManaging,
              builder: (context, state) {
                if (!isShelfTab || state.interaction.isManaging) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.xl,
                    AppSpacing.sm,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: BookshelfRecommendationSection(
                      books: state.recommendationBooks,
                      onBookTap: (book, heroTag) =>
                          AppRouter.goBookDetail(book, coverHeroTag: heroTag),
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<BookshelfCubit, BookshelfState>(
              buildWhen: (previous, current) =>
                  previous.ui.isLoadingMore != current.ui.isLoadingMore,
              builder: (context, state) {
                return SliverToBoxAdapter(
                  child: BookshelfLoadMoreFooter(
                    isVisible: state.ui.isLoadingMore && isShelfTab,
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: bottomReserve)),
          ],
        ),
      ],
    );
  }
}
