import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/book_catalog_chapter.dart';
import '../../domain/entities/book_detail.dart';

/// 书籍详情目录侧边抽屉（深色态）。
class BookDetailCatalogDrawer {
  static Future<void> show(
    BuildContext context, {
    required BookDetail detail,
    ValueChanged<BookCatalogChapter>? onChapterTap,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '目录',
      barrierColor: AppColors.overlayScrim,
      transitionDuration: AppDurations.normal,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: _CatalogDrawerPanel(
            detail: detail,
            onChapterTap: onChapterTap,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation =
            Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

class _CatalogDrawerPanel extends StatelessWidget {
  const _CatalogDrawerPanel({required this.detail, this.onChapterTap});

  final BookDetail detail;
  final ValueChanged<BookCatalogChapter>? onChapterTap;

  @override
  Widget build(BuildContext context) {
    final drawerWidth =
        MediaQuery.sizeOf(context).width *
        AppSizes.bookDetailCatalogDrawerWidthRatio;

    return Material(
      color: AppColors.dialogBackground,
      child: SizedBox(
        width: drawerWidth,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CatalogHeader(detail: detail),
              const Divider(
                height: AppSizes.hairline,
                thickness: AppSizes.hairline,
                color: AppColors.borderGlass,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.bookDetailCatalogDrawerHeaderPaddingH,
                  ),
                  itemCount: detail.catalogChapters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.xxs),
                  itemBuilder: (context, index) {
                    final chapter = detail.catalogChapters[index];
                    return _CatalogChapterRow(
                      chapter: chapter,
                      onTap: onChapterTap == null
                          ? null
                          : () => onChapterTap!(chapter),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({required this.detail});

  final BookDetail detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.bookDetailCatalogDrawerHeaderPaddingH,
        vertical: AppSizes.bookDetailCatalogDrawerHeaderPaddingV,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppSizes.bookDetailCatalogDrawerCoverHeight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                AppRadius.bookDetailCatalogDrawerCover,
              ),
              child: AppAssetImage(
                assetPath: detail.coverAsset,
                width: AppSizes.bookDetailCatalogDrawerCoverWidth,
                height: AppSizes.bookDetailCatalogDrawerCoverHeight,
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
                    detail.title,
                    style: AppTextStyles.bookDetailCatalogDrawerTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AppText(
                    detail.serialStatus,
                    style: AppTextStyles.bookDetailCatalogMeta,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            AppPressable(
              onTap: AppRouter.pop,
              child: const AppIcon(
                assetPath: 'assets/icons/arrow_right.svg',
                width: AppSizes.bookDetailCatalogArrowSize,
                height: AppSizes.bookDetailCatalogArrowSize,
                color: AppColors.textOnDarkPlaceholder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogChapterRow extends StatelessWidget {
  const _CatalogChapterRow({required this.chapter, this.onTap});

  final BookCatalogChapter chapter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.bookDetailCatalogChapterPaddingV,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppText(
                chapter.title,
                style: AppTextStyles.bookDetailCatalogChapterTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (chapter.isLocked) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                Icons.lock_outline,
                size: AppSizes.bookDetailCatalogLockIconSize,
                color: AppColors.iconMutedSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
