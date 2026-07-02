import 'package:flutter/material.dart';

import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_text.dart';
import 'currency_wallet_section_card.dart';

class CurrencyPaymentSection extends StatelessWidget {
  const CurrencyPaymentSection({
    super.key,
    required this.selectedMethod,
    required this.onMethodTap,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodTap;

  @override
  Widget build(BuildContext context) {
    return CurrencyWalletSectionCard(
      title: '支付方式',
      child: Column(
        children: [
          _PaymentMethodRow(
            method: PaymentMethod.wechat,
            selectedMethod: selectedMethod,
            onTap: onMethodTap,
          ),
          const Divider(height: AppSpacing.md, color: AppColors.borderGlass),
          _PaymentMethodRow(
            method: PaymentMethod.alipay,
            selectedMethod: selectedMethod,
            onTap: onMethodTap,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodRow extends StatelessWidget {
  const _PaymentMethodRow({
    required this.method,
    required this.selectedMethod,
    required this.onTap,
  });

  final PaymentMethod method;
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = method == selectedMethod;

    return GestureDetector(
      onTap: () => onTap(method),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            _PaymentLogo(method: method),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppText(method.label, style: AppTextStyles.bodyMediumDark),
            ),
            AppSelectionMark(
              isSelected: isSelected,
              unselectedBorderColor: AppColors.borderGlass,
              unselectedBorderWidth: AppSizes.hairline,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  const _PaymentLogo({required this.method});

  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.welfareRechargeInfoIconSize,
      height: AppSizes.welfareRechargeInfoIconSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: method == PaymentMethod.wechat
            ? AppColors.success
            : AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: AppText(
        method == PaymentMethod.wechat ? '微' : '支',
        style: AppTextStyles.captionMd.copyWith(color: AppColors.textOnDark),
      ),
    );
  }
}
