import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/category/index.dart';
import '../../features/editor_pick/index.dart';
import '../../features/ranking/index.dart';
import '../../features/search/index.dart';
import '../app_routes.dart';

/// 发现 / 内容路由：榜单、搜索、分类、编辑推荐。
List<RouteBase> discoveryRoutes() => [
  GoRoute(
    path: AppRoutes.ranking,
    name: AppRoutes.rankingName,
    builder: (context, state) {
      final extra = state.extra;
      final initialDimension = extra is RankingDimension
          ? extra
          : RankingDimension.recommend;
      return BlocProvider(
        create: (_) => RankingCubit(initialDimension: initialDimension)..load(),
        child: const RankingPage(),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.search,
    name: AppRoutes.searchName,
    builder: (context, state) =>
        BlocProvider(create: (_) => SearchCubit(), child: const SearchPage()),
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
    path: AppRoutes.editorPick,
    name: AppRoutes.editorPickName,
    builder: (context, state) {
      final title = state.extra is String ? state.extra as String : '编辑推荐';
      return BlocProvider(
        create: (_) => EditorPickCubit()..load(),
        child: EditorPickPage(title: title),
      );
    },
  ),
];
