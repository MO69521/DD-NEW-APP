import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_switch.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/personalized_ads_cubit.dart';

class PersonalizedAdsPage extends StatelessWidget {
  const PersonalizedAdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '个性化广告',
          onBack: AppRouter.pop,
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.insetMd,
            AppLayout.chromeTopHeight(context) + AppSpacing.md,
            AppSpacing.insetMd,
            AppSpacing.xl,
          ),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: AppSizes.settingsNotificationRowMinHeight,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          '个性化广告',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                      ),
                      BlocBuilder<PersonalizedAdsCubit, bool>(
                        builder: (context, enabled) {
                          return AppSwitch(
                            value: enabled,
                            onChanged: context
                                .read<PersonalizedAdsCubit>()
                                .setEnabled,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppText(
              '关闭后，你仍会看到广告，但广告内容与你的兴趣偏好相关性会降低。',
              style: AppTextStyles.captionMdDarkMuted,
            ),
          ],
        ),
      ),
    );
  }
}
