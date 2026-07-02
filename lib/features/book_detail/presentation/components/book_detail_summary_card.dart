import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';
import '../../domain/entities/book_detail.dart';

/// L3 — 书籍摘要卡：左封面 + 右文（参考浅色版左图右文布局）。
class BookDetailSummaryCard extends StatelessWidget {
  const BookDetailSummaryCard({super.key, required this.detail});

  final BookDetail detail;

  String get _tagMeta => detail.tags.join(' / ');

  String get _statusMeta {
    final serialLabel = detail.serialStatus.split('·').first.trim();
    return '$serialLabel · ${detail.wordCount}万字 · ${detail.popularity}万热度';
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.lg);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.bookDetailGlassBlurSigma,
          sigmaY: AppSizes.bookDetailGlassBlurSigma,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: radius,
            border: Border.all(
              color: AppColors.borderGlass,
              width: AppSizes.hairline,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.coverSm),
                child: BookCover(
                  assetPath: detail.coverAsset,
                  width: AppSizes.bookDetailSummaryCoverWidth,
                  height: AppSizes.bookDetailSummaryCoverHeight,
                ),
              ),
              const SizedBox(width: AppSizes.bookCardLargeCoverToTextGap),
              Expanded(
                child: SizedBox(
                  height: AppSizes.bookDetailSummaryCoverHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        detail.title,
                        style: AppTextStyles.bookDetailSummaryTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        _tagMeta,
                        style: AppTextStyles.bookDetailSummaryMeta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            child: AppAssetImage(
                              assetPath: detail.authorAvatarAsset,
                              width: AppSizes.bookDetailAuthorAvatarSize,
                              height: AppSizes.bookDetailAuthorAvatarSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xxs),
                          Expanded(
                            child: AppText(
                              detail.author,
                              style: AppTextStyles.bookDetailAuthor.copyWith(
                                color: AppColors.textOnDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      AppText(
                        _statusMeta,
                        style: AppTextStyles.bookDetailSummaryMeta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
