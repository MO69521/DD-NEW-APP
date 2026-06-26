import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_text.dart';

/// 作者行：小头像 + 作者名（Figma 185:2344）。
class BookDetailAuthorRow extends StatelessWidget {
  const BookDetailAuthorRow({
    super.key,
    required this.author,
    required this.avatarAsset,
  });

  final String author;
  final String avatarAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: AppAssetImage(
            assetPath: avatarAsset,
            width: AppSizes.bookDetailAuthorAvatarSize,
            height: AppSizes.bookDetailAuthorAvatarSize,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        AppText(author, style: AppTextStyles.bookDetailAuthor),
      ],
    );
  }
}
