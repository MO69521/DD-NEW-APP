import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/main_tab_config.dart';
import '../../features/auth/index.dart';
import '../../features/splash/index.dart';
import '../app_routes.dart';
import '../pages/main_tab_shell_page.dart';

/// 根级路由：启动页、登录、主 Tab 容器。
List<RouteBase> rootRoutes() => [
  GoRoute(
    path: AppRoutes.splash,
    name: AppRoutes.splashName,
    builder: (context, state) => BlocProvider(
      create: (_) => SplashCubit()..start(),
      child: const SplashPage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.login,
    name: AppRoutes.loginName,
    builder: (context, state) => BlocProvider(
      create: (_) => LoginCubit(),
      child: const LoginPage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.home,
    name: AppRoutes.homeName,
    builder: (context, state) {
      final tabParam = state.uri.queryParameters['tab'];
      final initialIndex = int.tryParse(tabParam ?? '') ?? 0;
      final maxIndex = MainTabConfig.items.length - 1;
      return MainTabShellPage(
        initialIndex: initialIndex.clamp(0, maxIndex),
        initialBookshelfTabIntent: state.uri.queryParameters['bookshelfTab'],
        initialBookstoreTopTabIntent:
            state.uri.queryParameters['bookstoreTopTab'],
      );
    },
  ),
];
