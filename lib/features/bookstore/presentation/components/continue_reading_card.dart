import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 首页底部「继续阅读」浮层卡片：封面 + 书名 + 继续阅读按钮 + 关闭。
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({
    super.key,
    required this.book,
    this.onContinue,
    this.onClose,
  });

  final Book book;
  final VoidCallback? onContinue;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onContinue,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppSizes.strongBlurSigma,
              sigmaY: AppSizes.strongBlurSigma,
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.white04,
                  width: AppSizes.hairline,
                ),
              ),
              child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.bookCover),
              child: AppAssetImage(
                assetPath: book.coverAsset,
                width: AppSizes.continueReadingCoverWidth,
                height: AppSizes.continueReadingCoverHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    '继续阅读',
                    style: AppTextStyles.captionSm.copyWith(
                      color: AppColors.white60,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxsHalf),
                  AppText(
                    book.title,
                    style: AppTextStyles.bodyMediumDark,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _ContinueButton(onTap: onContinue),
            const SizedBox(width: AppSpacing.xxs),
            AppPressable(
              onTap: onClose,
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.xxs),
                child: Icon(
                  Icons.close,
                  size: AppSizes.continueReadingCloseIconSize,
                  color: AppColors.textOnDarkMuted,
                ),
              ),
            ),
          ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentYellow,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AppText(
          '继续阅读',
          style: AppTextStyles.welfareCtaText.copyWith(
            color: AppColors.rankingSegmentedSelectedText,
          ),
        ),
      ),
    );
  }
}
