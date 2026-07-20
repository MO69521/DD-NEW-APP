import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/currency_config.dart';
import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_brand_colors.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_welfare_colors.dart';
import '../../core/theme/app_icon_assets.dart';
import '../widgets/animated_count_text.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_icon.dart';
import '../widgets/app_pressable.dart';
import '../widgets/app_text.dart';

/// L2 组件 — 虚拟货币余额条（福利页 / 我的页复用）。
///
/// 列数由 [balances] 长度决定：福利页 / 我的页均传 4 项。
/// 间距对齐 Figma 454:12110：四边 padding 12、列内 gap 12、icon-label gap 4、分隔线高 15。
class CurrencyBalanceBar extends StatelessWidget {
  const CurrencyBalanceBar({
    super.key,
    required this.balances,
    this.onCurrencyTap,
  });

  final List<CurrencyBalance> balances;
  final ValueChanged<CurrencyType>? onCurrencyTap;

  @override
  Widget build(BuildContext context) {
    const isYellowLight = AppBrandColors.isYellowLight;
    final borderRadius = BorderRadius.circular(AppRadius.lg);

    Widget bar = Container(
      padding: isYellowLight
          ? EdgeInsets.zero
          : const EdgeInsets.all(AppSpacing.sm),
      decoration: isYellowLight
          ? null
          : BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: borderRadius,
              border: Border.all(
                color: AppColors.borderGlass,
                width: AppSizes.hairline,
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var i = 0; i < balances.length; i++) ...[
            if (i > 0)
              Container(
                width: AppSizes.hairline,
                height: AppSizes.welfareCurrencyDividerHeight,
                color: AppColors.borderGlass,
              ),
            Expanded(
              child: Align(
                alignment: isYellowLight
                    ? _yellowLightAlignment(i, balances.length)
                    : Alignment.center,
                child: _CurrencyColumn(
                  balance: balances[i],
                  onTap: onCurrencyTap == null
                      ? null
                      : () => onCurrencyTap!(balances[i].type),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (!isYellowLight) {
      bar = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSizes.welfareCurrencyBlurSigma,
            sigmaY: AppSizes.welfareCurrencyBlurSigma,
          ),
          child: bar,
        ),
      );
    }

    return bar;
  }

  Alignment _yellowLightAlignment(int index, int itemCount) {
    if (index == 0) return Alignment.centerLeft;
    if (index == itemCount - 1) return Alignment.centerRight;
    return Alignment.center;
  }
}

class _CurrencyColumn extends StatelessWidget {
  const _CurrencyColumn({required this.balance, this.onTap});

  final CurrencyBalance balance;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: AppSizes.welfareCurrencyAmountFontSize,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedCountText(
                      value: balance.amount,
                      style: AppTextStyles.welfareCurrencyAmount.copyWith(
                        color: AppColors.textOnDark,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              if (AppBrandColors.isYellowLight &&
                  balance.type == CurrencyType.stardust)
                const Positioned(
                  bottom:
                      AppSizes.welfareCurrencyAmountFontSize + AppSpacing.xxs,
                  child: _StardustExchangeBadge(),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: AppSizes.welfareCurrencyIconSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAssetImage(
                  assetPath: CurrencyConfig.iconAsset(balance.type),
                  width: AppSizes.welfareCurrencyIconSize,
                  height: AppSizes.welfareCurrencyIconSize,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText(
                      CurrencyConfig.label(balance.type),
                      style: AppTextStyles.bookTagDark.copyWith(
                        color: AppColors.textOnDarkMuted,
                      ),
                      maxLines: 1,
                    ),
                    const AppIcon(
                      assetPath: AppIconAssets.arrowRight,
                      width: AppSizes.welfareCurrencyArrowSize,
                      height: AppSizes.welfareCurrencyArrowSize,
                      color: AppColors.sectionActionIcon,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StardustExchangeBadge extends StatelessWidget {
  const _StardustExchangeBadge();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: AppSpacing.xxsHalf,
          ),
          decoration: BoxDecoration(
            color: AppWelfareColors.hotSaleBadge,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: AppText('可兑换能量', style: AppTextStyles.welfareHotSaleBadge),
        ),
        Transform.translate(
          offset: const Offset(0, -AppSpacing.xxsHalf),
          child: const ClipPath(
            clipper: _DownTriangleClipper(),
            child: SizedBox(
              width: AppSpacing.sm,
              height: AppSpacing.xxs,
              child: ColoredBox(color: AppWelfareColors.hotSaleBadge),
            ),
          ),
        ),
      ],
    );
  }
}

class _DownTriangleClipper extends CustomClipper<Path> {
  const _DownTriangleClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _DownTriangleClipper oldClipper) => false;
}
