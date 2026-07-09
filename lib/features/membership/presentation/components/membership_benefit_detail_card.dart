import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/membership_benefit_detail.dart';

/// L3 — 会员特权详情卡片。
class MembershipBenefitDetailCard extends StatelessWidget {
  const MembershipBenefitDetailCard({super.key, required this.benefit});

  static const double _exampleImageAspectRatio = 1;

  final MembershipBenefitDetail benefit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                benefit.label,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppText(
                benefit.description,
                style: AppTextStyles.bodyMediumDark.copyWith(
                  color: AppColors.textOnDarkMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AspectRatio(
                aspectRatio: _exampleImageAspectRatio,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGlass,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(
                      color: AppColors.borderGlass,
                      width: AppSizes.hairline,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: AppSizes.membershipBenefitExampleIconSize,
                          color: AppColors.textOnDarkPlaceholder,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppText(
                          '示例图占位',
                          style: AppTextStyles.captionMd.copyWith(
                            color: AppColors.textOnDarkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
