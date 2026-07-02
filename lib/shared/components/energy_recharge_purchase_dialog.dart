import 'package:flutter/material.dart';

import '../../core/constants/currency_config.dart';
import '../../core/domain/entities/commerce_entities.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../routes/app_router.dart';
import '../widgets/app_asset_image.dart';
import '../widgets/app_button.dart';
import '../widgets/app_selection_mark.dart';
import '../widgets/app_text.dart';
import 'app_blurred_dialog.dart';

/// L2 — 能量充值支付确认弹窗（深色 UI，个人主页 / 福利页共用）。
class EnergyRechargePurchaseDialog extends StatefulWidget {
  const EnergyRechargePurchaseDialog({
    super.key,
    required this.package,
    this.onConfirm,
    this.onAgreementTap,
  });

  final RechargePackage package;
  final void Function(PaymentMethod method, RechargePackage package)? onConfirm;
  final VoidCallback? onAgreementTap;

  static const String _agreementTitle = '点点穿书虚拟能量服务协议';

  static Future<void> show(
    BuildContext context, {
    required RechargePackage package,
    void Function(PaymentMethod method, RechargePackage package)? onConfirm,
    VoidCallback? onAgreementTap,
  }) {
    return showAppBlurredDialog<void>(
      context: context,
      builder: (dialogContext) => EnergyRechargePurchaseDialog(
        package: package,
        onConfirm: onConfirm,
        onAgreementTap: onAgreementTap,
      ),
    );
  }

  @override
  State<EnergyRechargePurchaseDialog> createState() =>
      _EnergyRechargePurchaseDialogState();
}

class _EnergyRechargePurchaseDialogState
    extends State<EnergyRechargePurchaseDialog> {
  PaymentMethod _selectedMethod = PaymentMethod.wechat;

  int get _bonusAmount =>
      widget.package.energyAmount - widget.package.originalAmount;

  void _handleClose() => AppRouter.pop();

  void _handleConfirm() {
    final onConfirm = widget.onConfirm;
    if (onConfirm != null) {
      onConfirm(_selectedMethod, widget.package);
      return;
    }

    final message =
        '${_selectedMethod.label} ¥${widget.package.priceYuan} 已模拟提交';
    AppRouter.pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.dialogBackground,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.borderGlass),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DialogHeader(
                    originalAmount: widget.package.originalAmount,
                    bonusAmount: _bonusAmount,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _DialogPrice(priceYuan: widget.package.priceYuan),
                  const SizedBox(height: AppSpacing.lg),
                  _PaymentMethodList(
                    selectedMethod: _selectedMethod,
                    onMethodTap: (method) =>
                        setState(() => _selectedMethod = method),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label:
                        '${_selectedMethod.label} ¥${widget.package.priceYuan}',
                    variant: AppButtonVariant.accent,
                    isExpanded: true,
                    onPressed: _handleConfirm,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _AgreementFooter(
                    agreementTitle:
                        EnergyRechargePurchaseDialog._agreementTitle,
                    onAgreementTap: widget.onAgreementTap,
                  ),
                ],
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: _DialogCloseButton(onTap: _handleClose),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.originalAmount,
    required this.bonusAmount,
  });

  final int originalAmount;
  final int bonusAmount;

  static final String _energyIconAsset = CurrencyConfig.iconAsset(
    CurrencyType.energy,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.xxs,
        children: [
          AppText(
            '购买$originalAmount',
            style: AppTextStyles.rechargePurchaseDialogTitle,
          ),
          AppAssetImage(
            assetPath: _energyIconAsset,
            width: AppSizes.rechargePurchaseDialogEnergyIconSize,
            height: AppSizes.rechargePurchaseDialogEnergyIconSize,
          ),
          AppText(
            '+ 赠送$bonusAmount',
            style: AppTextStyles.rechargePurchaseDialogTitle,
          ),
          AppAssetImage(
            assetPath: _energyIconAsset,
            width: AppSizes.rechargePurchaseDialogEnergyIconSize,
            height: AppSizes.rechargePurchaseDialogEnergyIconSize,
          ),
        ],
      ),
    );
  }
}

class _DialogCloseButton extends StatelessWidget {
  const _DialogCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Icon(
        Icons.close,
        size: AppSizes.rechargePurchaseDialogCloseIconSize,
        color: AppColors.iconMuted,
      ),
    );
  }
}

class _DialogPrice extends StatelessWidget {
  const _DialogPrice({required this.priceYuan});

  final int priceYuan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText(
        '$priceYuan元',
        style: AppTextStyles.rechargePurchaseDialogPrice,
      ),
    );
  }
}

class _PaymentMethodList extends StatelessWidget {
  const _PaymentMethodList({
    required this.selectedMethod,
    required this.onMethodTap,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodTap;

  @override
  Widget build(BuildContext context) {
    return Column(
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

  static const String _wechatAsset = 'assets/icons/payment/wechat_pay.png';
  static const String _alipayAsset = 'assets/icons/payment/alipay.png';

  @override
  Widget build(BuildContext context) {
    return AppAssetImage(
      assetPath: method == PaymentMethod.wechat ? _wechatAsset : _alipayAsset,
      width: AppSizes.welfareRechargeInfoIconSize,
      height: AppSizes.welfareRechargeInfoIconSize,
    );
  }
}

class _AgreementFooter extends StatelessWidget {
  const _AgreementFooter({required this.agreementTitle, this.onAgreementTap});

  final String agreementTitle;
  final VoidCallback? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText('查看', style: AppTextStyles.rechargePurchaseDialogAgreement),
        GestureDetector(
          onTap: onAgreementTap,
          behavior: HitTestBehavior.opaque,
          child: AppText(
            '《$agreementTitle》',
            style: AppTextStyles.rechargePurchaseDialogAgreementLink,
          ),
        ),
      ],
    );
  }
}
