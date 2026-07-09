import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// 目录入口（Figma 579:26079）。
class BookDetailCatalogEntry extends StatelessWidget {
  const BookDetailCatalogEntry({
    super.key,
    required this.serialStatus,
    this.onTap,
  });

  final String serialStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.bookDetailCatalog);

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppSizes.bookDetailGlassBlurSigma,
            sigmaY: AppSizes.bookDetailGlassBlurSigma,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.bookDetailCatalogPaddingH,
              vertical: AppSizes.bookDetailCatalogPaddingV,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: radius,
              border: Border.all(
                color: AppColors.borderGlass,
                width: AppSizes.hairline,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText('目录', style: AppTextStyles.bookDetailBlockTitle),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      serialStatus,
                      style: AppTextStyles.bookDetailCatalogMeta,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const AppIcon(
                      assetPath: 'assets/icons/arrow_right.svg',
                      width: AppSizes.bookDetailCatalogArrowSize,
                      height: AppSizes.bookDetailCatalogArrowSize,
                      color: AppColors.textOnDarkPlaceholder,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
