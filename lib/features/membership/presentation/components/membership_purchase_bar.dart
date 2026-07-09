import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_membership_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_agreement.dart';
import 'membership_cta_button.dart';

/// L3 — 开通区：粉色渐变 CTA + 协议链接。
class MembershipPurchaseBar extends StatelessWidget {
  const MembershipPurchaseBar({
    super.key,
    required this.priceText,
    required this.agreementPrefix,
    required this.agreementSuffix,
    required this.agreements,
    required this.isPurchasing,
    this.onPurchase,
    this.onAgreementTap,
  });

  final String priceText;
  final String agreementPrefix;
  final String agreementSuffix;
  final List<MembershipAgreement> agreements;
  final bool isPurchasing;
  final VoidCallback? onPurchase;
  final ValueChanged<MembershipAgreement>? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MembershipCtaButton(
          isLoading: isPurchasing,
          onTap: onPurchase,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '确认协议并开通',
                style: AppTextStyles.membershipCtaLabel,
              ),
              const SizedBox(width: AppSpacing.xs),
              AppText('¥', style: AppTextStyles.membershipCtaPriceSymbol),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText(priceText, style: AppTextStyles.membershipCtaPriceValue),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _AgreementText(
          prefix: agreementPrefix,
          suffix: agreementSuffix,
          agreements: agreements,
          onAgreementTap: onAgreementTap,
        ),
      ],
    );
  }
}

class _AgreementText extends StatelessWidget {
  const _AgreementText({
    required this.prefix,
    required this.suffix,
    required this.agreements,
    this.onAgreementTap,
  });

  final String prefix;
  final String suffix;
  final List<MembershipAgreement> agreements;
  final ValueChanged<MembershipAgreement>? onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.membershipAgreement.copyWith(
      color: AppColors.textOnDarkMuted,
    );
    final link = AppTextStyles.membershipAgreement.copyWith(
      color: AppMembershipColors.agreementLink,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: AppSpacing.xxs,
      children: [
        AppText(prefix, style: muted),
        for (var i = 0; i < agreements.length; i++) ...[
          if (i > 0) AppText('｜', style: muted),
          GestureDetector(
            onTap: () => onAgreementTap?.call(agreements[i]),
            behavior: HitTestBehavior.opaque,
            child: AppText(agreements[i].title, style: link),
          ),
        ],
        AppText(suffix, style: muted),
      ],
    );
  }
}
