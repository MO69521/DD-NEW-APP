import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_marquee_text.dart';
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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.white04,
                width: AppSizes.hairline,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _CardBackdrop(coverAsset: book.coverAsset),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
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
                            AppMarqueeText(
                              text: book.title,
                              style: AppTextStyles.bodyMediumDark,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 背景层：页面背景色之上叠放大封面（宽度撑满卡片、上下左右居中），
/// 半透明 + 强模糊，不同书籍呈现不同底纹。
class _CardBackdrop extends StatelessWidget {
  const _CardBackdrop({required this.coverAsset});

  final String coverAsset;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: AppSizes.continueReadingBgImageOpacity,
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: AppSizes.continueReadingBgBlurSigma,
            sigmaY: AppSizes.continueReadingBgBlurSigma,
          ),
          child: AppAssetImage(
            assetPath: coverAsset,
            fit: BoxFit.fitWidth,
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
    return AppButton(
      label: '继续阅读',
      variant: AppButtonVariant.accent,
      size: AppButtonSize.small,
      onPressed: onTap,
    );
  }
}
