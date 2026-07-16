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
import '../../../../shared/widgets/book_cover_hero.dart';

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

  /// 封面 Hero 标签（确定式，供跳转入口 `goBookDetail(coverHeroTag:)` 复用）。
  static String heroTagFor(Book book) => 'book-cover-continue-${book.id}';

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onContinue,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        // 外层 Stack 不裁剪，使封面可溢出卡片顶部（悬浮抬起）。
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildCardBody(),
            // 封面覆盖层：贴卡片底内边距，放大后向上溢出卡片顶部。
            Positioned(
              left: AppSpacing.xs,
              bottom: AppSpacing.xs,
              width: AppSizes.continueReadingCoverWidth,
              height: AppSizes.continueReadingCoverHeight,
              child: Hero(
                tag: heroTagFor(book),
                createRectTween: bookCoverHeroRectTween,
                flightShuttleBuilder: bookCoverHeroFlightShuttleBuilder,
                child: _CoverThumb(coverAsset: book.coverAsset),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBody() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.continueReadingCardBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.continueReadingCardBorder,
            width: AppSizes.hairline,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _CardBackdrop(coverAsset: book.coverAsset)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Row(
                children: [
                  // 为溢出的封面覆盖层预留横向占位。
                  const SizedBox(width: AppSizes.continueReadingCoverWidth),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          '继续阅读',
                          style: AppTextStyles.captionSm.copyWith(
                            color: AppColors.continueReadingCaptionText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxsHalf),
                        AppMarqueeText(
                          text: book.title,
                          style: AppTextStyles.bodyMediumDark.copyWith(
                            color: AppColors.continueReadingTitleText,
                          ),
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
                        color: AppColors.continueReadingCloseIcon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 悬浮抬起的封面缩略图：圆角 + 投影，尺寸略大于卡片以溢出顶部。
class _CoverThumb extends StatelessWidget {
  const _CoverThumb({required this.coverAsset});

  final String coverAsset;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.bookCover),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black40, // light-audit: effect 投影阴影
            blurRadius: AppSizes.continueReadingCoverShadowBlur,
            offset: Offset(0, AppSpacing.xxs),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.bookCover),
        child: AppAssetImage(
          assetPath: coverAsset,
          width: AppSizes.continueReadingCoverWidth,
          height: AppSizes.continueReadingCoverHeight,
          fit: BoxFit.cover,
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
          child: AppAssetImage(assetPath: coverAsset, fit: BoxFit.fitWidth),
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
