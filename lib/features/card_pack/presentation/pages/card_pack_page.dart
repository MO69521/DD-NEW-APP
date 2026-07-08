import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_layout.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/layouts/app_page_chrome.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 页面 — 我的卡包空数据页（深色主题）。
class CardPackPage extends StatelessWidget {
  const CardPackPage({super.key});

  static const String _emptyIllustration =
      'assets/images/profile/empty_card_pack.png';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = AppLayout.statusBarHeight(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: AppPageChrome(
        topBar: AppTopBar(
          statusBarHeight: statusBarHeight,
          title: '我的卡包',
          onBack: AppRouter.pop,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppLayout.chromeTopHeight(context),
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            children: [
              const Spacer(flex: AppSizes.cardPackEmptyTopFlex),
              const AppAssetImage(
                assetPath: _emptyIllustration,
                width: AppSizes.cardPackEmptyIllustrationSize,
                height: AppSizes.cardPackEmptyIllustrationSize,
              ),
              const SizedBox(height: AppSpacing.md),
              AppText('暂无内容', style: AppTextStyles.bodyMediumDarkMuted),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: '点击刷新',
                variant: AppButtonVariant.accent,
                size: AppButtonSize.compact,
                onPressed: () {},
              ),
              const Spacer(flex: AppSizes.cardPackEmptyBottomFlex),
            ],
          ),
        ),
      ),
    );
  }
}
