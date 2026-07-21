import 'package:flutter/material.dart';

import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_shared_assets.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../shared/widgets/app_asset_image.dart';
import '../../../../shared/widgets/app_pressable.dart';

/// 讨论 Tab「写评论」悬浮按钮：贴右；有促销条时叠在其上方，无则距底栏 12。
class BookDetailWriteCommentFab extends StatelessWidget {
  const BookDetailWriteCommentFab({
    super.key,
    required this.hasPromoBar,
    this.onTap,
  });

  final bool hasPromoBar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: AppDurations.normal,
      curve: Curves.easeInOut,
      right: 0,
      bottom: hasPromoBar ? 0 : AppSizes.bookDetailWriteCommentFabBottomGap,
      child: AppPressable(
        onTap: onTap,
        child: const AppAssetImage(
          assetPath: AppSharedAssets.bookDetailWriteCommentFab,
          width: AppSizes.bookDetailWriteCommentFabSize,
          height: AppSizes.bookDetailWriteCommentFabSize,
        ),
      ),
    );
  }
}
