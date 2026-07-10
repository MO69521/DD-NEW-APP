import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/empty_state.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/layouts/main_tab_controller.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/bookstore_cubit.dart';
import '../../application/bookstore_state.dart';
import '../../domain/entities/bookstore_top_tab.dart';
import '../components/bookstore_page_header.dart';
import '../components/bookstore_recommend_body.dart';
import '../components/continue_reading_card.dart';

/// 书城推荐页：仅渲染 state、触发 action。
class BookstorePage extends StatelessWidget {
  const BookstorePage({
    super.key,
    required this.categoryTabBuilder,
    required this.rankingTabBuilder,
    this.mainTabController,
  });

  final WidgetBuilder categoryTabBuilder;
  final WidgetBuilder rankingTabBuilder;
  final MainTabController? mainTabController;

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

        return _BookstoreView(
          categoryTabBuilder: categoryTabBuilder,
          rankingTabBuilder: rankingTabBuilder,
          mainTabController: mainTabController,
        );
      },
    );
  }
}

/// 顶栏 Tab 翻页手势行为：允许触摸/鼠标/触控板/触控笔拖动翻页，
/// 使左右滑动在原生、移动端浏览器与桌面 Web 预览下均生效。
class _TopTabSwipeScrollBehavior extends MaterialScrollBehavior {
  const _TopTabSwipeScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };
}

class _BookstoreView extends StatefulWidget {
  const _BookstoreView({
    required this.categoryTabBuilder,
    required this.rankingTabBuilder,
    this.mainTabController,
  });

  final WidgetBuilder categoryTabBuilder;
  final WidgetBuilder rankingTabBuilder;
  final MainTabController? mainTabController;

  @override
  State<_BookstoreView> createState() => _BookstoreViewState();
}

class _BookstoreViewState extends State<_BookstoreView> {
  late final void Function() _bookstoreCategoryIntentListener;
  late final PageController _pageController;
  late final ValueNotifier<double> _topTabSwipeProgress;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: context
          .read<BookstoreCubit>()
          .state
          .interaction
          .selectedTopTab
          .index,
    );
    _topTabSwipeProgress = ValueNotifier<double>(
      context
          .read<BookstoreCubit>()
          .state
          .interaction
          .selectedTopTab
          .index
          .toDouble(),
    );
    _bookstoreCategoryIntentListener = () {
      if (!mounted) return;
      context.read<BookstoreCubit>().switchTopTab(BookstoreTopTab.category);
    };
    widget.mainTabController?.addBookstoreCategoryIntentListener(
      _bookstoreCategoryIntentListener,
    );
  }

  @override
  void dispose() {
    widget.mainTabController?.removeBookstoreCategoryIntentListener(
      _bookstoreCategoryIntentListener,
    );
    _pageController.dispose();
    _topTabSwipeProgress.dispose();
    super.dispose();
  }

  void _updateTopTabSwipeProgress() {
    if (!_pageController.hasClients || _pageController.page == null) return;
    _topTabSwipeProgress.value = _pageController.page!
        .clamp(0, BookstoreTopTab.values.length - 1)
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);
    final cubit = context.read<BookstoreCubit>();

    return BlocListener<BookstoreCubit, BookstoreState>(
      listenWhen: (previous, current) =>
          previous.interaction.selectedTopTab !=
          current.interaction.selectedTopTab,
      listener: (context, state) {
        if (!_pageController.hasClients) return;
        _pageController.animateToPage(
          state.interaction.selectedTopTab.index,
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Stack(
          children: [
            BlocSelector<BookstoreCubit, BookstoreState, BookstoreTopTab>(
              selector: (state) => state.interaction.selectedTopTab,
              builder: (context, selectedTopTab) {
                return AppPageChrome(
                  topBar: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: statusBarHeight),
                      BookstorePageHeader(
                        selectedTopTab: selectedTopTab,
                        onTopTabSelected: cubit.switchTopTab,
                        swipeProgress: _topTabSwipeProgress,
                        onSearchTap: () =>
                            AppRouter.pushNamed(AppRoutes.searchName),
                      ),
                    ],
                  ),
                  body: ScrollConfiguration(
                    behavior: const _TopTabSwipeScrollBehavior(),
                    // 仅在滚动结束（松手落页）后切换 Tab，拖动过程中不中途翻页。
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (notification) {
                        if (!_pageController.hasClients ||
                            _pageController.page == null) {
                          return false;
                        }
                        final target = _pageController.page!.round().clamp(
                          0,
                          BookstoreTopTab.values.length - 1,
                        );
                        if (target != selectedTopTab.index) {
                          cubit.switchTopTab(BookstoreTopTab.values[target]);
                        }
                        return false;
                      },
                      child: NotificationListener<ScrollUpdateNotification>(
                        onNotification: (notification) {
                          _updateTopTabSwipeProgress();
                          return false;
                        },
                        child: PageView(
                          controller: _pageController,
                          physics: const PageScrollPhysics(),
                          children: [
                            const BookstoreRecommendBody(),
                            widget.categoryTabBuilder(context),
                            widget.rankingTabBuilder(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSizes.bottomNavBarHeight + AppSpacing.xs,
              child: BlocBuilder<BookstoreCubit, BookstoreState>(
                buildWhen: (previous, current) =>
                    previous.domain.continueReadingBook !=
                        current.domain.continueReadingBook ||
                    previous.interaction.continueReadingDismissed !=
                        current.interaction.continueReadingDismissed,
                builder: (context, state) {
                  final book = state.domain.continueReadingBook;
                  if (book == null ||
                      state.interaction.continueReadingDismissed) {
                    return const SizedBox.shrink();
                  }
                  return ContinueReadingCard(
                    book: book,
                    onContinue: () => AppRouter.goBookDetail(
                      book,
                      coverHeroTag: ContinueReadingCard.heroTagFor(book),
                    ),
                    onClose: cubit.dismissContinueReading,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
