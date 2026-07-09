import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_benefit.dart';

/// L3 — 单个会员权益项：圆形图标底 + 文案。
class MembershipBenefitItem extends StatelessWidget {
  const MembershipBenefitItem({
    super.key,
    required this.benefit,
    this.centered = false,
    this.selected = false,
    this.showLabel = true,
    this.onTap,
  });

  static const double selectedScale = 1.5;

  final MembershipBenefit benefit;
  final bool centered;
  final bool showLabel;

  /// 选中态：整项放大（用于会员特权详情页顶部导航）。
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: centered ? double.infinity : null,
        child: AnimatedScale(
          scale: selected ? selectedScale : 1,
          duration: AppDurations.containerTransform,
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.membershipBenefitIconCircle,
                height: AppSizes.membershipBenefitIconCircle,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppMembershipColors.benefitIconBg,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: AppAssetImage(
                  assetPath: benefit.iconAsset,
                  width: AppSizes.membershipBenefitIcon,
                  height: AppSizes.membershipBenefitIcon,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(height: AppSizes.membershipBenefitIconLabelGap),
                if (centered)
                  SizedBox(
                    width: double.infinity,
                    child: AppText(
                      benefit.label,
                      style: AppTextStyles.membershipBenefitLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  AppText(
                    benefit.label,
                    style: AppTextStyles.membershipBenefitLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
