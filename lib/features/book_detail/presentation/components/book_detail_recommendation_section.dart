import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_durations.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/book_grid_card.dart';
import '../../../../shared/components/section_header.dart';
import '../../../../shared/widgets/app_icon.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';

/// L3 — 书籍详情页推荐书籍区块，复用首页网格书卡样式。
class BookDetailRecommendationSection extends StatelessWidget {
  const BookDetailRecommendationSection({
    super.key,
    required this.title,
    required this.books,
    this.actionLabel,
    this.actionIconAsset,
    this.rotateActionIconOnTap = false,
    this.onActionTap,
    this.onBookTap,
  });

  final String title;
  final List<Book> books;
  final String? actionLabel;
  final String? actionIconAsset;
  final bool rotateActionIconOnTap;
  final VoidCallback? onActionTap;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rotateActionIconOnTap)
          _RotatingRecommendationHeader(
            title: title,
            actionLabel: actionLabel,
            actionIconAsset: actionIconAsset ?? 'assets/icons/arrow_right.svg',
            onActionTap: onActionTap,
          )
        else
          SectionHeader(
            title: title,
            actionLabel: actionLabel,
            actionIconAsset: actionIconAsset ?? 'assets/icons/arrow_right.svg',
            onActionTap: onActionTap,
          ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 3;
            final totalSpacing = AppSpacing.md * (crossAxisCount - 1);
            final itemWidth =
                (constraints.maxWidth - totalSpacing) / crossAxisCount;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final book in books)
                  SizedBox(
                    width: itemWidth,
                    child: BookGridCard(
                      title: book.title,
                      category: book.category,
                      coverAsset: book.coverAsset,
                      coverTag: book.coverTag,
                      onTap: onBookTap == null ? null : () => onBookTap!(book),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _RotatingRecommendationHeader extends StatefulWidget {
  const _RotatingRecommendationHeader({
    required this.title,
    required this.actionIconAsset,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final String actionIconAsset;
  final VoidCallback? onActionTap;

  @override
  State<_RotatingRecommendationHeader> createState() =>
      _RotatingRecommendationHeaderState();
}

class _RotatingRecommendationHeaderState
    extends State<_RotatingRecommendationHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.normal,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0);
    widget.onActionTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          widget.title,
          style: AppTextStyles.sectionTitleDark.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
        const Spacer(),
        if (widget.actionLabel != null)
          AppPressable(
            onTap: _handleTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  widget.actionLabel!,
                  style: AppTextStyles.bookTagDark.copyWith(
                    color: AppColors.textOnDarkMuted,
                  ),
                ),
                const SizedBox(width: AppSpacing.xxs),
                RotationTransition(
                  turns: _controller,
                  child: AppIcon(
                    assetPath: widget.actionIconAsset,
                    width: AppSizes.bookDetailRecommendationActionIconSize,
                    height: AppSizes.bookDetailRecommendationActionIconSize,
                    color: AppColors.sectionActionIcon,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
