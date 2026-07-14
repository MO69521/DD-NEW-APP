import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
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

  /// 选中态金色渐变遮罩（标题 / 价格）。
  Widget _goldMask(Widget child) {
    if (!selected) return child;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppMembershipColors.planSelectedGoldStart,
          AppMembershipColors.planSelectedGoldEnd,
        ],
      ).createShader(bounds),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 选中态文字先绘制为不透明白，再由 [_goldMask] 以金色渐变替换。
    const titleColor = AppColors.textOnDark;
    const priceColor = AppColors.textOnDark;

    final borderWidth = selected
        ? AppSizes.membershipPlanSelectedBorderWidth
        : AppSizes.membershipPlanUnselectedBorderWidth;
    final borderColor = selected
        ? AppMembershipColors.planSelectedBorder
        : AppMembershipColors.planUnselectedBorder;

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.lg,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _goldMask(
                              AppText(
                                plan.title,
                                style: AppTextStyles.membershipPlanTitle
                                    .copyWith(color: titleColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _goldMask(
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
                child: selected
                    ? const CustomPaint(
                        painter: _GradientBorderPainter(
                          radius: AppRadius.membershipPlanCard,
                          width: AppSizes.membershipPlanSelectedBorderWidth,
                          colors: [
                            AppMembershipColors.planSelectedGoldStart,
                            AppMembershipColors.planSelectedGoldEnd,
                          ],
                        ),
                      )
                    : DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppRadius.membershipPlanCard,
                          ),
                          border: Border.all(
                            color: borderColor,
                            width: borderWidth,
                          ),
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
        color: selected ? null : AppColors.surfaceCard,
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppMembershipColors.planSelectedGoldStart,
                  AppMembershipColors.planSelectedGoldEnd,
                ],
              )
            : null,
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

/// 选中卡金色渐变描边（左 → 右，与标题 / 价格 / 底栏同金）。
class _GradientBorderPainter extends CustomPainter {
  const _GradientBorderPainter({
    required this.radius,
    required this.width,
    required this.colors,
  });

  final double radius;
  final double width;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = width / 2;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(inset),
      Radius.circular(radius - inset),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.radius != radius ||
      oldDelegate.width != width ||
      oldDelegate.colors != colors;
}
