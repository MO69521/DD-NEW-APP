import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/ranking/index.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/bookstore_cubit.dart';
import '../../application/bookstore_state.dart';
import '../../../../core/domain/entities/book.dart';
import '../components/bookstore_search_header.dart';
import '../components/editor_pick_section.dart';
import '../components/guess_like_section.dart';
import '../components/ranking_section.dart';
import '../../../../core/theme/app_colors.dart';

/// 书城榜单 Tab → 榜单详情页维度映射（飙升榜在详情页归入人气榜）。
RankingDimension _rankingDimensionForTab(RankingTab tab) => switch (tab) {
      RankingTab.recommend => RankingDimension.recommend,
      RankingTab.popular => RankingDimension.popular,
      RankingTab.rising => RankingDimension.popular,
      RankingTab.completed => RankingDimension.completed,
    };

/// 书城推荐页：仅渲染 state、触发 action。
class BookstorePage extends StatelessWidget {
  const BookstorePage({super.key});

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookstoreCubit, BookstoreState>(
      buildWhen: (previous, current) =>
          previous.ui != current.ui || previous.domain != current.domain,
      builder: (context, state) {
        if (state.ui.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.ui.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: EmptyState(
              title: '加载失败',
              description: state.ui.errorMessage,
              action: AppButton(
                label: '重试',
                onPressed: () => context.read<BookstoreCubit>().load(),
              ),
            ),
          );
        }

        return const _BookstoreView();
      },
    );
  }
}

class _BookstoreView extends StatelessWidget {
  const _BookstoreView();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBarHeight = topInset > 0
        ? topInset
        : AppSizes.statusBarPlaceholderHeight;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis != Axis.vertical) return false;
          context.read<BookstoreCubit>().onScrollNearEnd(
            notification.metrics.pixels,
            notification.metrics.maxScrollExtent,
          );
          return false;
        },
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _BookstoreSearchHeaderDelegate(
                height:
                    statusBarHeight + AppSizes.bookstoreStickyHeaderHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: statusBarHeight),
                    BlocSelector<BookstoreCubit, BookstoreState, String>(
                      selector: (state) => state.domain.searchPlaceholder,
                      builder: (context, placeholder) {
                        return BookstoreSearchHeader(
                          placeholder: placeholder,
                          onSearchTap: () =>
                              AppRouter.pushNamed(AppRoutes.searchName),
                          onCategoryTap: () =>
                              AppRouter.pushNamed(AppRoutes.categoryName),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(
                    height: AppSizes.bookstoreHeaderToFirstSectionGap,
                  ),
                  BlocSelector<BookstoreCubit, BookstoreState, ({
                    RankingTab selectedTab,
                    Map<RankingTab, List<Book>> booksByTab,
                  })>(
                    selector: (state) => (
                      selectedTab: state.interaction.selectedRankingTab,
                      booksByTab: state.domain.rankingBooksByTab,
                    ),
                    builder: (context, data) {
                      return RankingSection(
                        booksByTab: data.booksByTab,
                        selectedTab: data.selectedTab,
                        onTabSelected: context
                            .read<BookstoreCubit>()
                            .switchRankingTab,
                        onBookTap: AppRouter.goBookDetail,
                        onFullListTap: () => AppRouter.pushNamed(
                          AppRoutes.rankingName,
                          extra: _rankingDimensionForTab(data.selectedTab),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocSelector<BookstoreCubit, BookstoreState, List<Book>>(
                    selector: (state) => state.domain.editorPicks,
                    builder: (context, books) {
                      return EditorPickSection(
                        books: books,
                        onBookTap: AppRouter.goBookDetail,
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  BlocBuilder<BookstoreCubit, BookstoreState>(
                    buildWhen: (previous, current) =>
                        previous.guessLikeBooks != current.guessLikeBooks ||
                        previous.ui.isLoadingMoreGuessLike !=
                            current.ui.isLoadingMoreGuessLike,
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GuessLikeSection(
                            books: state.guessLikeBooks,
                            onBookTap: AppRouter.goBookDetail,
                          ),
                          if (state.ui.isLoadingMoreGuessLike) ...[
                            const SizedBox(height: AppSpacing.md),
                            const Center(
                              child: SizedBox(
                                width:
                                    AppSizes.bookstoreLoadingIndicatorSize,
                                height:
                                    AppSizes.bookstoreLoadingIndicatorSize,
                                child: CircularProgressIndicator(
                                  strokeWidth: AppSizes
                                      .bookstoreLoadingIndicatorStrokeWidth,
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: BookstorePage._bottomNavReserve),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookstoreSearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _BookstoreSearchHeaderDelegate({
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
    return Container(
      color: AppColors.backgroundDark,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _BookstoreSearchHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
