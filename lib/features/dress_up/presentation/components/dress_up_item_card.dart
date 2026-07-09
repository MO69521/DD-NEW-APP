import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../domain/entities/dress_up_item.dart';

/// L3 — 单个装扮项卡片：缩略图 + 名称 + 有效期。
class DressUpItemCard extends StatelessWidget {
  const DressUpItemCard({
    super.key,
    required this.item,
    this.isSelected = false,
    this.onTap,
  });

  final DressUpItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: _Thumbnail(item: item, isSelected: isSelected),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppText(
            item.name,
            style: AppTextStyles.bodyMediumDark,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xxs),
          AppText(
            item.validityLabel,
            style: AppTextStyles.captionMdDarkMuted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.item, required this.isSelected});

  final DressUpItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    final border = Border.all(
      color: isSelected ? AppColors.accentYellow : AppColors.borderGlass,
      width: isSelected ? AppSizes.borderWidthEmphasis : AppSizes.hairline,
    );

    final image = ClipRRect(
      borderRadius: radius,
      child: item.thumbnailAsset.isEmpty
          ? const _ThumbnailPlaceholder()
          : Image.asset(
              item.thumbnailAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _ThumbnailPlaceholder(),
            ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: radius,
        border: border,
      ),
      // 选中态：边框与图片之间留间隙，形成描边环。
      child: isSelected
          ? Padding(
              padding: const EdgeInsets.all(AppSpacing.xxs),
              child: image,
            )
          : image,
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  /// 占位图标相对缩略图的比例，避免为 mock 占位新增尺寸 token。
  static const double _iconScale = 0.32;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Icon(
            Icons.image_outlined,
            color: AppColors.textOnDarkMuted,
            size: constraints.maxWidth * _iconScale,
          ),
        );
      },
    );
  }
}
