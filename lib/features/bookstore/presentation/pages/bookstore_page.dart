import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
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
        _pageController.animateToPage(
          state.interaction.selectedTopTab.index,
          duration: AppDurations.normal,
          curve: Curves.easeOut,
        );
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
              body: PageView(
                controller: _pageController,
                physics: const _BookstoreTopTabPagePhysics(),
                onPageChanged: (index) {
                  cubit.switchTopTab(BookstoreTopTab.values[index]);
                },
                children: [
                  const BookstoreRecommendBody(),
                  widget.categoryTabBuilder(context),
                  widget.rankingTabBuilder(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BookstoreTopTabPagePhysics extends PageScrollPhysics {
  const _BookstoreTopTabPagePhysics({super.parent});

  @override
  _BookstoreTopTabPagePhysics applyTo(ScrollPhysics? ancestor) {
    return _BookstoreTopTabPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => SpringDescription.withDampingRatio(
    mass: 0.7,
    stiffness: 260,
    ratio: 1.15,
  );

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final tolerance = toleranceFor(position);
    final page = position.pixels / position.viewportDimension;
    final currentPage = page.round();
    var targetPage = page;

    if (velocity < -tolerance.velocity) {
      targetPage -= 0.5;
    } else if (velocity > tolerance.velocity) {
      targetPage += 0.5;
    }

    final nearestTarget = targetPage.round();
    final clampedTarget = nearestTarget.clamp(currentPage - 1, currentPage + 1);
    final targetPixels = (clampedTarget * position.viewportDimension).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );

    if ((targetPixels - position.pixels).abs() < tolerance.distance) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      targetPixels.toDouble(),
      velocity,
      tolerance: tolerance,
    );
  }
}
