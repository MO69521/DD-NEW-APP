import 'dart:async';

import 'package:diandian_chuanshu/core/theme/app_durations.dart';
import 'package:diandian_chuanshu/core/theme/app_shared_assets.dart';
import 'package:diandian_chuanshu/core/theme/app_sizes.dart';
import 'package:diandian_chuanshu/core/theme/app_spacing.dart';
import 'package:diandian_chuanshu/features/bookstore/application/bookstore_cubit.dart';
import 'package:diandian_chuanshu/features/bookstore/domain/entities/bookstore_page_content.dart';
import 'package:diandian_chuanshu/features/bookstore/domain/repositories/bookstore_repository.dart';
import 'package:diandian_chuanshu/features/bookstore/presentation/components/bookstore_recommend_body.dart';
import 'package:diandian_chuanshu/features/bookstore/presentation/components/bookstore_refresh_visual.dart';
import 'package:diandian_chuanshu/shared/widgets/app_asset_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _CountingBookstoreRepository implements BookstoreRepository {
  _CountingBookstoreRepository({this.refreshCompleter});

  final Completer<BookstorePageContent>? refreshCompleter;
  int callCount = 0;

  @override
  Future<BookstorePageContent> fetchPageContent() async {
    callCount += 1;
    if (callCount > 1 && refreshCompleter != null) {
      return refreshCompleter!.future;
    }
    return const BookstorePageContent(
      searchPlaceholder: '测试',
      rankingBooksByTab: {},
      editorPicks: [],
      guessLikeBooks: [],
    );
  }
}

void main() {
  testWidgets('推荐页接入可滚动触发的刷新操作', (tester) async {
    final refreshCompleter = Completer<BookstorePageContent>();
    final repository = _CountingBookstoreRepository(
      refreshCompleter: refreshCompleter,
    );
    final cubit = BookstoreCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: BookstoreRecommendBody()),
        ),
      ),
    );

    final refreshControl = tester.widget<CupertinoSliverRefreshControl>(
      find.byType(CupertinoSliverRefreshControl, skipOffstage: false),
    );
    final scrollView = tester.widget<CustomScrollView>(
      find.byType(CustomScrollView),
    );

    expect(scrollView.physics, isA<BouncingScrollPhysics>());
    expect(
      (scrollView.physics! as BouncingScrollPhysics).parent,
      isA<AlwaysScrollableScrollPhysics>(),
    );
    const expectedRefreshExtent =
        AppSizes.statusBarPlaceholderHeight +
        AppSizes.bookstoreTopHeaderHeight -
        AppSpacing.md;
    expect(refreshControl.refreshIndicatorExtent, expectedRefreshExtent);
    expect(
      refreshControl.refreshTriggerPullDistance,
      expectedRefreshExtent + AppSpacing.md + AppSpacing.xl,
    );
    final scrollFinder = find.byType(CustomScrollView);
    final firstCardTitle = find.text('推荐榜');
    final initialCardTop = tester.getTopLeft(firstCardTitle).dy;

    await tester.drag(
      scrollFinder,
      Offset(0, refreshControl.refreshTriggerPullDistance + AppSpacing.xl),
    );
    await tester.pump(AppDurations.slow);

    expect(cubit.state.ui.isRefreshing, isTrue);
    expect(
      tester.getTopLeft(firstCardTitle).dy,
      greaterThan(initialCardTop + AppSpacing.xl),
    );
    expect(find.byType(CupertinoActivityIndicator), findsNothing);
    final refreshVisualFinder = find.byKey(
      const ValueKey('bookstore-refresh-visual'),
    );
    final refreshVisual = tester.widget<Transform>(refreshVisualFinder);
    expect(
      refreshVisual.transform.entry(1, 3),
      AppSpacing.xxl + AppSpacing.xl + AppSpacing.lg,
    );
    final bearFinder = find.descendant(
      of: refreshVisualFinder,
      matching: find.byType(AppAssetImage),
    );
    final currentFrame = tester.widget<AppAssetImage>(bearFinder);
    expect(
      currentFrame.assetPath,
      isIn(AppSharedAssets.bookstoreRefreshBearFrames),
    );
    expect(currentFrame.width, AppSizes.bookstoreRefreshAnimationSize);
    expect(currentFrame.height, AppSizes.bookstoreRefreshAnimationSize);
    expect(
      tester.getCenter(bearFinder).dy,
      lessThan(tester.getTopLeft(firstCardTitle).dy),
    );
    refreshCompleter.complete(
      const BookstorePageContent(
        searchPlaceholder: '刷新完成',
        rankingBooksByTab: {},
        editorPicks: [],
        guessLikeBooks: [],
      ),
    );
    await tester.pump(AppDurations.slow * 2);
    await tester.pumpAndSettle();

    expect(cubit.state.ui.isRefreshing, isFalse);
    expect(refreshVisualFinder, findsNothing);
    expect(tester.getTopLeft(firstCardTitle).dy, closeTo(initialCardTop, 1));
    expect(repository.callCount, 2);
  });

  testWidgets('阈值内按住不松手时小熊持续播放且不触发刷新', (tester) async {
    final repository = _CountingBookstoreRepository();
    final cubit = BookstoreCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.load();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const Scaffold(body: BookstoreRecommendBody()),
        ),
      ),
    );

    final scrollFinder = find.byType(CustomScrollView);
    final gesture = await tester.startGesture(tester.getCenter(scrollFinder));
    const dragSteps = 4;
    for (var step = 0; step < dragSteps; step += 1) {
      await gesture.moveBy(const Offset(0, AppSpacing.lg));
      await tester.pump();
    }

    expect(cubit.state.ui.isRefreshing, isFalse);
    final visualFinder = find.byType(BookstoreRefreshVisual);
    expect(visualFinder, findsOneWidget);
    expect(
      tester.widget<BookstoreRefreshVisual>(visualFinder).refreshState,
      RefreshIndicatorMode.drag,
    );
    final bearFinder = find.descendant(
      of: visualFinder,
      matching: find.byType(AppAssetImage),
    );
    final firstFrame = tester.widget<AppAssetImage>(bearFinder).assetPath;

    await tester.pump(AppDurations.fast);

    expect(
      tester.widget<AppAssetImage>(bearFinder).assetPath,
      isNot(firstFrame),
    );
    expect(cubit.state.ui.isRefreshing, isFalse);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(cubit.state.ui.isRefreshing, isFalse);
  });

  testWidgets('刷新已完成但小熊仍显示时继续循环到完全收起', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: BookstoreRefreshVisual(
              refreshState: RefreshIndicatorMode.done,
              progress: 1,
            ),
          ),
        ),
      ),
    );

    final bearFinder = find.byType(AppAssetImage);
    final firstFrame = tester.widget<AppAssetImage>(bearFinder).assetPath;

    await tester.pump(AppDurations.fast);

    expect(
      tester.widget<AppAssetImage>(bearFinder).assetPath,
      isNot(firstFrame),
    );
  });
}
