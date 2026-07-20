import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/main_tab_config.dart';
import '../core/theme/app_theme.dart';
import '../routes/app_router.dart';
import '../routes/app_routes.dart';

/// 伙伴页预览入口。
///
/// 「伙伴」一级 Tab 暂时下线，入口先落到书城；恢复伙伴 Tab 后改回
/// `?tab=${MainTabConfig.partnerIndex}`。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setInitialLocation(
    // '${AppRoutes.home}?tab=${MainTabConfig.partnerIndex}',
    '${AppRoutes.home}?tab=${MainTabConfig.bookstoreIndex}',
  );
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
  runApp(const PartnerPreviewApp());
}

class PartnerPreviewApp extends StatelessWidget {
  const PartnerPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlayStyle,
      child: MaterialApp.router(
        title: '伙伴页预览',
        theme: AppTheme.current,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
