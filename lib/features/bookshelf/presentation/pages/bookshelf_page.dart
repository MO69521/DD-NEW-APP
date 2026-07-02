import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/main_tab_config.dart';
import '../../../../core/constants/bookshelf_tab_intent.dart';
import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_bottom_nav.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/layouts/main_tab_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/bookshelf_cubit.dart';
import '../../application/bookshelf_state.dart';
import '../../domain/entities/bookshelf_tab.dart';
import '../components/bookshelf_book_grid.dart';
import '../components/bookshelf_empty_view.dart';
import '../components/bookshelf_header_delegate.dart';
import '../components/bookshelf_load_more_footer.dart';
import '../components/bookshelf_manage_action_overlay.dart';
import '../components/bookshelf_page_header.dart';
import '../components/bookshelf_recommendation_section.dart';
import '../components/daily_reading_banner.dart';
import '../../../../core/theme/app_colors.dart';

/// 书架页（Figma 220:9341）：仅渲染 state、触发 action。
class BookshelfPage extends StatelessWidget {
  const BookshelfPage({super.key, this.mainTabController});

  final MainTabController? mainTabController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookshelfCubit, BookshelfState>(
      buildWhen: (previous, current) {
        final loadingChanged = previous.ui.isLoading != current.ui.isLoading;
        final errorChanged =
            previous.ui.errorMessage != current.ui.errorMessage;
        final contentAvailabilityChanged =
            (previous.domain.content == null) !=
            (current.domain.content == null);
        return loadingChanged || errorChanged || contentAvailabilityChanged;
      },
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
                onPressed: () => context.read<BookshelfCubit>().load(),
              ),
            ),
          );
        }

        final content = state.domain.content;
        if (content == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: const EmptyState(title: '暂无数据'),
          );
        }

        return _BookshelfView(mainTabController: mainTabController);
      },
    );
  }
}

class _BookshelfView extends StatefulWidget {
  const _BookshelfView({this.mainTabController});

  final MainTabController? mainTabController;

  static const double _bottomNavReserve =
      AppBottomNav.barHeight + AppSpacing.xl;

  @override
  State<_BookshelfView> createState() => _BookshelfViewState();
}

class _BookshelfViewState extends State<_BookshelfView> {
  late final ScrollController _scrollController;
  late final void Function(int index) _tabChangeListener;
  late final void Function(String tabIntent) _bookshelfTabIntentListener;

  BookshelfTab _tabFromIntent(String tabIntent) {
    return tabIntent == BookshelfTabIntent.history
        ? BookshelfTab.history
        : BookshelfTab.shelf;
  }

  void _applyBookshelfTabIntent(String tabIntent) {
    if (!mounted) return;
    context.read<BookshelfCubit>().switchTab(_tabFromIntent(tabIntent));
    _scheduleScrollCheck();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _tabChangeListener = (index) {
      if (index == MainTabConfig.bookshelfIndex) {
        _scheduleScrollCheck();
      }
    };
    _bookshelfTabIntentListener = _applyBookshelfTabIntent;
    widget.mainTabController?.addTabChangeListener(_tabChangeListener);
    widget.mainTabController?.addBookshelfTabIntentListener(
      _bookshelfTabIntentListener,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void dispose() {
    widget.mainTabController?.removeTabChangeListener(_tabChangeListener);
    widget.mainTabController?.removeBookshelfTabIntentListener(
      _bookshelfTabIntentListener,
    );
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    context.read<BookshelfCubit>().onScrollNearEnd(
      _scrollController.position.extentAfter,
    );
  }

  void _scheduleScrollCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _handleScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final headerHeight = statusBarHeight + AppSizes.bookshelfHeaderHeight;
    final gridWidth = MediaQuery.sizeOf(context).width - AppSpacing.sm * 2;

    return BlocListener<BookshelfCubit, BookshelfState>(
      listenWhen: (previous, current) =>
          previous.recommendationBooks != current.recommendationBooks ||
          previous.interaction.selectedTab != current.interaction.selectedTab ||
          previous.ui.isLoadingMore != current.ui.isLoadingMore,
      listener: (_, state) => _scheduleScrollCheck(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: BookshelfHeaderDelegate(
                    height: headerHeight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: statusBarHeight),
                        BlocSelector<
                          BookshelfCubit,
                          BookshelfState,
                          ({BookshelfTab selectedTab, bool isManaging})
                        >(
                          selector: (state) => (
                            selectedTab: state.interaction.selectedTab,
                            isManaging: state.interaction.isManaging,
                          ),
                          builder: (context, data) {
                            return BookshelfPageHeader(
                              selectedTab: data.selectedTab,
                              isManaging: data.isManaging,
                              onTabSelected: context
                                  .read<BookshelfCubit>()
                                  .switchTab,
                              onManageTap: context
                                  .read<BookshelfCubit>()
                                  .onManageTap,
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
                        height: AppSizes.bookshelfHeaderToBannerGap,
                      ),
                      BlocSelector<BookshelfCubit, BookshelfState, int>(
                        selector: (state) => state.domain.todayReadingMinutes,
                        builder: (context, minutes) {
                          return DailyReadingBanner(
                            todayReadingMinutes: minutes,
                            onClaimWelfareTap: () => widget.mainTabController
                                ?.switchTo(MainTabConfig.welfareIndex),
                          );
                        },
                      ),
                      const SizedBox(height: AppSizes.bookshelfBannerToGridGap),
                    ]),
                  ),
                ),
                BlocBuilder<BookshelfCubit, BookshelfState>(
                  buildWhen: (previous, current) =>
                      previous.domain.content != current.domain.content ||
                      previous.interaction.selectedTab !=
                          current.interaction.selectedTab ||
                      previous.interaction.isManaging !=
                          current.interaction.isManaging ||
                      previous.interaction.selectedBookIds !=
                          current.interaction.selectedBookIds,
                  builder: (context, state) {
                    final tab = state.interaction.selectedTab;
                    final books =
                        state.domain.content?.booksFor(tab) ?? const <Book>[];
                    final isShelfTab = tab == BookshelfTab.shelf;

                    if (isShelfTab &&
                        books.isEmpty &&
                        !state.interaction.isManaging) {
                      return SliverToBoxAdapter(
                        child: BookshelfEmptyView(
                          onExploreTap: widget
                              .mainTabController
                              ?.openBookstoreCategoryTab,
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
                        onBookTap: (book) =>
                            AppRouter.goBookDetail(book, isInShelf: isShelfTab),
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
                      previous.interaction.selectedTab !=
                          current.interaction.selectedTab ||
                      previous.interaction.isManaging !=
                          current.interaction.isManaging,
                  builder: (context, state) {
                    if (state.interaction.selectedTab != BookshelfTab.shelf ||
                        state.interaction.isManaging) {
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
                          onBookTap: AppRouter.goBookDetail,
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<BookshelfCubit, BookshelfState>(
                  buildWhen: (previous, current) =>
                      previous.ui.isLoadingMore != current.ui.isLoadingMore ||
                      previous.interaction.selectedTab !=
                          current.interaction.selectedTab,
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: BookshelfLoadMoreFooter(
                        isVisible:
                            state.ui.isLoadingMore &&
                            state.interaction.selectedTab == BookshelfTab.shelf,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: _BookshelfView._bottomNavReserve),
                ),
              ],
            ),
            const BookshelfManageActionOverlay(),
          ],
        ),
      ),
    );
  }
}
