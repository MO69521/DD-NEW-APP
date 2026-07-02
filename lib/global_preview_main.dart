import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

/// 全局 Web 预览入口：通过 URL 参数切换页面。
///
/// 示例：
/// - `/` 或 `/?tab=0` — 书城 Tab
/// - `/?route=/editor-pick` — 编辑推荐详情
/// - `/?route=/ranking` — 榜单详情
/// - `/?tab=3&bookshelfTab=history` — 书架 · 阅读历史
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setInitialLocation(_resolveInitialLocation());
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GlobalPreviewApp());
}

String _resolveInitialLocation() {
  final uri = Uri.base;
  final route = uri.queryParameters['route'];
  if (route != null && route.isNotEmpty) {
    return route.startsWith('/') ? route : '/$route';
  }

  final tab = uri.queryParameters['tab'];
  if (tab != null && tab.isNotEmpty) {
    final params = Map<String, String>.from(uri.queryParameters);
    final query = params.entries
        .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return query.isEmpty ? AppRoutes.home : '${AppRoutes.home}?$query';
  }

  return AppRoutes.home;
}

class GlobalPreviewApp extends StatelessWidget {
  const GlobalPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '点点穿书 · 全局预览',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
