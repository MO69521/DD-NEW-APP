import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/main_tab_config.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'routes/app_routes.dart';

/// 伙伴页（探索）预览入口：默认打开伙伴 Tab。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setInitialLocation(
    '${AppRoutes.home}?tab=${MainTabConfig.partnerIndex}',
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PartnerPreviewApp());
}

class PartnerPreviewApp extends StatelessWidget {
  const PartnerPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '伙伴页预览',
      theme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
