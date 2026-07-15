import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_welfare_colors.dart';
import '../../../../core/theme/app_icon_assets.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/achievement_badge.dart';

/// L3 — 我的页「我的成就」勋章模块：标题 + 已获得数量 + 查看详情 + 勋章缩略图。
class ProfileAchievementSection extends StatelessWidget {
  const ProfileAchievementSection({
    super.key,
    required this.earnedCount,
    required this.badges,
    this.onViewDetail,
  });

  final int earnedCount;
  final List<AchievementBadge> badges;
  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(earnedCount: earnedCount, onViewDetail: onViewDetail),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              for (final badge in badges)
                Expanded(
                  child: Center(
                    child: AppAssetImage(
                      assetPath: badge.iconAsset,
                      width: AppSizes.profileAchievementMedalSize,
                      height: AppSizes.profileAchievementMedalSize,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.earnedCount, this.onViewDetail});

  final int earnedCount;
  final VoidCallback? onViewDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          '我的成就',
          style: AppTextStyles.welfareSectionTitle.copyWith(
            color: AppColors.textOnDark,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxsHalf),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AppText('共获得', style: AppTextStyles.welfareSubtitle),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText(
                '$earnedCount',
                style: AppTextStyles.labelMediumDark.copyWith(
                  color: AppWelfareColors.accentOrange,
                ),
              ),
              const SizedBox(width: AppSpacing.xxsHalf),
              AppText('枚勋章', style: AppTextStyles.welfareSubtitle),
            ],
          ),
        ),
        const Spacer(),
        AppPressable(
          onTap: onViewDetail,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText('查看详情', style: AppTextStyles.welfareSubtitle),
              const SizedBox(width: AppSpacing.xxs),
              const AppIcon(
                assetPath: AppIconAssets.arrowRight,
                width: AppSizes.profileAchievementActionIconSize,
                height: AppSizes.profileAchievementActionIconSize,
                color: AppColors.textOnDarkMuted,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
