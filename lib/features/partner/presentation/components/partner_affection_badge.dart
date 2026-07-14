import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 好感度心形徽章（粉色底 + 数字）。
class PartnerAffectionBadge extends StatelessWidget {
  const PartnerAffectionBadge({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.partnerMessageAffectionBadgeHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.partnerMessageAffectionBadgePaddingH,
      ),
      decoration: BoxDecoration(
        color: AppPartnerColors.affectionBadgeBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite,
            size: AppSizes.partnerMessageAffectionIconSize,
            color: AppPartnerColors.textOnPrimary,
          ),
          const SizedBox(width: AppSpacing.xxs),
          AppText('$level', style: AppTextStyles.partnerAffectionBadge),
        ],
      ),
    );
  }
}
