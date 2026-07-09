import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/domain/entities/book.dart';
import '../features/book_detail/index.dart';
import 'app_routes.dart';
import 'groups/account_settings_routes.dart';
import 'groups/book_detail_routes.dart';
import 'groups/discovery_routes.dart';
import 'groups/membership_wallet_routes.dart';
import 'groups/root_routes.dart';
import 'route_extras.dart';

export 'route_extras.dart';

/// 集中式路由管理，禁止在 UI 中直接使用 Navigator.push。
///
/// 路由定义按 feature 分组于 `routes/groups/*`，此处仅负责组合与统一跳转入口。
abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static String _initialLocation = AppRoutes.splash;
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
      overridePlatformDefaultLocation: true,
      routes: [
        ...rootRoutes(),
        ...discoveryRoutes(),
        ...bookDetailRoutes(),
        ...membershipWalletRoutes(),
        ...accountSettingsRoutes(),
      ],
    );
  }

  static void go(String location, {Object? extra}) {
    router.go(location, extra: extra);
  }

  /// 书籍详情页跳转入口：所有书卡点击统一走此方法，携带书籍以渲染真实封面。
  static void goBookDetail(Book book, {bool isInShelf = false}) {
    router.pushNamed(
      AppRoutes.bookDetailName,
      pathParameters: {'id': book.id},
      extra: BookDetailRouteExtra(book: book, isInShelf: isInShelf),
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
