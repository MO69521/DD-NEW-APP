import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';
import '../../domain/entities/book_detail.dart';

/// 角色介绍卡：封面 + 角色名 + 收藏和表白按钮（Figma 579:26109）。
class BookDetailCharacterCard extends StatelessWidget {
  const BookDetailCharacterCard({
    super.key,
    required this.character,
    this.onFavTap,
  });

  final BookCharacter character;
  final VoidCallback? onFavTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.bookDetailCharCoverWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            assetPath: character.coverAsset,
            width: AppSizes.bookDetailCharCoverWidth,
            height: AppSizes.bookDetailCharCoverHeight,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppText(
            character.name,
            style: AppTextStyles.bookDetailCharName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          _FavButton(onTap: onFavTap),
        ],
      ),
    );
  }
}

class _FavButton extends StatelessWidget {
  const _FavButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.bookDetailCharFavPaddingH,
          vertical: AppSizes.bookDetailCharFavPaddingV,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.bookDetailCharFav),
        ),
        child: const AppText(
          '收藏和表白',
          style: AppTextStyles.bookDetailCharFav,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
