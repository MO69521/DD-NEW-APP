import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../components/ranking_tab_body.dart';

/// 多维度榜单详情页（Figma 220:8376）：仅渲染 state、触发 action。
class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RankingTabBody(),
    );
  }
}
