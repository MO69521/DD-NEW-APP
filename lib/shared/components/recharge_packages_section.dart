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
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import 'app_corner_badge.dart';

part 'recharge_packages_section_cards.dart';
part 'recharge_packages_section_free_claim.dart';

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
              ? AppPressable(
                  onTap: _toggle,
                  pressScale: AppSizes.tapPressScaleSubtle,
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
