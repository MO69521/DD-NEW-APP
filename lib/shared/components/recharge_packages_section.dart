import 'package:flutter/material.dart';

import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../widgets/advanced_transition_wrapper.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_text.dart';
import '../../core/theme/app_colors.dart';

/// L2 组件 — 能量充值套餐区块（Figma 697:12514）。
class RechargePackagesSection extends StatelessWidget {
  const RechargePackagesSection({
    super.key,
    required this.packages,
    this.selectedPackageId,
    this.onPackageTap,
    this.onMoreTap,
    this.detailPageBuilder,
  });

  final List<RechargePackage> packages;
  final String? selectedPackageId;
  final ValueChanged<RechargePackage>? onPackageTap;
  final VoidCallback? onMoreTap;

  /// 套餐详情页构造器；提供后点击卡片以「容器转换」动效放大为该页。
  /// 回调参数 `closeContainer` 用于在详情页内触发缩回。
  final Widget Function(
    BuildContext context,
    RechargePackage package,
    VoidCallback closeContainer,
  )?
  detailPageBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RechargeSectionHeader(onMoreTap: onMoreTap),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (context, constraints) {
              const crossAxisCount = 3;
              const spacing = AppSpacing.xs;
              final reserveSelectionBorder = selectedPackageId != null;
              final itemWidth =
                  (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                  crossAxisCount;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: packages.map((package) {
                  return SizedBox(
                    width: itemWidth,
                    child: detailPageBuilder != null
                        ? AdvancedTransitionWrapper(
                            borderRadius: AppRadius.sm,
                            closedChild: _RechargePackageCard(package: package),
                            openBuilder: (context, closeContainer) =>
                                detailPageBuilder!(
                                  context,
                                  package,
                                  closeContainer,
                                ),
                          )
                        : _RechargePackageCard(
                            package: package,
                            isSelected: package.id == selectedPackageId,
                            reserveSelectionBorder: reserveSelectionBorder,
                            onPriceTap: onPackageTap == null
                                ? null
                                : () => onPackageTap!(package),
                          ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RechargeSectionHeader extends StatelessWidget {
  const _RechargeSectionHeader({this.onMoreTap});

  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '能量充值',
          style: AppTextStyles.welfareSectionTitle.copyWith(
            color: AppColors.textOnDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        if (onMoreTap != null)
          GestureDetector(
            onTap: onMoreTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                right: AppSpacing.xs,
                top: AppSpacing.insetXs,
                bottom: AppSpacing.insetXs,
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
                    style: AppTextStyles.welfareRechargeMoreAction,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  const AppAssetImage(
                    assetPath: 'assets/icons/welfare/more_benefits_arrow.png',
                    width: AppSizes.welfareCurrencyArrowSize,
                    height: AppSizes.welfareCurrencyArrowSize,
                  ),
                ],
              ),
            ),
          ),
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
    return GestureDetector(
      onTap: onPriceTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSizes.welfareRechargeCardHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.sm),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        '${package.energyAmount}',
                        style: AppTextStyles.welfareRechargeEnergyAmount,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
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
              const Positioned(
                top: -AppSpacing.xxsHalf,
                right: -AppSpacing.xxs,
                child: AppAssetImage(
                  assetPath: 'assets/images/welfare/recharge_hot_badge.png',
                  width: AppSizes.welfareRechargeHotBadgeWidth,
                  height: AppSizes.welfareRechargeHotBadgeHeight,
                ),
              ),
          ],
        ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.welfareRechargePrice),
        child: Ink(
          width: double.infinity,
          height: AppSizes.welfareRechargePriceButtonHeight,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.welfareRechargePrice),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.insetXs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxsHalf),
                child: AppText(
                  '¥',
                  style: AppTextStyles.welfareRechargePriceSymbol,
                ),
              ),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText(
                '$priceYuan',
                style: AppTextStyles.welfareRechargePriceAmount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
