import 'package:flutter/material.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../core/theme/app_colors.dart';

/// L3 组件 — 福利页吸顶标题栏（Figma 294:5201）。
///
/// 左侧「福利中心」18px 标题，右侧充值说明 icon。
/// Phase 3：`onRechargeInfoTap` 跳转充值说明页。
class WelfarePageHeader extends StatelessWidget {
  const WelfarePageHeader({super.key, this.onRechargeInfoTap});

  /// 点击右上角 icon 的回调（当前未接入）
  final VoidCallback? onRechargeInfoTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.welfareHeaderHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            AppText(
              '福利中心',
              style: AppTextStyles.sectionTitleDark.copyWith(
                color: AppColors.textOnDark,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onRechargeInfoTap,
              behavior: HitTestBehavior.opaque,
              child: AppAssetImage(
                assetPath: 'assets/icons/welfare/recharge_info.svg',
                width: AppSizes.welfareRechargeInfoIconSize,
                height: AppSizes.welfareRechargeInfoIconSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
