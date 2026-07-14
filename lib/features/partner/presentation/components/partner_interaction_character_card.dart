import 'package:flutter/material.dart';

import '../../../../core/theme/app_partner_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/partner_interaction_scene.dart';

/// L3 — 互动场景左上角色信息卡。
class PartnerInteractionCharacterCard extends StatelessWidget {
  const PartnerInteractionCharacterCard({
    super.key,
    required this.scene,
    this.onTap,
  });

  final PartnerInteractionScene scene;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.partnerInteractionCharacterCardPaddingH,
          vertical: AppSizes.partnerInteractionCharacterCardPaddingV,
        ),
        decoration: BoxDecoration(
          color: AppPartnerColors.interactionCharacterCardBg,
          borderRadius: BorderRadius.circular(
            AppSizes.partnerInteractionCharacterCardRadius,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  scene.characterName,
                  style: AppTextStyles.partnerInteractionCharacterName,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.favorite,
                      size: AppSizes.partnerMessageAffectionIconSize,
                      color: AppPartnerColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    AppText(
                      '${scene.affectionLevel} ${scene.upgradeHint}',
                      style: AppTextStyles.partnerInteractionUpgradeHint,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.help_outline,
              size: AppSizes.partnerInteractionSideActionIconSize,
              color: AppPartnerColors.textSecondary,
            ),
            const AppIcon(
              assetPath: 'assets/icons/arrow_right.svg',
              width: AppSizes.partnerInteractionSideActionIconSize,
              height: AppSizes.partnerInteractionSideActionIconSize,
              color: AppPartnerColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
