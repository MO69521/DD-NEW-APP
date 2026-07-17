import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

class TeenModePage extends StatelessWidget {
  const TeenModePage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '青少年模式未开启',
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
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TeenModeParagraph(
                      index: '1.',
                      text: '亲爱的用户，如果你开启青少年模式，需先设置独立密码，若忘记密码，可以通过申诉重置密码。',
                    ),
                    SizedBox(height: AppSpacing.md),
                    _TeenModeParagraph(
                      index: '2.',
                      text: '开启青少年模式后，将自动开启时间锁，单日使用时长超过设定时间，需输入密码才能继续使用。',
                    ),
                    SizedBox(height: AppSpacing.md),
                    _TeenModeParagraph(
                      index: '3.',
                      text: '青少年模式是点点穿书为促进青少年健康成长做出的尝试，我们会持续优化适合青少年的内容和场景。',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: '开启青少年模式',
              variant: AppButtonVariant.accent,
              isExpanded: true,
              onPressed: () =>
                  AppRouter.pushNamed(AppRoutes.teenModePasswordName),
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              '《儿童/青少年使用须知》',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TeenModeParagraph extends StatelessWidget {
  const _TeenModeParagraph({required this.index, required this.text});

  final String index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          index,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textOnDark),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: AppText(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
        ),
      ],
    );
  }
}
