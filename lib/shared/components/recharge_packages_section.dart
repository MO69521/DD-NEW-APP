import 'package:flutter/material.dart';

import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_durations.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_welfare_colors.dart';
import '../widgets/advanced_transition_wrapper.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_text.dart';
import '../../core/theme/app_colors.dart';

/// L2 组件 — 能量充值套餐区块（Figma 697:12514）。
class RechargePackagesSection extends StatefulWidget {
  const RechargePackagesSection({
    super.key,
    required this.packages,
    this.selectedPackageId,
    this.onPackageTap,
    this.onMoreTap,
    this.detailPageBuilder,
    this.freeClaimOptions = const [],
    this.onFreeClaimTap,
    this.collapsible = false,
    this.initiallyExpanded = true,
  });

  final List<RechargePackage> packages;
  final String? selectedPackageId;
  final ValueChanged<RechargePackage>? onPackageTap;
  final VoidCallback? onMoreTap;

  /// 充值区第三行「免费领取」卡片；为空时不渲染该行。
  final List<EnergyFreeClaimOption> freeClaimOptions;
  final ValueChanged<EnergyFreeClaimOption>? onFreeClaimTap;

  /// 是否支持折叠（标题右侧显示箭头，点击标题栏收起 / 展开）。
  final bool collapsible;

  /// 折叠可用时的初始展开状态（默认展开）。
  final bool initiallyExpanded;

  /// 套餐详情页构造器；提供后点击卡片以「容器转换」动效放大为该页。
  /// 回调参数 `closeContainer` 用于在详情页内触发缩回。
  final Widget Function(
    BuildContext context,
    RechargePackage package,
    VoidCallback closeContainer,
  )?
  detailPageBuilder;

  @override
  State<RechargePackagesSection> createState() =>
      _RechargePackagesSectionState();
}

class _RechargePackagesSectionState extends State<RechargePackagesSection> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    final header = _RechargeSectionHeader(
      onMoreTap: widget.onMoreTap,
      collapsible: widget.collapsible,
      expanded: _expanded,
    );

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
          widget.collapsible
              ? GestureDetector(
                  onTap: _toggle,
                  behavior: HitTestBehavior.opaque,
                  child: header,
                )
              : header,
          AnimatedSize(
            duration: AppDurations.normal,
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: widget.collapsible && !_expanded
                ? const SizedBox(width: double.infinity)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      _buildGrid(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisCount = 3;
        const spacing = AppSpacing.xs;
        final reserveSelectionBorder = widget.selectedPackageId != null;
        final itemWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final package in widget.packages)
              SizedBox(
                width: itemWidth,
                child: widget.detailPageBuilder != null
                    ? AdvancedTransitionWrapper(
                        borderRadius: AppRadius.md,
                        closedChild: _RechargePackageCard(package: package),
                        openBuilder: (context, closeContainer) =>
                            widget.detailPageBuilder!(
                              context,
                              package,
                              closeContainer,
                            ),
                      )
                    : _RechargePackageCard(
                        package: package,
                        isSelected: package.id == widget.selectedPackageId,
                        reserveSelectionBorder: reserveSelectionBorder,
                        onPriceTap: widget.onPackageTap == null
                            ? null
                            : () => widget.onPackageTap!(package),
                      ),
              ),
            for (final option in widget.freeClaimOptions)
              SizedBox(
                width: itemWidth,
                child: _FreeClaimCard(
                  option: option,
                  onTap: widget.onFreeClaimTap == null
                      ? null
                      : () => widget.onFreeClaimTap!(option),
                ),
              ),
          ],
        );
      },
    );
  }
}

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
          GestureDetector(
            onTap: onMoreTap,
            behavior: HitTestBehavior.opaque,
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
    return GestureDetector(
      onTap: onPriceTap,
      behavior: HitTestBehavior.opaque,
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

/// 充值区「免费领取」卡片：徽标 + 占位插画 + 可获得能量 + 领取按钮。
class _FreeClaimCard extends StatelessWidget {
  const _FreeClaimCard({required this.option, this.onTap});

  final EnergyFreeClaimOption option;
  final VoidCallback? onTap;

  bool get _isVip => option.kind == EnergyFreeClaimKind.vip;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSizes.welfareRechargeCardHeight,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: AppColors.borderGlass,
            width: AppSizes.hairline,
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
                        assetPath: option.illustrationAsset,
                        height: AppSizes.welfareRechargeIllustrationHeight,
                        width: AppSizes.welfareRechargeIllustrationWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText('可获得', style: AppTextStyles.captionSm),
                      const SizedBox(height: AppSpacing.xxs),
                      AppText(
                        '${option.energyAmount}',
                        style: AppTextStyles.welfareRechargeEnergyAmount,
                      ),
                    ],
                  ),
                  _FreeClaimCtaButton(label: option.ctaLabel, isVip: _isVip),
                ],
              ),
            ),
            Positioned(
              top: -AppSpacing.xxs,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: _isVip
                      ? AppWelfareColors.vipCtaGradientEnd
                      : AppWelfareColors.accentOrange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.md),
                    bottomRight: Radius.circular(AppRadius.md),
                  ),
                ),
                child: AppText(
                  option.badgeLabel,
                  style: AppTextStyles.welfareHotSaleBadge.copyWith(
                    color: _isVip
                        ? AppWelfareColors.vipCtaText
                        : AppColors.textOnDark,
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

class _FreeClaimCtaButton extends StatelessWidget {
  const _FreeClaimCtaButton({required this.label, required this.isVip});

  final String label;
  final bool isVip;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.welfareRechargePriceButtonHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isVip ? null : AppWelfareColors.checkInCtaSolid,
        gradient: isVip
            ? const LinearGradient(
                colors: [
                  AppWelfareColors.vipCtaGradientStart,
                  AppWelfareColors.vipCtaGradientEnd,
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(AppRadius.welfareRechargePrice),
      ),
      child: AppText(
        label,
        style: AppTextStyles.welfareCtaText.copyWith(
          color: isVip
              ? AppWelfareColors.vipCtaText
              : AppWelfareColors.checkInCtaTextDark,
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
