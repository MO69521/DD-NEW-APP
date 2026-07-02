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

class CurrencyBalanceSummaryCard extends StatelessWidget {
  const CurrencyBalanceSummaryCard({
    super.key,
    required this.type,
    required this.balance,
  });

  final CurrencyType type;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderGlass),
      ),
      child: Row(
        children: [
          AppText(
            '我的${CurrencyConfig.label(type)}',
            style: AppTextStyles.titleMediumDark,
          ),
          const Spacer(),
          AppText(
            '$balance',
            style: AppTextStyles.displaySm.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          AppAssetImage(
            assetPath: CurrencyConfig.iconAsset(type),
            width: AppSizes.welfareCurrencyIconSize,
            height: AppSizes.welfareCurrencyIconSize,
          ),
        ],
      ),
    );
  }
}
