import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/book_card_surface.dart';
import '../../../../shared/widgets/app_selection_mark.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';

/// 书架管理态书卡：封面右下角显示多选控件。
class BookshelfSelectableBookCard extends StatelessWidget {
  const BookshelfSelectableBookCard({
    super.key,
    required this.book,
    required this.isManaging,
    required this.isSelected,
    this.onTap,
  });

  final Book book;
  final bool isManaging;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: BookCardSurface(
        contentPadding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                BookCover(
                  assetPath: book.coverAsset,
                  aspectRatio: AppSizes.bookCoverGridAspectRatio,
                  overlayColor: isManaging
                      ? (isSelected
                            ? AppColors.bookshelfManageCoverOverlaySelected
                            : AppColors.bookshelfManageCoverOverlay)
                      : null,
                ),
                if (isManaging)
                  Positioned(
                    right: AppSpacing.xxs,
                    bottom: AppSpacing.xxs,
                    // 压在封面上的未选中圈用泛白样式，保证任意封面上可见。
                    child: AppSelectionMark(
                      isSelected: isSelected,
                      unselectedBackgroundColor:
                          AppColors.selectionMarkOnCoverUnselectedFill,
                      unselectedBorderColor:
                          AppColors.selectionMarkOnCoverUnselectedBorder,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: BookCardSurface.padding,
                top: AppSizes.bookGridCoverToTextGap,
                right: BookCardSurface.padding,
                bottom: BookCardSurface.padding,
              ),
              child: SizedBox(
                height: AppSizes.bookGridTextBlockHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      book.title,
                      style: AppTextStyles.bookGridTitleDark.copyWith(
                        color: AppColors.textOnDark,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSizes.bookGridTitleCategoryGap),
                    AppText(
                      book.category,
                      style: AppTextStyles.bookTagDark.copyWith(
                        color: AppColors.textOnDarkMuted,
                      ),
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
    );
  }
}
