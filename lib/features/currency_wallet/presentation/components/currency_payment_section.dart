import 'package:flutter/material.dart';

import '../../../../core/domain/entities/commerce_entities.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_pressable.dart';
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

    return AppPressable(
      onTap: () => onTap(method),
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            _PaymentLogo(method: method),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppText(method.label, style: AppTextStyles.bodyMediumDark),
            ),
            AppSelectionMark(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _PaymentLogo extends StatelessWidget {
  const _PaymentLogo({required this.method});

  final PaymentMethod method;

  static const String _wechatAsset = 'assets/icons/payment/wechat.svg';
  static const String _alipayAsset = 'assets/icons/payment/alipay.svg';

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: method == PaymentMethod.wechat ? _wechatAsset : _alipayAsset,
      width: AppSizes.welfareRechargeInfoIconSize,
      height: AppSizes.welfareRechargeInfoIconSize,
    );
  }
}
