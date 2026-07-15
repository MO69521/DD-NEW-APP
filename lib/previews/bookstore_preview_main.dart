import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/main_tab_config.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_router.dart';
import '../routes/app_routes.dart';

/// 书城推荐页独立预览入口。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setInitialLocation(
    '${AppRoutes.home}?tab=${MainTabConfig.bookstoreIndex}'
    '&bookstoreTopTab=ranking',
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
  runApp(const BookstorePreviewApp());
}

class BookstorePreviewApp extends StatelessWidget {
  const BookstorePreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlayStyle,
      child: MaterialApp.router(
        title: '书城推荐页预览',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
