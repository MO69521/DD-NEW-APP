import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shared_assets.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 我的消息空态：插画 + 引导文案。
class MyMessagesEmptyView extends StatelessWidget {
  const MyMessagesEmptyView({super.key});

  static const String _illustration = AppSharedAssets.emptyMessages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: AppSizes.myMessagesEmptyTopFlex),
        Image.asset(
          _illustration,
          width: AppSizes.myMessagesEmptyIllustrationSize,
          height: AppSizes.myMessagesEmptyIllustrationSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: AppSpacing.md),
        AppText(
          '暂时还没有互动消息呢～',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textOnDarkMuted,
          ),
        ),
        const Spacer(flex: AppSizes.myMessagesEmptyBottomFlex),
      ],
    );
  }
}
