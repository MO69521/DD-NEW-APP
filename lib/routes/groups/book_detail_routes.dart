import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain/entities/book.dart';
import '../../features/book_detail/index.dart';
import '../app_routes.dart';
import '../route_extras.dart';

/// 书籍详情相关路由：书籍详情、书评详情。
List<RouteBase> bookDetailRoutes() => [
  GoRoute(
    path: AppRoutes.bookDetail,
    name: AppRoutes.bookDetailName,
    builder: (context, state) {
      final bookId = state.pathParameters['id'] ?? '';
      final extra = state.extra;
      final seed = switch (extra) {
        BookDetailRouteExtra(:final book) => book,
        Book() => extra,
        _ => null,
      };
      final isInShelf = switch (extra) {
        BookDetailRouteExtra(:final isInShelf) => isInShelf,
        _ => state.uri.queryParameters['inShelf'] == '1',
      };
      return BlocProvider(
        create: (_) => BookDetailCubit(
          bookId: bookId,
          seedBook: seed,
          initialIsInShelf: isInShelf,
        )..load(),
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
];
