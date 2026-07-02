import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_plan.dart';

/// L3 — 单个会员套餐卡，支持选中（金色高亮）/ 未选中（玻璃）两态。
class MembershipPlanCard extends StatelessWidget {
  const MembershipPlanCard({
    super.key,
    required this.plan,
    required this.selected,
    this.onTap,
  });

  final MembershipPlan plan;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = selected
        ? AppMembershipColors.planSelectedTitle
        : AppColors.textOnDark;
    final priceColor = selected
        ? AppMembershipColors.planSelectedPrice
        : AppColors.textOnDark;

    final borderWidth = selected
        ? AppSizes.membershipPlanSelectedBorderWidth
        : AppSizes.membershipPlanUnselectedBorderWidth;
    final borderColor = selected
        ? AppMembershipColors.planSelectedBorder
        : AppMembershipColors.planUnselectedBorder;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: AppSizes.membershipPlanCardWidth,
        height: AppSizes.membershipPlanCardHeight,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.membershipPlanCard),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected
                      ? AppMembershipColors.planSelectedBg
                      : AppMembershipColors.planUnselectedBg,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              plan.title,
                              style: AppTextStyles.membershipPlanTitle.copyWith(
                                color: titleColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.xxsHalf,
                                  ),
                                  child: AppText(
                                    '¥',
                                    style: AppTextStyles
                                        .membershipPlanCurrencySymbol
                                        .copyWith(color: priceColor),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xxsHalf),
                                Flexible(
                                  child: AppText(
                                    plan.priceText,
                                    style: AppTextStyles.membershipPlanPrice
                                        .copyWith(color: priceColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppText(
                              plan.secondaryText,
                              style: AppTextStyles.membershipPlanOriginalPrice
                                  .copyWith(
                                    color: selected
                                        ? AppMembershipColors
                                              .planSelectedSecondary
                                        : AppMembershipColors.planOriginalPrice,
                                    decorationColor: selected
                                        ? AppMembershipColors
                                              .planSelectedSecondary
                                        : AppMembershipColors.planOriginalPrice,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _FooterBar(plan: plan, selected: selected),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      AppRadius.membershipPlanCard,
                    ),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar({required this.plan, required this.selected});

  final MembershipPlan plan;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.membershipPlanFooterHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? AppMembershipColors.planSelectedFooterBg
            : AppColors.surfaceCard,
      ),
      child: AppText(
        '累计${plan.cumulativeEnergy}能量',
        style: AppTextStyles.membershipPlanFooter.copyWith(
          color: selected
              ? AppMembershipColors.planSelectedFooterText
              : AppColors.textOnDark,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
