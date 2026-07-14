import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../application/help_feedback_state.dart';

/// 问题截图上传区：已选缩略图 + 「点击上传」方形位（未达上限时展示）。
class HelpFeedbackUploadSection extends StatelessWidget {
  const HelpFeedbackUploadSection({
    super.key,
    required this.paths,
    this.onPick,
    this.onRemove,
  });

  final List<String> paths;
  final VoidCallback? onPick;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    final canAdd = paths.length < HelpFeedbackState.maxScreenshots;
    const perRow = HelpFeedbackState.maxScreenshots; // 一行展示 4 个
    const spacing = AppSpacing.sm;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 方形位宽度按「一行 4 个」等分可用宽度（floor 避免亚像素换行）。
        final tileSize =
            ((constraints.maxWidth - spacing * (perRow - 1)) / perRow)
                .floorToDouble();
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final path in paths)
              _ScreenshotThumbnail(
                path: path,
                size: tileSize,
                onRemove: onRemove == null ? null : () => onRemove!(path),
              ),
            if (canAdd) _AddUploadTile(size: tileSize, onTap: onPick),
          ],
        );
      },
    );
  }
}

class _AddUploadTile extends StatelessWidget {
  const _AddUploadTile({required this.size, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 1:1 方形上传位：纯白 4% 填充，无描边。
    return AppPressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_rounded,
              color: AppColors.textOnDarkMuted,
              size: AppSizes.topBarActionIconSize,
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppText(
              '点击上传',
              style: AppTextStyles.captionMdDarkMuted,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenshotThumbnail extends StatelessWidget {
  const _ScreenshotThumbnail({
    required this.path,
    required this.size,
    this.onRemove,
  });

  final String path;
  final double size;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.md);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: radius,
              child: Image.file(File(path), fit: BoxFit.cover),
            ),
          ),
          if (onRemove != null)
            Positioned(
              top: -AppSpacing.xs,
              right: -AppSpacing.xs,
              child: AppPressable(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.xxsHalf),
                  decoration: const BoxDecoration(
                    color: AppColors.overlayScrim80,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: AppSizes.helpFeedbackUploadRemoveIconSize,
                    color: AppColors.textOnDark,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
