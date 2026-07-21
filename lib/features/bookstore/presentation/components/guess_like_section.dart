import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/book_cover_tag_badge.dart';
import '../../../../shared/components/book_cover_bottom_badge.dart';
import '../../../../shared/components/section_header.dart';
import '../../../../shared/widgets/app_pressable.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';

/// 猜你喜欢区块：2 列卡片，含标题/摘要/注释标签。
class GuessLikeSection extends StatelessWidget {
  const GuessLikeSection({super.key, required this.books, this.onBookTap});

  final List<Book> books;

  /// 回调携带该卡封面的屏内唯一 Hero 标签，供详情页同 tag 飞行。
  final void Function(Book book, Object coverHeroTag)? onBookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '猜你喜欢'),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - AppSpacing.md) / 2;
            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final book in books)
                  SizedBox(
                    width: itemWidth,
                    child: Builder(
                      builder: (context) {
                        final heroTag = 'book-cover-guesslike-${book.id}';
                        return _GuessLikeBookCard(
                          book: book,
                          heroTag: heroTag,
                          onTap: onBookTap == null
                              ? null
                              : () => onBookTap!(book, heroTag),
                        );
                      },
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

class _GuessLikeBookCard extends StatelessWidget {
  const _GuessLikeBookCard({required this.book, this.heroTag, this.onTap});

  static const String _defaultSummary =
      '在这个充满竞争的商业世界里，病娇总裁李昊天以其独特的魅力和阴郁个性吸引了众多追随者。';
  static const List<String> _defaultAnnotations = ['纯爱', '升级流', '系统'];

  final Book book;
  final Object? heroTag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final summary = (book.summary == null || book.summary!.trim().isEmpty)
        ? _defaultSummary
        : book.summary!;
    final annotations = book.annotations.isEmpty
        ? _defaultAnnotations
        : book.annotations;

    return AppPressable(
      onTap: onTap,
      pressScale: AppSizes.tapPressScaleSubtle,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.guessLikeCardBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              assetPath: book.coverAsset,
              aspectRatio: AppSizes.bookCoverGridAspectRatio,
              heroTag: heroTag,
              topEndBadge: book.coverTag == null
                  ? null
                  : BookCoverTagBadge(tag: book.coverTag!),
              bottomEndBadge: book.coverBottomBadge == null
                  ? null
                  : BookCoverBottomBadgeView(badge: book.coverBottomBadge!),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    book.title,
                    style: AppTextStyles.bookTitleDark,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // 摘要区固定两行，保持卡片瀑布流阅读节奏稳定。
                  AppText(
                    summary,
                    style: AppTextStyles.bookGuessLikeSummaryDark,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  // 注释标签使用弱对比胶囊，表达题材关键词，不抢封面视觉焦点。
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final annotation in annotations)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.guessLikeTagBackground,
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                            border: Border.all(
                              color: AppColors.guessLikeTagBorder,
                              width: AppSizes.hairline,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xxs,
                            ),
                            child: AppText(
                              annotation,
                              style: AppTextStyles.bookGuessLikeTagDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
