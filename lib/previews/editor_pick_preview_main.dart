import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../routes/app_router.dart';
import '../routes/app_routes.dart';

/// 编辑推荐详情页独立预览入口。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRouter.setInitialLocation(AppRoutes.editorPick);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
  runApp(const EditorPickPreviewApp());
}

class EditorPickPreviewApp extends StatelessWidget {
  const EditorPickPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlayStyle,
      child: MaterialApp.router(
        title: '编辑推荐详情页预览',
        theme: AppTheme.current,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
