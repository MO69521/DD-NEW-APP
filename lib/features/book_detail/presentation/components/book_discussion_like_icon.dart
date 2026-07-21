import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_theme_assets.dart';
import '../../../../shared/widgets/app_icon.dart';

/// 讨论区点赞图标（未赞线稿可染色；已赞为橙填色稿，不染色）。
class BookDiscussionLikeIcon extends StatelessWidget {
  const BookDiscussionLikeIcon({
    super.key,
    required this.isLiked,
    this.size = AppSizes.bookDetailDiscussionLikeIconSize,
    this.inactiveColor = AppColors.discussionLikeIcon,
  });

  final bool isLiked;
  final double size;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return AppIcon(
      assetPath: isLiked
          ? AppThemeAssets.bookDetailLikeActive
          : AppThemeAssets.bookDetailLike,
      width: size,
      height: size,
      color: isLiked ? null : inactiveColor,
    );
  }
}
