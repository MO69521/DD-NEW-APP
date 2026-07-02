import 'package:flutter/material.dart';

import '../../../../core/constants/currency_config.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/currency_wallet_page_content.dart';
import 'currency_wallet_section_card.dart';

class StardustExchangeSection extends StatelessWidget {
  const StardustExchangeSection({
    super.key,
    required this.options,
    required this.selectedOptionId,
    required this.onOptionTap,
  });

  final List<StardustExchangeOption> options;
  final String selectedOptionId;
  final ValueChanged<String> onOptionTap;

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) return const SizedBox.shrink();

    return CurrencyWalletSectionCard(
      title: '兑换能量',
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _StardustOptionCard(
                option: options[i],
                isSelected: options[i].id == selectedOptionId,
                onTap: () => onOptionTap(options[i].id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StardustOptionCard extends StatelessWidget {
  const _StardustOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final StardustExchangeOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentYellow
                    : AppColors.borderGlass,
                width: isSelected
                    ? AppSizes.borderWidthEmphasis
                    : AppSizes.hairline,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                AppAssetImage(
                  assetPath: CurrencyConfig.iconAsset(CurrencyType.energy),
                  width: AppSizes.welfareRechargeIllustrationHeight,
                  height: AppSizes.welfareRechargeIllustrationHeight,
                ),
                const SizedBox(height: AppSpacing.xs),
                AppText('可获得', style: AppTextStyles.captionMdDarkMuted),
                const SizedBox(height: AppSpacing.xxs),
                AppText(
                  '${option.energyAmount}',
                  style: AppTextStyles.titleMediumDark,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.insetXs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppAssetImage(
                        assetPath: CurrencyConfig.iconAsset(
                          CurrencyType.stardust,
                        ),
                        width: AppSizes.welfareCurrencyIconSize,
                        height: AppSizes.welfareCurrencyIconSize,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      AppText(
                        '${option.stardustCost}',
                        style: AppTextStyles.buttonLabel14.copyWith(
                          color: AppColors.rankingSegmentedSelectedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (option.badgeLabel != null)
            Positioned(
              top: -AppSpacing.xxsHalf,
              right: -AppSpacing.xxs,
              child: _StardustOptionBadge(label: option.badgeLabel!),
            ),
        ],
      ),
    );
  }
}

class _StardustOptionBadge extends StatelessWidget {
  const _StardustOptionBadge({required this.label});

  static const String _assetPath =
      'assets/images/welfare/stardust_exchange_badge.png';

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.stardustExchangeBadgeWidth,
      height: AppSizes.welfareRechargeHotBadgeHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const AppAssetImage(assetPath: _assetPath, fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AppText(
                  label,
                  style: AppTextStyles.welfareHotSaleBadge,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
