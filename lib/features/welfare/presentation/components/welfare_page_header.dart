import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/app_top_bar.dart';
import '../../../../shared/components/app_top_bar_icon_button.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 组件 — 福利页吸顶标题栏（Figma 294:5201）。
///
/// [AppTopBar] 的「居中标题 + 右侧图标」变体；blur/statusBar 由页面外层负责。
/// Phase 3：`onRechargeInfoTap` 跳转充值说明页。
class WelfarePageHeader extends StatelessWidget {
  const WelfarePageHeader({super.key, this.onRechargeInfoTap});

  /// 点击右上角 icon 的回调（当前未接入）
  final VoidCallback? onRechargeInfoTap;

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      height: AppSizes.welfareHeaderHeight,
      horizontalPadding: AppSpacing.sm,
      chromeBlurEnabled: false,
      center: AppText(
        '福利中心',
        style: AppTextStyles.sectionTitleDark.copyWith(
          color: AppColors.textOnDark,
        ),
        maxLines: 1,
      ),
      trailing: AppTopBarIconButton(
        onTap: onRechargeInfoTap,
        iconAsset: 'assets/icons/welfare/recharge_info.svg',
        iconWidth: AppSizes.welfareRechargeInfoIconSize,
        iconHeight: AppSizes.welfareRechargeInfoIconSize,
        iconColor: AppColors.welfareHeaderInfoIcon,
      ),
    );
  }
}
