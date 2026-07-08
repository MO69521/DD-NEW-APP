import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 页面 — 常见问题详情（深色主题）。
class HelpFeedbackFaqDetailPage extends StatelessWidget {
  const HelpFeedbackFaqDetailPage({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '问题详情',
          onBack: AppRouter.pop,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppLayout.chromeTopHeight(context) + AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderGlass),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(question, style: AppTextStyles.titleMediumDark),
                  const SizedBox(height: AppSpacing.md),
                  AppText(
                    '该问题的详细说明正在整理中。你可以先返回帮助与反馈页提交问题描述，我们会根据你的反馈继续完善帮助内容。',
                    style: AppTextStyles.bodyMediumDarkMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
