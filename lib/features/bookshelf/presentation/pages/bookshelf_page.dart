import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/main_tab_config.dart';
import '../../../../core/domain/entities/book.dart';
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
import '../components/bookshelf_page_header.dart';
import '../components/daily_reading_banner.dart';
import '../../../../core/theme/app_colors.dart';

/// 书架页（Figma 220:9341）：仅渲染 state、触发 action。
class BookshelfPage extends StatelessWidget {
  const BookshelfPage({
    super.key,
    this.mainTabController,
  });

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

        return _BookshelfView(
          mainTabController: mainTabController,
        );
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _tabChangeListener = (index) {
      if (index == MainTabConfig.bookshelfIndex) {
        _scheduleScrollCheck();
      }
    };
    widget.mainTabController?.addTabChangeListener(_tabChangeListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void dispose() {
    widget.mainTabController?.removeTabChangeListener(_tabChangeListener);
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
    final topInset = MediaQuery.paddingOf(context).top;
    final statusBarHeight = topInset > 0
        ? topInset
        : AppSizes.statusBarPlaceholderHeight;
    final headerHeight =
        statusBarHeight + AppSizes.bookshelfHeaderHeight;
    final gridWidth =
        MediaQuery.sizeOf(context).width - AppSpacing.sm * 2;

    return BlocListener<BookshelfCubit, BookshelfState>(
      listenWhen: (previous, current) =>
          previous.paginatedBooksByTab != current.paginatedBooksByTab ||
          previous.interaction.selectedTab != current.interaction.selectedTab ||
          previous.ui.isLoadingMore != current.ui.isLoadingMore,
      listener: (_, __) => _scheduleScrollCheck(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _BookshelfHeaderDelegate(
                height: headerHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: statusBarHeight),
                    BlocSelector<BookshelfCubit, BookshelfState, ({
                      BookshelfTab selectedTab,
                      bool isManaging,
                    })>(
                      selector: (state) => (
                        selectedTab: state.interaction.selectedTab,
                        isManaging: state.interaction.isManaging,
                      ),
                      builder: (context, data) {
                        return BookshelfPageHeader(
                          selectedTab: data.selectedTab,
                          isManaging: data.isManaging,
                          onTabSelected:
                              context.read<BookshelfCubit>().switchTab,
                          onManageTap:
                              context.read<BookshelfCubit>().onManageTap,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: AppSizes.bookshelfHeaderToBannerGap),
                  BlocSelector<BookshelfCubit, BookshelfState, int>(
                    selector: (state) => state.domain.todayReadingMinutes,
                    builder: (context, minutes) {
                      return DailyReadingBanner(
                        todayReadingMinutes: minutes,
                        onClaimWelfareTap: () =>
                            widget.mainTabController?.switchTo(
                          MainTabConfig.welfareIndex,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSizes.bookshelfBannerToGridGap),
                ]),
              ),
            ),
            BlocBuilder<BookshelfCubit, BookshelfState>(
              buildWhen: (previous, current) =>
                  previous.paginatedBooksByTab !=
                      current.paginatedBooksByTab ||
                  previous.interaction.selectedTab !=
                      current.interaction.selectedTab ||
                  previous.interaction.isManaging !=
                      current.interaction.isManaging,
              builder: (context, state) {
                final tab = state.interaction.selectedTab;
                final books =
                    state.paginatedBooksByTab[tab] ??
                    state.domain.content?.booksFor(tab) ??
                    const <Book>[];

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  sliver: BookshelfBookGrid.sliver(
                    books: books,
                    gridWidth: gridWidth,
                    onBookTap: state.interaction.isManaging
                        ? null
                        : AppRouter.goBookDetail,
                  ),
                );
              },
            ),
            BlocBuilder<BookshelfCubit, BookshelfState>(
              buildWhen: (previous, current) =>
                  previous.ui.isLoadingMore != current.ui.isLoadingMore,
              builder: (context, state) {
                if (!state.ui.isLoadingMore) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: Center(
                      child: SizedBox(
                        width: AppSizes.bookstoreLoadingIndicatorSize,
                        height: AppSizes.bookstoreLoadingIndicatorSize,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              AppSizes.bookstoreLoadingIndicatorStrokeWidth,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: _BookshelfView._bottomNavReserve),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookshelfHeaderDelegate extends SliverPersistentHeaderDelegate {
  _BookshelfHeaderDelegate({
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
    return ColoredBox(
      color: AppColors.backgroundDark,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _BookshelfHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
