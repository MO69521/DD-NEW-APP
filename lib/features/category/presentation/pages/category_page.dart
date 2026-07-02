import 'package:flutter/material.dart';

import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../components/category_tab_body.dart';

/// 分类页（深色态）：仅渲染 state、触发 action。
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  static const String _title = '分类';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: _title,
          onBack: AppRouter.pop,
        ),
        body: CategoryTabBody(
          topScrollPadding: AppLayout.chromeTopHeight(context),
        ),
      ),
    );
  }
}
