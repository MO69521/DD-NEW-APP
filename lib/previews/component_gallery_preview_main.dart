import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_theme.dart';
import '../features/dev_tools/presentation/component_gallery_page.dart';

/// 组件总览独立预览入口。
///
/// 启动示例：
/// `flutter run -t lib/previews/component_gallery_preview_main.dart`
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(AppTheme.systemUiOverlayStyle);
  runApp(const ComponentGalleryPreviewApp());
}

class ComponentGalleryPreviewApp extends StatelessWidget {
  const ComponentGalleryPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlayStyle,
      child: MaterialApp(
        title: '点点穿书 · 组件总览',
        theme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
        home: const ComponentGalleryPage(),
      ),
    );
  }
}
