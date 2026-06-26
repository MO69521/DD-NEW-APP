import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 角色卡底部紫色人设标签。
class PartnerTraitTag extends StatelessWidget {
  const PartnerTraitTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: AppSizes.partnerTraitTagHeight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerTraitTagPaddingH,
        vertical: AppSizes.partnerTraitTagPaddingV,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppPartnerColors.tagPurpleBg,
        borderRadius: BorderRadius.circular(AppRadius.partnerTraitTag),
        border: Border.all(
          color: AppPartnerColors.tagPurpleBorder,
          width: AppSizes.hairline,
        ),
      ),
      child: AppText(label, style: AppTextStyles.partnerTraitTag),
    );
  }
}
