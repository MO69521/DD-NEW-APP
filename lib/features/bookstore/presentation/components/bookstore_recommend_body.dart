import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../application/bookstore_cubit.dart';
import '../../application/bookstore_state.dart';
import '../../domain/entities/bookstore_top_tab.dart';
import 'bookstore_refresh_visual.dart';
import '../components/editor_pick_section.dart';
import '../components/guess_like_section.dart';
import '../components/limited_free_section.dart';
import '../components/ranking_section.dart';

Widget _buildBookstoreRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  final progress = (pulledExtent / refreshTriggerPullDistance)
      .clamp(0.0, 1.0)
      .toDouble();
  return Center(
    child: BookstoreRefreshVisual(
      refreshState: refreshState,
      progress: progress,
    ),
  );
}

/// 书城「推荐」Tab 滚动内容：推荐榜 + 编辑推荐 + 猜你喜欢。
class BookstoreRecommendBody extends StatefulWidget {
  const BookstoreRecommendBody({super.key});

  @override
  State<BookstoreRecommendBody> createState() => _BookstoreRecommendBodyState();
}

class _BookstoreRecommendBodyState extends State<BookstoreRecommendBody> {
  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;
  bool _didPrecacheRefreshFrames = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheRefreshFrames) return;
    _didPrecacheRefreshFrames = true;
    precacheBookstoreRefreshFrames(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookstoreCubit>();
    final chromeTopHeight = AppLayout.chromeTopHeight(
      context,
      barHeight: AppSizes.bookstoreTopHeaderHeight,
    );
    final topInset =
        chromeTopHeight + AppSizes.bookstoreHeaderToFirstSectionGap;
    final refreshIndicatorExtent = chromeTopHeight - AppSpacing.md;
    final refreshTriggerPullDistance = chromeTopHeight + AppSpacing.xl;

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
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: refreshTriggerPullDistance,
            refreshIndicatorExtent: refreshIndicatorExtent,
            builder: _buildBookstoreRefreshIndicator,
            onRefresh: cubit.refresh,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: topInset),
                BlocSelector<
                  BookstoreCubit,
                  BookstoreState,
                  ({
                    RankingTab selectedTab,
                    Map<RankingTab, List<Book>> booksByTab,
                  })
                >(
                  selector: (state) => (
                    selectedTab: state.interaction.selectedRankingTab,
                    booksByTab: state.domain.rankingBooksByTab,
                  ),
                  builder: (context, data) {
                    return RankingSection(
                      booksByTab: data.booksByTab,
                      selectedTab: data.selectedTab,
                      onTabSelected: cubit.switchRankingTab,
                      onBookTap: (book, heroTag) =>
                          AppRouter.goBookDetail(book, coverHeroTag: heroTag),
                      onFullListTap: () =>
                          cubit.switchTopTab(BookstoreTopTab.ranking),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                BlocSelector<BookstoreCubit, BookstoreState, List<Book>>(
                  selector: (state) => state.domain.editorPicks,
                  builder: (context, books) {
                    return LimitedFreeSection(
                      books: books,
                      onMoreTap: () => AppRouter.pushNamed(
                        AppRoutes.editorPickName,
                        extra: '限时免费',
                      ),
                      onBookTap: (book, heroTag) =>
                          AppRouter.goBookDetail(book, coverHeroTag: heroTag),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                BlocSelector<BookstoreCubit, BookstoreState, List<Book>>(
                  selector: (state) => state.domain.editorPicks,
                  builder: (context, books) {
                    return EditorPickSection(
                      books: books,
                      onMoreTap: () =>
                          AppRouter.pushNamed(AppRoutes.editorPickName),
                      onBookTap: (book, heroTag) =>
                          AppRouter.goBookDetail(book, coverHeroTag: heroTag),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
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
                          onBookTap: (book, heroTag) => AppRouter.goBookDetail(
                            book,
                            coverHeroTag: heroTag,
                          ),
                        ),
                        if (state.ui.isLoadingMoreGuessLike) ...[
                          const SizedBox(height: AppSpacing.md),
                          const Center(
                            child: SizedBox(
                              width: AppSizes.bookstoreLoadingIndicatorSize,
                              height: AppSizes.bookstoreLoadingIndicatorSize,
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
                const SizedBox(height: _bottomNavReserve),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
