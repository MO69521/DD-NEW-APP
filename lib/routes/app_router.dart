import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/main_tab_config.dart';
import '../core/domain/entities/book.dart';
import '../features/book_detail/index.dart';
import '../features/category/index.dart';
import '../features/membership/index.dart';
import '../features/ranking/index.dart';
import '../features/search/index.dart';
import 'app_routes.dart';
import 'pages/main_tab_shell_page.dart';

/// 集中式路由管理，禁止在 UI 中直接使用 Navigator.push。
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static String _initialLocation = AppRoutes.home;
  static GoRouter? _routerInstance;

  /// 在首次访问 [router] 前调用，用于预览入口指定初始 Tab（如 `/?tab=1`）。
  static void setInitialLocation(String location) {
    assert(
      _routerInstance == null,
      'AppRouter.setInitialLocation must be called before router is accessed',
    );
    _initialLocation = location;
  }

  static GoRouter get router => _routerInstance ??= _createRouter();

  static GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: _initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) {
            final tabParam = state.uri.queryParameters['tab'];
            final initialIndex = int.tryParse(tabParam ?? '') ?? 0;
            final maxIndex = MainTabConfig.items.length - 1;
            return MainTabShellPage(
              initialIndex: initialIndex.clamp(0, maxIndex),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.ranking,
          name: AppRoutes.rankingName,
          builder: (context, state) {
            final extra = state.extra;
            final initialDimension = extra is RankingDimension
                ? extra
                : RankingDimension.recommend;
            return BlocProvider(
              create: (_) =>
                  RankingCubit(initialDimension: initialDimension)..load(),
              child: const RankingPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.search,
          name: AppRoutes.searchName,
          builder: (context, state) => BlocProvider(
            create: (_) => SearchCubit(),
            child: const SearchPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.category,
          name: AppRoutes.categoryName,
          builder: (context, state) => BlocProvider(
            create: (_) => CategoryCubit()..load(),
            child: const CategoryPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.membership,
          name: AppRoutes.membershipName,
          builder: (context, state) => BlocProvider(
            create: (_) => MembershipCubit()..load(),
            child: const MembershipPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.rechargeRecords,
          name: AppRoutes.rechargeRecordsName,
          builder: (context, state) => const RechargeRecordsPage(),
        ),
        GoRoute(
          path: AppRoutes.bookDetail,
          name: AppRoutes.bookDetailName,
          builder: (context, state) {
            final bookId = state.pathParameters['id'] ?? '';
            final extra = state.extra;
            final seed = extra is Book ? extra : null;
            return BlocProvider(
              create: (_) =>
                  BookDetailCubit(bookId: bookId, seedBook: seed)..load(),
              child: const BookDetailPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.bookDiscussionDetail,
          name: AppRoutes.bookDiscussionDetailName,
          builder: (context, state) {
            final extra = state.extra;
            final post = extra is BookDiscussionPost ? extra : null;
            if (post == null) {
              return const BookDiscussionDetailPage(post: null);
            }
            return BlocProvider(
              create: (_) => BookDiscussionDetailCubit(post: post),
              child: BookDiscussionDetailPage(post: post),
            );
          },
        ),
      ],
    );
  }

  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  /// 书籍详情页跳转入口：所有书卡点击统一走此方法，携带书籍以渲染真实封面。
  static void goBookDetail(Book book) {
    router.pushNamed(
      AppRoutes.bookDetailName,
      pathParameters: {'id': book.id},
      extra: book,
    );
  }

  static void pushBookDiscussionDetail({
    required String bookId,
    required BookDiscussionPost post,
  }) {
    router.pushNamed(
      AppRoutes.bookDiscussionDetailName,
      pathParameters: {'id': bookId, 'postId': post.id},
      extra: post,
    );
  }

  static void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    router.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void pop<T extends Object?>([T? result]) {
    router.pop(result);
  }
}
