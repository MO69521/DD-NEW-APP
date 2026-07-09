import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_hero_slide.dart';

/// L3 — 会员页 Hero 单页主张文案。
class MembershipHeroSlideText extends StatelessWidget {
  const MembershipHeroSlideText({super.key, required this.slide});

  final MembershipHeroSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: slide.titlePrefix,
                style: AppTextStyles.membershipHeroEnergyLabel,
              ),
              const WidgetSpan(child: SizedBox(width: AppSpacing.xxs)),
              TextSpan(
                text: slide.titleHighlight,
                style: AppTextStyles.membershipHeroEnergyAmount,
              ),
              if (slide.titleSuffix.isNotEmpty) ...[
                const WidgetSpan(child: SizedBox(width: AppSpacing.xxs)),
                TextSpan(
                  text: slide.titleSuffix,
                  style: AppTextStyles.membershipHeroEnergyLabel,
                ),
              ],
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              slide.subtitlePrefix,
              style: AppTextStyles.membershipHeroSubtitle.copyWith(
                color: AppColors.textOnDarkMuted,
              ),
            ),
            if (slide.subtitleValue.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.xxs),
              AppText(
                slide.subtitleValue,
                style: AppTextStyles.membershipHeroSubtitle,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
