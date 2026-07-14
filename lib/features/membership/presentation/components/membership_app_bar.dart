import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 会员页顶栏：返回圆钮 + 标题 + 右侧「充值记录」文字入口。
class MembershipAppBar extends StatelessWidget {
  const MembershipAppBar({
    super.key,
    required this.statusBarHeight,
    this.onBack,
    this.onRecordsTap,
  });

  final double statusBarHeight;
  final VoidCallback? onBack;
  final VoidCallback? onRecordsTap;

  static const String _backIconAsset = 'assets/icons/ranking/back.svg';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: SizedBox(
        height: AppSizes.topBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              AppPressable(
                onTap: onBack,
                child: Container(
                  width: AppSizes.topBarCircleSize,
                  height: AppSizes.topBarCircleSize,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceCard,
                    shape: BoxShape.circle,
                  ),
                  child: const AppIcon(
                    assetPath: _backIconAsset,
                    width: AppSizes.membershipBackIconWidth,
                    height: AppSizes.membershipBackIconHeight,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: AppText(
                    'VIP会员',
                    style: AppTextStyles.membershipSectionTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AppPressable(
                onTap: onRecordsTap,
                child: const AppText(
                  '充值记录',
                  style: AppTextStyles.membershipAppBarAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
