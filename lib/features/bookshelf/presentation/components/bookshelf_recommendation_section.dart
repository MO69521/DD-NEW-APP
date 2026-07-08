import 'package:flutter/material.dart';

import '../../../../core/domain/entities/book.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/components/section_header.dart';
import '../../../../shared/widgets/app_text.dart';
import '../../../../shared/widgets/book_cover.dart';

/// 书架下方推荐瀑布流，独立于用户已加入书架的书单。
class BookshelfRecommendationSection extends StatelessWidget {
  const BookshelfRecommendationSection({
    super.key,
    required this.books,
    this.onBookTap,
  });

  final List<Book> books;
  final ValueChanged<Book>? onBookTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '为你推荐'),
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
                    child: _BookshelfRecommendationCard(
                      book: book,
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

class _BookshelfRecommendationCard extends StatelessWidget {
  const _BookshelfRecommendationCard({required this.book, this.onTap});

  static const String _defaultSummary = '精选高热剧情与人气设定，适合从书架继续发现下一本想读的故事。';
  static const List<String> _defaultAnnotations = ['高甜', '爽文', '人气'];

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final summary = (book.summary == null || book.summary!.trim().isEmpty)
        ? _defaultSummary
        : book.summary!;
    final annotations = book.annotations.isEmpty
        ? _defaultAnnotations
        : book.annotations;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
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
                  AppText(
                    summary,
                    style: AppTextStyles.bookGuessLikeSummaryDark,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
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
