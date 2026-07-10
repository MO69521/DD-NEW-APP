import 'package:flutter/material.dart';

import '../../../../core/constants/currency_config.dart';
import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../shared/components/app_corner_badge.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/animated_count_text.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_pressable.dart';
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
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
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
                AnimatedCountText(
                  value: option.energyAmount,
                  style: AppTextStyles.titleMediumDark,
                ),
                const SizedBox(height: AppSpacing.xxs),
                AppButton(
                  label: '${option.stardustCost}',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.small,
                  isExpanded: true,
                  fitLabel: true,
                  leadingIcon: AppAssetImage(
                    assetPath: CurrencyConfig.iconAsset(
                      CurrencyType.stardust,
                    ),
                    width: AppSizes.welfareCurrencyIconSize,
                    height: AppSizes.welfareCurrencyIconSize,
                  ),
                  onPressed: onTap,
                ),
              ],
            ),
          ),
          if (option.badgeLabel != null)
            AppCornerBadge(
              label: option.badgeLabel!,
              color: AppWelfareColors.accentOrange,
            ),
        ],
      ),
    );
  }
}

