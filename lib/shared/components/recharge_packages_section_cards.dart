part of 'recharge_packages_section.dart';

class _RechargeSectionHeader extends StatelessWidget {
  const _RechargeSectionHeader({
    this.onMoreTap,
    this.collapsible = false,
    this.expanded = true,
  });

  final VoidCallback? onMoreTap;
  final bool collapsible;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '能量充值',
          style: AppTextStyles.welfareSectionTitle.copyWith(
            color: AppColors.textOnDark,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        const Spacer(),
        if (onMoreTap != null)
          AppPressable(
            onTap: onMoreTap,
            child: Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.xs,
                top: AppSpacing.xs,
                bottom: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(
                  AppRadius.welfareRechargeMoreAction,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '更多福利',
                    style: AppTextStyles.welfareRechargeMoreAction.copyWith(
                      color: AppColors.textOnDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  const AppIcon(
                    assetPath: 'assets/icons/arrow_right.svg',
                    width: AppSizes.welfareCurrencyArrowSize,
                    height: AppSizes.welfareCurrencyArrowSize,
                    color: AppColors.textOnDark,
                  ),
                ],
              ),
            ),
          ),
        if (collapsible) ...[
          if (onMoreTap != null) const SizedBox(width: AppSpacing.sm),
          AnimatedRotation(
            turns: expanded ? 0 : 0.5,
            duration: AppDurations.normal,
            child: const AppIcon(
              assetPath: 'assets/icons/chevron_down.svg',
              width: AppSizes.welfareCheckInChevronSize,
              height: AppSizes.welfareCheckInChevronSize,
              color: AppColors.white60,
            ),
          ),
        ],
      ],
    );
  }
}

class _RechargePackageCard extends StatelessWidget {
  const _RechargePackageCard({
    required this.package,
    this.isSelected = false,
    this.reserveSelectionBorder = false,
    this.onPriceTap,
  });

  final RechargePackage package;
  final bool isSelected;
  final bool reserveSelectionBorder;
  final VoidCallback? onPriceTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onPriceTap,
      child: Container(
        height: AppSizes.welfareRechargeCardHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.accentYellow : AppColors.borderGlass,
            width: reserveSelectionBorder
                ? AppSizes.borderWidthEmphasis
                : AppSizes.hairline,
          ),
        ),
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: AppSizes.welfareRechargeIllustrationHeight,
                    width: AppSizes.welfareRechargeIllustrationWidth,
                    child: Center(
                      child: AppAssetImage(
                        assetPath: package.illustrationAsset,
                        height: AppSizes.welfareRechargeIllustrationHeight,
                        width: AppSizes.welfareRechargeIllustrationWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        '${package.energyAmount}',
                        style: AppTextStyles.welfareRechargeEnergyAmount,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        '${package.originalAmount}',
                        style: AppTextStyles.welfareRechargeOriginalAmount,
                      ),
                    ],
                  ),
                  _RechargePriceButton(
                    priceYuan: package.priceYuan,
                    onTap: onPriceTap,
                  ),
                ],
              ),
            ),
            if (package.badgeLabel != null && package.badgeLabel!.isNotEmpty)
              AppCornerBadge(
                label: package.badgeLabel!,
                color: AppWelfareColors.accentOrange,
                horizontalPadding: AppSpacing.xxs,
              ),
          ],
        ),
      ),
    );
  }
}

/// 充值区统一胶囊按钮：暗色 `surfaceCard` 底 + 固定高度/圆角，居中承载内容。
/// 价格按钮与免费领取 CTA 共用，保持样式一致。
class _RechargePillButton extends StatelessWidget {
  const _RechargePillButton({required this.child, this.onTap, this.gradient});

  final Widget child;
  final VoidCallback? onTap;

  /// 可选渐变填充；提供后覆盖默认暗色底（VIP 领取按钮用 VIP 粉紫渐变）。
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: AppSizes.welfareRechargePriceButtonHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: gradient == null ? AppColors.surfaceCard : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.welfareRechargePrice),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: child,
      ),
    );
  }
}

class _RechargePriceButton extends StatelessWidget {
  const _RechargePriceButton({required this.priceYuan, this.onTap});

  final int priceYuan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 单段落 rich text：¥ 与数字共用同一基线，视觉底对齐（无降部字符）。
    return _RechargePillButton(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '¥',
              style: AppTextStyles.welfareRechargePriceSymbol,
            ),
            const WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: SizedBox(width: AppSpacing.xxsHalf),
            ),
            TextSpan(
              text: '$priceYuan',
              style: AppTextStyles.welfareRechargePriceAmount,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
