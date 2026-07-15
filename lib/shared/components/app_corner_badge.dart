import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/app_text.dart';

/// L2 — 卡片右上角标：贴卡片右上角，`topRight` + `bottomLeft` 斜切圆角的彩色胶囊。
/// 充值 / 兑换档位「热」「新手福利」「会员免费领」等共用。
///
/// 必须作为 [Stack] 的直接子节点使用（内部返回 [Positioned]，贴合卡片右上角）。
/// 仅底色 / 水平内边距 / 字色按调用方语义传入；饱和色底（橙/红）默认
/// [AppColors.cornerBadgeText]（恒白），浅粉 VIP 角标传 [AppWelfareColors.vipFreeClaimBadgeText]。
class AppCornerBadge extends StatelessWidget {
  const AppCornerBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor = AppColors.cornerBadgeText,
    this.horizontalPadding = AppSpacing.xs,
  });

  final String label;
  final Color color;
  final Color textColor;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: AppSpacing.xxs,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppRadius.md),
            bottomLeft: Radius.circular(AppRadius.md),
          ),
        ),
        child: AppText(
          label,
          style: AppTextStyles.welfareHotSaleBadge.copyWith(color: textColor),
        ),
      ),
    );
  }
}
