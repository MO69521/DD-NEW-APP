import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    super.dispose();
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
        _pageController.jumpToPage(state.interaction.selectedTopTab.index);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: BlocSelector<BookstoreCubit, BookstoreState, BookstoreTopTab>(
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
                    onSearchTap: () =>
                        AppRouter.pushNamed(AppRoutes.searchName),
                  ),
                ],
              ),
              body: ScrollConfiguration(
                behavior: const _TopTabSwipeScrollBehavior(),
                child: PageView(
                  controller: _pageController,
                  physics: const PageScrollPhysics(),
                  onPageChanged: (index) {
                    cubit.switchTopTab(BookstoreTopTab.values[index]);
                  },
                  children: [
                    const BookstoreRecommendBody(),
                    widget.categoryTabBuilder(context),
                    widget.rankingTabBuilder(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
